module Main exposing (main)

import Array
import Browser
import Browser.Dom as Dom exposing (Viewport)
import Browser.Events as Events
import Browser.Navigation as Navigation
import Data.Example as Example exposing (Example)
import Data.Section as Section exposing (Section(..))
import Data.Style exposing (Style)
import Data.Theme as Theme exposing (Theme(..))
import Element exposing (DeviceClass(..), Element,Attribute)
import Element.Input as Input
import FeatherIcons
import Framework
import Framework.Grid as Grid
import Framework.Heading as Heading
import Html exposing (Html)
import Html.Attributes as Attributes
import Icons
import Reusable
import Set.Any as AnySet exposing (AnySet)
import Stateless
import Task
import Time
import Widget exposing (Modal,TextInput)
import Widget.Icon as Icon
import Widget.Layout as Layout exposing (Part)
import Widget.ScrollingNav as ScrollingNav
import Widget.Snackbar as Snackbar exposing (Message)
import Material.Icons.Types exposing (Coloring(..))
import Material.Icons
import Widget.Material.Typography as Typography


type Part
    = LeftSheet
    | RightSheet
    | Search

type alias LoadedModel =
    { stateless : Stateless.Model
    , scrollingNav : ScrollingNav.ScrollingNav Example
    , snackbar : Snackbar.Snackbar (Message LoadedMsg)
    , active : Maybe Part
    , displayDialog : Bool
    , window :
        { height : Int
        , width : Int
        }
    , search :
        { raw : String
        , current : String
        , remaining : Int
        }
    , theme : Theme
    , expanded : AnySet String Example
    }


type Model
    = Loading
    | Loaded LoadedModel


type LoadedMsg
    = StatelessSpecific Stateless.Msg
    | UpdateScrollingNav (ScrollingNav.ScrollingNav Example -> ScrollingNav.ScrollingNav Example)
    | TimePassed Int
    | AddSnackbar ( String, Bool )
    | ToggleDialog Bool
    | ChangedSidebar (Maybe Part)
    | Resized { width : Int, height : Int }
    | Load String
    | JumpTo Example
    | ChangedSearch String
    | SetTheme Theme
    | Idle
    | ToggledExample Example


type Msg
    = LoadedSpecific LoadedMsg
    | GotViewport Viewport


initialModel : Viewport -> ( LoadedModel, Cmd LoadedMsg )
initialModel { viewport } =
    let
        ( scrollingNav, cmd ) =
            ScrollingNav.init
                { toString = Example.toString
                , fromString = Example.fromString
                , arrangement = Example.asList
                , toMsg =
                    \result ->
                        case result of
                            Ok fun ->
                                UpdateScrollingNav fun

                            Err _ ->
                                Idle
                }

        ( stateless, statelessCmd ) =
            Stateless.init
    in
    ( { stateless = stateless
      , scrollingNav = scrollingNav
      , snackbar = Snackbar.init
            , active = Nothing
      , displayDialog = False
      , window =
            { width = viewport.width |> round
            , height = viewport.height |> round
            }
      , search =
            { raw = ""
            , current = ""
            , remaining = 0
            }
      , theme = Material
      , expanded = AnySet.empty Example.toString
      }
    , [ cmd
      , statelessCmd |> Cmd.map StatelessSpecific
      ]
        |> Cmd.batch
    )


init : () -> ( Model, Cmd Msg )
init () =
    ( Loading
    , Task.perform GotViewport Dom.getViewport
    )


