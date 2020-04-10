module Example exposing (main)

import Browser
import Browser.Dom as Dom exposing (Viewport)
import Browser.Events as Events
import Browser.Navigation as Navigation
import Component
import Element exposing (DeviceClass(..), Element)
import Element.Input as Input
import Element.Font as Font
import Element.Border as Border
import Framework
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Framework.Group as Group
import Framework.Heading as Heading
import Framework.Input as Input
import Framework.Tag as Tag
import Html exposing (Html)
import Html.Attributes as Attributes
import Icons
import Layout exposing (Part, Layout)
import Core.Style exposing (Style)
import Reusable
import Set exposing (Set)
import Stateless
import Task
import Time
import Widget
import Widget.FilterSelect as FilterSelect
import Widget.ScrollingNav as ScrollingNav
import Widget.Snackbar as Snackbar
import Widget.ValidatedInput as ValidatedInput
import Data.Section as Section exposing (Section(..))

type alias LoadedModel =
    { component : Component.Model
    , stateless : Stateless.Model
    , reusable : Reusable.Model
    , scrollingNav : ScrollingNav.Model Section
    , layout : Layout
    , displayDialog : Bool
    , deviceClass : DeviceClass
    , search : String
    }


type Model
    = Loading
    | Loaded LoadedModel


type LoadedMsg
    = StatelessSpecific Stateless.Msg
    | ReusableSpecific Reusable.Msg
    | ComponentSpecific Component.Msg
    | UpdateScrollingNav (ScrollingNav.Model Section -> ScrollingNav.Model Section)
    | TimePassed Int
    | AddSnackbar String
    | ToggleDialog Bool
    | ChangedSidebar (Maybe Part)
    | Resized { width : Int, height : Int }
    | Load String
    | JumpTo Section
    | ChangedSearch String
    | Idle


type Msg
    = LoadedSpecific LoadedMsg
    | GotViewport Viewport

style : Style msg
style =
    { snackbar = Card.simple ++ Color.dark
    , layout = Framework.responsiveLayout
    , header =
        Framework.container
            ++ Color.dark
            ++ [ Element.padding <| 0
                , Element.height <| Element.px <| 42
                ]
    , menuButton =
        Button.simple ++ Group.center ++ Color.dark
    , menuButtonSelected =
        Color.primary
    , sheetButton =
        Button.fill
        ++ Group.center 
        ++ Color.light
        ++ [Font.alignLeft]
    , sheetButtonSelected =
        Color.primary
    , tabButton = 
        [ Element.height <| Element.px <| 42
        , Border.widthEach 
            { top = 0,
            left = 0,
            right = 0,
            bottom = 8
            }
        ]
    , tabButtonSelected =
        [ Border.color Color.turquoise
        ]
    , sheet =
        Color.light ++ [ Element.width <| Element.maximum 256 <| Element.fill]
    , menuIcon =
        Icons.menu |> Element.html |> Element.el []
    , moreVerticalIcon =
        Icons.moreVertical |> Element.html |> Element.el []
    , spacing = 8
    , title = Heading.h2
    , searchIcon =
        Icons.search |> Element.html |> Element.el []
    , search =
        Color.simple ++ [Font.color <| Element.rgb255 0 0 0 ]
    }


initialModel : Viewport -> ( LoadedModel, Cmd LoadedMsg )
initialModel { viewport } =
    let
        ( scrollingNav, cmd ) =
            ScrollingNav.init
                { labels = Section.toString
                , arrangement = Section.asList
                , toMsg = \result ->
                    case result of
                        Ok fun ->
                            UpdateScrollingNav fun
                        Err _ ->
                            Idle
                }
    in
    ( { component = Component.init
      , stateless = Stateless.init
      , reusable = Reusable.init
      , scrollingNav = scrollingNav
      , layout = Layout.init
      , displayDialog = False
      , deviceClass =
            { width = viewport.width |> round
            , height = viewport.height |> round
            }
                |> Element.classifyDevice
                |> .class
      , search = ""
      }
    , cmd
    )


