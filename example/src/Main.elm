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
import Element exposing (Element,DeviceClass(..))
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
import Widget
import Widget.Layout as Layout exposing (Layout, Part)
import Widget.ScrollingNav as ScrollingNav
import FeatherIcons

type alias LoadedModel =
    { stateless : Stateless.Model
    , scrollingNav : ScrollingNav.ScrollingNav Example
    , layout : Layout LoadedMsg
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
      , layout = Layout.init
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
            ( { model | scrollingNav = model.scrollingNav |> fun }
            , Cmd.none
            )

        TimePassed int ->
            let
                search =
                    model.search
            in
            ( { model
                | layout = model.layout |> Layout.timePassed int
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
                | layout =
                    model.layout
                        |> Layout.queueMessage
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
            ( { model | layout = model.layout |> Layout.activate sidebar }
            , Cmd.none
            )

        Load string ->
            ( model, Navigation.load string )

        JumpTo section ->
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
subscriptions _ =
    Sub.batch
        [ Time.every 50 (always (TimePassed 50))
        , Events.onResize (\h w -> Resized { height = h, width = w })
        ]
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
                Layout.view style.layout
                    { dialog =
                        if m.displayDialog then
                            { text = "This is a dialog window"
                            , title = Just "Dialog"
                            , accept =
                                Just
                                    { text = "Ok"
                                    , onPress = Just <| ToggleDialog False
                                    }
                            , dismiss =
                                Just
                                    { text = "Dismiss"
                                    , onPress = Just <| ToggleDialog False
                                    }
                            }
                                |> Widget.dialog style.dialog
                                |> Just

                        else
                            Nothing
                    , layout = m.layout
                    , window = m.window
                    , menu =
                        m.scrollingNav
                            |> ScrollingNav.toSelect
                                (\int ->
                                    m.scrollingNav.arrangement
                                        |> Array.fromList
                                        |> Array.get int
                                        |> Maybe.map JumpTo
                                )
                    , actions =
                        [ { onPress = Just <| Load "https://package.elm-lang.org/packages/Orasund/elm-ui-widgets/latest/"
                          , text = "Docs"
                          , icon = Icons.book |> Element.html |> Element.el []
                          }
                        , { onPress = Just <| Load "https://github.com/Orasund/elm-ui-widgets"
                          , text = "Github"
                          , icon = Icons.github |> Element.html |> Element.el []
                          }
                        , { onPress =
                                if m.theme /= Material then
                                    Just <| SetTheme <| Material

                                else
                                    Nothing
                          , text = "Material Theme"
                          , icon = Icons.penTool |> Element.html |> Element.el []
                          }
                        , { onPress =
                                if m.theme /= DarkMaterial then
                                    Just <| SetTheme <| DarkMaterial

                                else
                                    Nothing
                          , text = "Dark Material Theme"
                          , icon = Icons.penTool |> Element.html |> Element.el []
                          }
                        , { onPress =
                                if m.theme /= ElmUiFramework then
                                    Just <| SetTheme <| ElmUiFramework

                                else
                                    Nothing
                          , text = "Elm-Ui-Framework Theme"
                          , icon = Icons.penTool |> Element.html |> Element.el []
                          }
                        , { onPress =
                                if m.theme /= Template then
                                    Just <| SetTheme <| Template

                                else
                                    Nothing
                          , text = "Template Theme"
                          , icon = Icons.penTool |> Element.html |> Element.el []
                          }
                        ]
                    , onChangedSidebar = ChangedSidebar
                    , title =
                        "Elm-Ui-Widgets"
                            |> Element.text
                            |> Element.el Heading.h1
                    , search =
                        Just
                            { text = m.search.raw
                            , onChange = ChangedSearch
                            , label = "Search"
                            }
                    }
                <|
                    viewLoaded m


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
                                        )
                                        :: ( if more |> List.isEmpty then
                                            []
                                            else
                                            [Widget.expansionPanel style.expansionPanel
    
                                                { onToggle = 
                                                    always
                                                    (name
                                                    |> Example.fromString
                                                    |> Maybe.map ToggledExample
                                                    |> Maybe.withDefault Idle
                                                    )
                                                , icon = Element.none
                                                , text =
                                                    "States"
                                                , content = Element.column
                                                        (Grid.simple
                                                            ++ [ Element.width <| Element.fill ]
                                                        )
                                                        more
                                                , isExpanded =
                                                    name
                                                    |> Example.fromString
                                                    |> Maybe.map
                                                    (\example ->
                                                    m.expanded 
                                                    |> AnySet.member example 
                                                    )|> Maybe.withDefault False
                                                    

                                                }]
                                        ))
                                            |> Widget.column style.cardColumn
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
        |> Element.column (Framework.container ++ style.layout.container)
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