updateLoaded : LoadedMsg -> LoadedModel -> ( LoadedModel, Cmd LoadedMsg )
updateLoaded msg model =
    case msg of
        StatelessSpecific m ->
            model.stateless
                |> Stateless.update m
                |> Tuple.mapBoth
                    (\stateless ->
                        { model
                            | stateless = stateless
                        }
                    )
                    (Cmd.map StatelessSpecific)

        UpdateScrollingNav fun ->
            let
                _ =
                    model.scrollingNav |> fun
                        |> ScrollingNav.current Example.fromString
                        |> Maybe.map Example.toString
                        |> Debug.log "section"
            in
            ( { model | scrollingNav = model.scrollingNav |> fun }
            , Cmd.none
            )

        TimePassed int ->
            let
                search =
                    model.search
            in
            ( { model
                | snackbar = 
                    case model.active of
                        Just LeftSheet ->
                            model.snackbar

                        Just RightSheet ->
                            model.snackbar

                        _ ->
                            model.snackbar |> Snackbar.timePassed int
                            
                            
                , search =
                    if search.remaining > 0 then
                        if search.remaining <= int then
                            { search
                                | current = search.raw
                                , remaining = 0
                            }

                        else
                            { search
                                | remaining = search.remaining - int
                            }

                    else
                        model.search
              }
            , ScrollingNav.getPos
                |> Task.perform UpdateScrollingNav
            )

        AddSnackbar ( string, bool ) ->
            ( { model
                | snackbar = 
                    model.snackbar 
                        |> Snackbar.insert 
                                        { text = string
                                            , button =
                                                if bool then
                                                    Just
                                                        { text = "Add"
                                                        , onPress =
                                                            Just <|
                                                                AddSnackbar ( "This is another message", False )
                                                        }

                                                else
                                                    Nothing
                                                        
                                                        
                                        }
            }
            , Cmd.none
            )

        ToggleDialog bool ->
            ( { model | displayDialog = bool }
            , Cmd.none
            )

        Resized window ->
            ( { model | window = window }
            , Cmd.none
            )

        ChangedSidebar sidebar ->
            ( { model | active = sidebar }
            , Cmd.none
            )

        Load string ->
            ( model, Navigation.load string )

        JumpTo section ->
            let
                _ =
                    section
                        |> Example.toString
                        |> Debug.log "section"
            in
            ( model
            , model.scrollingNav
                |> ScrollingNav.jumpTo
                    { section = section
                    , onChange = always Idle
                    }
                
            )

        ChangedSearch string ->
            let
                search =
                    model.search
            in
            ( { model
                | search =
                    { search
                        | raw = string
                        , remaining = 300
                    }
              }
            , Cmd.none
            )

        SetTheme theme ->
            ( { model | theme = theme }
            , Cmd.none
            )

        ToggledExample example ->
            ( { model
                | expanded = model.expanded |> AnySet.toggle example
              }
            , Cmd.none
            )

        Idle ->
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( model, msg ) of
        ( Loading, GotViewport viewport ) ->
            initialModel viewport
                |> Tuple.mapBoth Loaded (Cmd.map LoadedSpecific)

        ( Loaded state, LoadedSpecific m ) ->
            updateLoaded m state
                |> Tuple.mapBoth Loaded (Cmd.map LoadedSpecific)

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    (
        [ Time.every 50 (always (TimePassed 50))
        , Events.onResize (\h w -> Resized { height = h, width = w })
        ] ++
        ( case model of
            Loading ->
                []
            Loaded {stateless} ->
                Stateless.subscriptions stateless 
                |> Sub.map StatelessSpecific
                |> List.singleton
        ))
        |> Sub.batch
        |> Sub.map LoadedSpecific


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            Element.none |> Framework.responsiveLayout []

        Loaded m ->
            let
                style : Style msg
                style =
                    Theme.toStyle m.theme
            in
            Html.map LoadedSpecific <|
                Element.layout
                    (viewLayout identity style m)
                <|
                    viewLoaded m

viewLayout : (LoadedMsg -> LoadedMsg) -> Style LoadedMsg -> LoadedModel -> List (Attribute LoadedMsg)
viewLayout msgMapper style model =
    let
        deviceClass : DeviceClass
        deviceClass =
            Layout.getDeviceClass model.window
        
        dialog : Maybe (Modal LoadedMsg)
        dialog =
            Nothing

        onChangedSidebar =
          ChangedSidebar
        
        menu = 
            model.scrollingNav
                |> ScrollingNav.toSelect
                    (\int ->
                        model.scrollingNav.arrangement
                            |> Array.fromList
                            |> Array.get int
                            |> Maybe.map JumpTo
                    )

        actions =
            [ { onPress = Just <| Load "https://package.elm-lang.org/packages/Orasund/elm-ui-widgets/latest/"
            , text = "Docs"
            , icon = FeatherIcons.book |> Icon.elmFeather FeatherIcons.toHtml
            }
            , { onPress = Just <| Load "https://github.com/Orasund/elm-ui-widgets"
            , text = "Github"
            , icon = FeatherIcons.github |> Icon.elmFeather FeatherIcons.toHtml
            }
            , { onPress =
                    if model.theme /= Material then
                        Just <| SetTheme <| Material

                    else
                        Nothing
            , text = "Material Theme"
            , icon = FeatherIcons.penTool |> Icon.elmFeather FeatherIcons.toHtml
            }
            , { onPress =
                    if model.theme /= DarkMaterial then
                        Just <| SetTheme <| DarkMaterial

                    else
                        Nothing
            , text = "Dark Material Theme"
            , icon = FeatherIcons.penTool |> Icon.elmFeather FeatherIcons.toHtml
            }
            ]

        { primaryActions, moreActions } =
            Layout.partitionActions actions
        
        title =
          "Elm-Ui-Widgets"
          |> Element.text
          |> Element.el (Typography.h6 ++ [ Element.paddingXY 8 0 ])
        
        search : TextInput LoadedMsg
        search =
            { chips = []
            , text = model.search.raw
            , placeholder = Just <|
                                        Input.placeholder [] <|
                                            Element.text "Search Widgets..."
            , label = "Search"
            , onChange = ChangedSearch >> msgMapper
            }

        nav : Element LoadedMsg
        nav =
            if
                (deviceClass == Phone)
                    || (deviceClass == Tablet)
                    || (menu.options |> List.length) > 5
            then
                Widget.menuBar style.menuBar
                    { title = title
                    , deviceClass = deviceClass
                    , openLeftSheet = Just <| msgMapper <| ChangedSidebar <| Just LeftSheet
                    , openRightSheet = Just <| msgMapper <| ChangedSidebar <| Just RightSheet
                    , openTopSheet = Just <| msgMapper <| ChangedSidebar <| Just Search
                    , primaryActions = primaryActions
                    , search = Just search
                    }

            else
                Widget.tabBar style.tabBar
                    { title = title
                    , menu = menu
                    , deviceClass = deviceClass
                    , openRightSheet = Just <|msgMapper <| ChangedSidebar <| Just RightSheet
                    , openTopSheet = Nothing
                    , primaryActions = primaryActions
                    , search =  Just search
                    }

        snackbarElem : Element LoadedMsg
        snackbarElem =
            model.snackbar
                |> Snackbar.view style.snackbar identity
                |> Maybe.map
                    (Element.el
                        [ Element.padding 8
                        , Element.alignBottom
                        , Element.alignRight
                        ]
                    )
                |> Maybe.withDefault Element.none

        onDismiss =
            Nothing
                |> ChangedSidebar
                |> msgMapper

        modals =
            Layout.orderModals
                { dialog = dialog
                , leftSheet =
                    if model.active == Just LeftSheet then
                        Layout.leftSheet
                            { button = style.sheetButton
                            , sheet = style.sideSheet
                            }
                            { title = title
                            , menu = menu
                            , onDismiss = onDismiss
                            }
                            |> Just

                    else
                        Nothing
                , rightSheet =
                    if model.active == Just RightSheet then
                        Layout.rightSheet
                            { sheet = style.sideSheet
                            , insetItem = style.insetItem
                            }
                            { onDismiss = onDismiss
                            , moreActions =moreActions
                            }
                            |> Just

                    else
                        Nothing
                , topSheet =
                    if model.active == Just Search then
                        Layout.searchSheet style.searchFill
                            { search = search
                            , onDismiss = onDismiss
                            }
                        |> Just

                    else
                        Nothing
                , bottomSheet = Nothing
                }
    in
    List.concat
        [ style.container
        , [ Element.inFront snackbarElem
            , Element.inFront nav
            ]
        , modals
            |> Widget.singleModal
        ]