init : () -> ( Model, Cmd Msg )
init () =
    ( Loading
    , Task.perform GotViewport Dom.getViewport
    )


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            Element.none |> Framework.responsiveLayout []

        Loaded m ->
            Html.map LoadedSpecific <|
                Layout.view []
                    { dialog =
                        if m.displayDialog then
                            Just
                                { onDismiss = Just <| ToggleDialog False
                                , content =
                                    [ Element.el Heading.h3 <| Element.text "Dialog"
                                    , "This is a dialog window"
                                        |> Element.text
                                        |> List.singleton
                                        |> Element.paragraph []
                                    , Input.button (Button.simple ++ [ Element.alignRight ])
                                        { onPress = Just <| ToggleDialog False
                                        , label = Element.text "Ok"
                                        }
                                    ]
                                        |> Element.column 
                                            ( Grid.simple
                                                ++ Card.large
                                                ++ [Element.centerX, Element.centerY]
                                            )
                                }

                        else
                            Nothing
                    , content =
                        [ Element.el [ Element.height <| Element.px <| 42 ] <| Element.none
                        , [ m.scrollingNav
                                |> ScrollingNav.view
                                    (\section ->
                                        case section of
                                            ComponentViews ->
                                                m.component
                                                    |> Component.view
                                                    |> Element.map ComponentSpecific

                                            ReusableViews ->
                                                Reusable.view
                                                    { addSnackbar = AddSnackbar
                                                    , model = m.reusable
                                                    , msgMapper = ReusableSpecific
                                                    }

                                            StatelessViews ->
                                                Stateless.view
                                                    { msgMapper = StatelessSpecific
                                                    , showDialog = ToggleDialog True
                                                    , changedSheet = ChangedSidebar
                                                    }
                                                    m.stateless
                                    )
                          ]
                            |> Element.column Framework.container
                        ]
                            |> Element.column Grid.compact
                    , style = style
                    , layout = m.layout
                    , deviceClass = m.deviceClass
                    , menu =
                        { selected = 
                            Section.asList
                            |> List.indexedMap (\i s -> (i,s))
                            |> List.filterMap
                                ( \(i,s) ->
                                    if  m.scrollingNav
                                        |> ScrollingNav.current Section.fromString
                                        |> (==) (Just s)
                                    then
                                        Just i
                                    else
                                        Nothing
                                )
                            |> List.head
                            |> Maybe.withDefault 0
                        , items =
                            Section.asList
                            |> List.map
                                (\label ->
                                    { icon = Element.none
                                    , label = label |> Section.toString
                                    , onPress = Just <| JumpTo <| label
                                    }
                                )
                        }
                    , actions =
                        [ { onPress = Just <| Load "https://package.elm-lang.org/packages/Orasund/elm-ui-widgets/latest/"
                          , label = "Docs"
                          , icon = Icons.book|> Element.html |> Element.el []
                          }
                        , { onPress = Just <| Load "https://github.com/Orasund/elm-ui-widgets"
                          , label = "Github"
                          , icon = Icons.github|> Element.html |> Element.el []
                          }
                        , { onPress = Nothing
                          , label = "Placeholder"
                          , icon = Icons.circle|> Element.html |> Element.el []
                          }
                        , { onPress = Nothing
                          , label = "Placeholder"
                          , icon = Icons.triangle|> Element.html |> Element.el []
                          }
                        , { onPress = Nothing
                          , label = "Placeholder"
                          , icon = Icons.square|> Element.html |> Element.el []
                          }
                        ]
                    , onChangedSidebar = ChangedSidebar
                    , title = 
                        "Elm-Ui-Widgets"
                        |> Element.text 
                        |> Element.el Heading.h1
                    , search =
                        Just
                            { text = m.search
                            , onChange = ChangedSearch
                            , label = "Search"
                            }
                    }


updateLoaded : LoadedMsg -> LoadedModel -> ( LoadedModel, Cmd LoadedMsg )
updateLoaded msg model =
    case msg of
        ComponentSpecific m ->
            model.component
                |> Component.update m
                |> Tuple.mapBoth
                    (\component ->
                        { model
                            | component = component
                        }
                    )
                    (Cmd.map ComponentSpecific)

        ReusableSpecific m ->
            ( model.reusable
                |> Reusable.update m
                |> (\reusable ->
                        { model
                            | reusable = reusable
                        }
                   )
            , Cmd.none
            )

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
            ( { model | scrollingNav = model.scrollingNav |> fun}
            , Cmd.none
            )

        TimePassed int ->
            ( { model
                | layout = model.layout |> Layout.timePassed int
              }
            , ScrollingNav.getPos
                |> Task.perform UpdateScrollingNav
            )

        AddSnackbar string ->
            ( { model | layout = model.layout |> Layout.queueMessage string }
            , Cmd.none
            )

        ToggleDialog bool ->
            ( { model | displayDialog = bool }
            , Cmd.none
            )

        Resized screen ->
            ( { model | deviceClass = screen |> Element.classifyDevice |> .class }
            , Cmd.none
            )

        ChangedSidebar sidebar ->
            ( { model | layout = model.layout |> Layout.activate sidebar }
            , Cmd.none
            )
        
        Load string ->
            ( model, Navigation.load string)
        
        JumpTo section ->
            ( model
            , model.scrollingNav
                |> ScrollingNav.jumpTo 
                    { section = section
                    , onChange = always Idle
                    }
            )
        
        ChangedSearch string ->
            ( { model | search = string},Cmd.none)
        
        Idle ->
            ( model , Cmd.none)


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
    Sub.batch
        [ Time.every 50 (always (TimePassed 50))
        , Events.onResize (\h w -> Resized { height = h, width = w })
        ]
        |> Sub.map LoadedSpecific


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
