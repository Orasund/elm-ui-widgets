module Example exposing (main)

import Browser
import Browser.Dom as Dom exposing (Viewport)
import Browser.Events as Events
import Browser.Navigation as Navigation
import Component
import Element exposing (DeviceClass(..), Element,Attribute)
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
import Widget.Button exposing (ButtonStyle)
import Widget.FilterSelect as FilterSelect
import Widget.ScrollingNav as ScrollingNav
import Widget.Snackbar as Snackbar
import Widget.ValidatedInput as ValidatedInput
import Data.Section as Section exposing (Section(..))
import Array

type alias LoadedModel =
    { component : Component.Model
    , stateless : Stateless.Model
    , reusable : Reusable.Model
    , scrollingNav : ScrollingNav.Model Section
    , layout : Layout LoadedMsg
    , displayDialog : Bool
    , window : { height : Int, width : Int }
    , search : 
        { raw : String
        , current : String
        , remaining : Int
        }
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
    | AddSnackbar (String,Bool)
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

textButton : ButtonStyle msg
textButton =
    { container = Button.simple
    , label = Grid.simple
    , disabled = Color.disabled
    , active = Color.primary
    }

simpleButton : ButtonStyle msg
simpleButton =
    { container = Button.simple ++ Color.primary
    , label = Grid.simple
    , disabled = Color.disabled
    , active = Color.primary
    }

style : Style
    { dialog :
        { containerColumn : List (Attribute msg)
        , title : List (Attribute msg)
        , buttonRow : List (Attribute msg)
        , accept : ButtonStyle msg
        , dismiss : ButtonStyle msg
        }
    } msg
style =
    { dialog =
        { containerColumn = 
            Card.simple
            ++ Grid.simple
            ++ [ Element.width <| Element.minimum 280 <| Element.maximum  560 <| Element.fill ]
        , title = Heading.h3
        , buttonRow = 
            Grid.simple ++
            [ Element.paddingEach
                { top = 28
                , bottom = 0
                , left = 0
                , right = 0
                }
            ]
        , accept = simpleButton
        , dismiss = textButton
        }
    , snackbar = 
        { row = 
            Card.simple 
            ++ Color.dark
            ++ Grid.simple
            ++ [ Element.paddingXY 8 6]
        , button = 
            { label = Grid.simple
            , container = Button.simple ++ Color.dark
            , disabled = Color.disabled
            , active = Color.primary
            }
        , text = [Element.paddingXY 8 0]
        }
    , layout = Framework.responsiveLayout
    , header =
        Framework.container
            ++ Color.dark
            ++ [ Element.padding <| 0
                , Element.height <| Element.px <| 42
                ]
    , menuButton =
        { label = Grid.simple
        , container = Button.simple ++ Group.center ++ Color.dark
        , disabled = Color.disabled
        , active = Color.primary
        }
    , sheetButton =
        { container = 
            Button.fill
            ++ Group.center 
            ++ Color.light
            ++ [Font.alignLeft]
        , label = Grid.simple
        , disabled = Color.disabled
        , active = Color.primary
        }
    , menuTabButton = 
        { container =
            [ Element.height <| Element.px <| 42
            , Border.widthEach 
                { top = 0,
                left = 0,
                right = 0,
                bottom = 4
                }
            , Element.paddingEach
                { top = 12
                , left = 8
                , right = 8
                , bottom = 4
                }
            , Border.color Color.black
            ]
        , label = Grid.simple
        , disabled = Color.disabled
        , active = [ Border.color Color.turquoise ]
        }
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
        Color.simple ++ 
        Card.large ++
        [Font.color <| Element.rgb255 0 0 0
        , Element.padding 6
        , Element.centerY
        , Element.alignRight
        ]
    , searchFill =
        Color.light
        ++ Group.center
    }


initialModel : Viewport -> ( LoadedModel, Cmd LoadedMsg )
initialModel { viewport } =
    let
        ( scrollingNav, cmd ) =
            ScrollingNav.init
                { toString = Section.toString
                , fromString = Section.fromString
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
      , window =
            { width = viewport.width |> round
            , height = viewport.height |> round
            }
      , search = 
            { raw = ""
            , current = ""
            , remaining = 0
            }
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
                            { body =
                                "This is a dialog window"
                                        |> Element.text
                                        |> List.singleton
                                        |> Element.paragraph []
                            , title = Just "Dialog"
                            , accept = Just
                                { text = "Ok"
                                , onPress = Just <| ToggleDialog False
                                }
                            , dismiss = Just
                                { text = "Dismiss"
                                , onPress = Just <| ToggleDialog False
                                }
                            }
                            |> Widget.dialog style.dialog
                            |> Just

                        else
                            Nothing
                    , content =
                        [ Element.el [ Element.height <| Element.px <| 42 ] <| Element.none
                        , [ m.scrollingNav
                                |> ScrollingNav.view
                                    (\section ->
                                        ( case section of
                                            ComponentViews ->
                                                m.component
                                                    |> Component.view  ComponentSpecific
                                                 
        

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
                                        ) |> (\{title,description,items} ->
                                                        [ Element.el Heading.h2 <| Element.text <| title
                                                        , if m.search.current == "" then
                                                            description
                                                            |> Element.text
                                                            |> List.singleton
                                                            |> Element.paragraph []
                                                          else Element.none
                                                        , items
                                                            |> (if m.search.current /= "" then
                                                                    List.filter 
                                                                        ( Tuple.first 
                                                                        >> String.toLower
                                                                        >> String.contains (m.search.current |> String.toLower)
                                                                        )
                                                                else
                                                                    identity)
                                                            |> List.map
                                                                (\(name,elem) ->
                                                                    [ Element.text name
                                                                    |> Element.el Heading.h3
                                                                    , elem
                                                                    ]
                                                                    |> Element.column
                                                                        (Grid.simple 
                                                                        ++ Card.large 
                                                                        ++ [Element.height <| Element.fill])
                                                                )
                                                            |> Element.wrappedRow
                                                            (Grid.simple ++ [Element.height <| Element.shrink])
                                                        ]
                                                            |> Element.column (Grid.section ++ [ Element.centerX ])
                                                        )
                                    )
                          ]
                            |> Element.column Framework.container
                        ]
                            |> Element.column Grid.compact
                    , style = style
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
                          , icon = Icons.book|> Element.html |> Element.el []
                          }
                        , { onPress = Just <| Load "https://github.com/Orasund/elm-ui-widgets"
                          , text = "Github"
                          , icon = Icons.github|> Element.html |> Element.el []
                          }
                        , { onPress = Nothing
                          , text = "Placeholder"
                          , icon = Icons.circle|> Element.html |> Element.el []
                          }
                        , { onPress = Nothing
                          , text = "Placeholder"
                          , icon = Icons.triangle|> Element.html |> Element.el []
                          }
                        , { onPress = Nothing
                          , text = "Placeholder"
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
                            { text = m.search.raw
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
            let
                search = model.search
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

        AddSnackbar (string,bool) ->
            ( { model 
              | layout = model.layout 
                |> Layout.queueMessage 
                    { text = string
                    , button = if bool then
                            Just
                                { text = "Add"
                                , onPress = Just <|
                                    (AddSnackbar ("This is another message", False))
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
            let
                search = model.search
            in
            ( { model | search = 
                    { search
                    | raw = string
                    , remaining = 300
                    }
            }
            , Cmd.none
            )
        
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