viewLoaded : LoadedModel -> Element LoadedMsg
viewLoaded m =
    let
        style : Style msg
        style =
            Theme.toStyle m.theme
    in
    [ Element.el [ Element.height <| Element.px <| 42 ] <| Element.none
    , [ StatelessViews, ReusableViews ]
        |> List.map
            (\section ->
                (case section of
                    ReusableViews ->
                        Reusable.view
                            { theme = m.theme
                            , addSnackbar = AddSnackbar
                            }

                    StatelessViews ->
                        Stateless.view
                            { theme = m.theme
                            , msgMapper = StatelessSpecific
                            , model = m.stateless
                            }
                )
                    |> (\{ title, description, items } ->
                            [ title
                                |> Element.text
                                |> Element.el Heading.h2
                            , if m.search.current == "" then
                                description
                                    |> Element.text
                                    |> List.singleton
                                    |> Element.paragraph []

                              else
                                Element.none
                            , items
                                |> (if m.search.current /= "" then
                                        List.filter
                                            (\( a, _, _ ) ->
                                                a
                                                    |> String.toLower
                                                    |> String.contains (m.search.current |> String.toLower)
                                            )

                                    else
                                        identity
                                   )
                                |> List.map
                                    (\( name, elem, more ) ->
                                        (([ Element.text name
                                                |> Element.el
                                                    (Heading.h3
                                                        ++ [ Element.height <| Element.shrink
                                                           , name
                                                                |> Attributes.id
                                                                |> Element.htmlAttribute
                                                           ]
                                                    )
                                          , elem
                                          ]
                                            |> Element.column Grid.simple
                                            |> Widget.asItem
                                         )
                                            :: (if more |> List.isEmpty then
                                                    []

                                                else
                                                    [ Widget.divider style.fullBleedDivider
                                                    ]
                                                        ++ Widget.expansionItem style.expansionItem
                                                            { onToggle =
                                                                always
                                                                    (name
                                                                        |> Example.fromString
                                                                        |> Maybe.map ToggledExample
                                                                        |> Maybe.withDefault Idle
                                                                    )
                                                            , icon = always Element.none
                                                            , text =
                                                                "States"
                                                            , content =
                                                                Element.column
                                                                    (Grid.simple
                                                                        ++ [ Element.width <| Element.fill ]
                                                                    )
                                                                    more
                                                                    |> Widget.asItem
                                                                    |> List.singleton
                                                            , isExpanded =
                                                                name
                                                                    |> Example.fromString
                                                                    |> Maybe.map
                                                                        (\example ->
                                                                            m.expanded
                                                                                |> AnySet.member example
                                                                        )
                                                                    |> Maybe.withDefault False
                                                            }
                                               )
                                        )
                                            |> Widget.itemList style.cardColumn
                                    )
                                |> Element.wrappedRow
                                    (Grid.simple
                                        ++ [ Element.height <| Element.shrink
                                           ]
                                    )
                            ]
                                |> Element.column (Grid.section ++ [ Element.centerX ])
                       )
            )
        |> Element.column (Framework.container ++ style.container)
    ]
        |> Element.column Grid.compact


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
