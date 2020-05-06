module Stateless exposing (Model, Msg, init, update, view)

import Array exposing (Array)
import Data.Style exposing (Style)
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Framework.Group as Group
import Framework.Heading as Heading
import Framework.Input as Input
import Framework.Tag as Tag
import Heroicons.Solid as Heroicons
import Html exposing (Html)
import Html.Attributes as Attributes
import Icons
import Layout exposing (Part(..))
import Set exposing (Set)
import Widget
import Widget.Style exposing (ButtonStyle)
import Data.Theme as Theme exposing (Theme)

type alias Model =
    { selected : Maybe Int
    , multiSelected : Set Int
    , chipTextInput : Set String
    , isExpanded : Bool
    , carousel : Int
    , tab : Maybe Int
    , button : Bool
    , textInput : String
    }


type Msg
    = ChangedSelected Int
    | ChangedMultiSelected Int
    | ToggleCollapsable Bool
    | ToggleTextInputChip String
    | ChangedTab Int
    | SetCarousel Int
    | ToggleButton Bool
    | SetTextInput String
    | Idle


init : Model
init =
    { selected = Nothing
    , multiSelected = Set.empty
    , chipTextInput = Set.empty
    , isExpanded = False
    , carousel = 0
    , tab = Just 1
    , button = True
    , textInput = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedSelected int ->
            ( { model
                | selected = Just int
              }
            , Cmd.none
            )

        ChangedMultiSelected int ->
            ( { model
                | multiSelected =
                    model.multiSelected
                        |> (if model.multiSelected |> Set.member int then
                                Set.remove int

                            else
                                Set.insert int
                           )
              }
            , Cmd.none
            )

        ToggleCollapsable bool ->
            ( { model
                | isExpanded = bool
              }
            , Cmd.none
            )

        ToggleTextInputChip string ->
            ( { model
                | chipTextInput =
                    model.chipTextInput
                        |> (if model.chipTextInput |> Set.member string then
                                Set.remove string

                            else
                                Set.insert string
                           )
              }
            , Cmd.none
            )

        SetCarousel int ->
            ( if (int < 0) || (int > 3) then
                model

              else
                { model
                    | carousel = int
                }
            , Cmd.none
            )

        ChangedTab int ->
            ( { model | tab = Just int }, Cmd.none )

        ToggleButton bool ->
            ( { model | button = bool }, Cmd.none )

        SetTextInput string ->
            ( { model | textInput = string }, Cmd.none )

        Idle ->
            ( model, Cmd.none )


select : Style Msg -> Model -> ( String, Element Msg,Element Msg )
select style model =
    let
        buttonStyle =
            style.button
    in
    ( "Select"
    , { selected = model.selected
      , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = Element.none
                        }
                    )
      , onSelect = ChangedSelected >> Just
      }
        |> Widget.select
        |> Widget.buttonRow
            { list = style.row
            , button = style.button
            }
    , Element.none
    )


multiSelect : Style Msg -> Model -> ( String, Element Msg, Element Msg )
multiSelect style model =
    let
        buttonStyle =
            style.button
    in
    ( "Multi Select"
    , { selected = model.multiSelected
      , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = Element.none
                        }
                    )
      , onSelect = ChangedMultiSelected >> Just
      }
        |> Widget.multiSelect
        |> Widget.buttonRow
            { list = style.row
            , button = style.button
            }
    , Element.none
    )

expansionPanel : Style Msg -> Model -> (String,Element Msg,Element Msg)
expansionPanel style model =
    ( "Expansion Panel"
    ,   { onToggle = ToggleCollapsable
        , isExpanded = model.isExpanded
        , icon = Element.none
        , text = "Title"
        , content = Element.text <| "Hello World"
        }
        |>Widget.expansionPanel style.expansionPanel
    , Element.none
    )




tab : Style Msg -> Model -> ( String, Element Msg, Element Msg )
tab style model =
    ( "Tab"
    , Widget.tab style.tab
        { tabs =
            { selected = model.tab
            , options =
                [ 1, 2, 3 ]
                    |> List.map
                        (\int ->
                            { text = "Tab " ++ (int |> String.fromInt)
                            , icon = Element.none
                            }
                        )
            , onSelect = ChangedTab >> Just
            }
        , content =
            \selected ->
                (case selected of
                    Just 0 ->
                        "This is Tab 1"

                    Just 1 ->
                        "This is the second tab"

                    Just 2 ->
                        "The thrid and last tab"

                    _ ->
                        "Please select a tab"
                )
                    |> Element.text
        }
    , Element.none
    )


modal : Style msg -> (Maybe Part -> msg) -> Model -> ( String, Element msg,Element msg )
modal style changedSheet model =
    ( "Modal"
    , [ Widget.button style.button
            { onPress = Just <| changedSheet <| Just LeftSheet
            , text = "show left sheet"
            , icon = Element.none
            }
      , Widget.button style.button
            { onPress = Just <| changedSheet <| Just RightSheet
            , text = "show right sheet"
            , icon = Element.none
            }
      ]
        |> Element.column Grid.simple
    ,Element.none
    )


dialog : Style msg -> msg -> Model -> ( String, Element msg, Element msg )
dialog style showDialog model =
    ( "Dialog"
    , Widget.button style.button
        { onPress = Just showDialog
        , text = "Show dialog"
        , icon = Element.none
        }
    , Element.none
    )


carousel : Style Msg -> Model -> ( String, Element Msg, Element Msg )
carousel style model =
    ( "Carousel"
    , Widget.carousel
        { content = ( Color.cyan, [ Color.yellow, Color.green, Color.red ] |> Array.fromList )
        , current = model.carousel
        , label =
            \c ->
                [ Element.el [ Element.centerY ] <|
                    Widget.iconButton style.button
                        { onPress =
                            model.carousel
                                - 1
                                |> (\i ->
                                        if i < 0 then
                                            Nothing

                                        else
                                            SetCarousel i
                                                |> Just
                                   )
                        , icon =
                            Icons.chevronLeft
                                |> Element.html
                                |> Element.el []
                        , text = "Previous"
                        }
                , Element.el
                    (Card.simple
                        ++ [ Background.color <| c
                           , Element.height <| Element.px <| 100
                           , Element.width <| Element.px <| 100
                           ]
                    )
                  <|
                    Element.none
                , Element.el [ Element.centerY ] <|
                    Widget.iconButton style.button
                        { onPress =
                            model.carousel
                                + 1
                                |> (\i ->
                                        if i >= 4 then
                                            Nothing

                                        else
                                            SetCarousel i
                                                |> Just
                                   )
                        , icon =
                            Icons.chevronRight
                                |> Element.html
                                |> Element.el []
                        , text = "Next"
                        }
                ]
                    |> Element.row (Grid.simple ++ [ Element.centerX, Element.width <| Element.shrink ])
        }
    , Element.none
    )


iconButton : Style Msg -> Model -> ( String, Element Msg, Element Msg )
iconButton style model =
    ( "Icon Button"
    , [ Widget.button style.primaryButton
            { text = "disable me"
            , icon = Icons.slash |> Element.html |> Element.el []
            , onPress =
                if model.button then
                    Just <| ToggleButton False

                else
                    Nothing
            }
        , Widget.iconButton style.button
            { text = "reset"
            , icon = Icons.repeat |> Element.html |> Element.el []
            , onPress = Just <| ToggleButton True
            }
        ]
            |> Element.row Grid.simple
    , Element.column Grid.simple
            [ Element.row Grid.spacedEvenly
                [ "Button"
                    |> Element.text
                , Widget.button style.button
                    { text = "reset"
                    , icon = Icons.repeat |> Element.html |> Element.el []
                    , onPress = Just <| ToggleButton True
                    }
                ]
            , Element.row Grid.spacedEvenly
                [ "Text button"
                    |> Element.text
                , Widget.textButton style.button
                    { text = "reset"
                    , onPress = Just <| ToggleButton True
                    }
                ]
            , Element.row Grid.spacedEvenly
                [ "Button"
                    |> Element.text
                , Widget.iconButton style.button
                    { text = "reset"
                    , icon = Icons.repeat |> Element.html |> Element.el []
                    , onPress = Just <| ToggleButton True
                    }
                ]
            , Element.row Grid.spacedEvenly
                [ "Disabled button"
                    |> Element.text
                , Widget.button style.button
                    { text = "reset"
                    , icon = Icons.repeat |> Element.html |> Element.el []
                    , onPress = Nothing
                    }
                ] 
            ]
    )


textInput : Style Msg -> Model -> ( String, Element Msg, Element Msg )
textInput style model =
    ( "Chip Text Input"
    , [ { chips =
            model.chipTextInput
                |> Set.toList
                |> List.map
                    (\string ->
                        { icon = Element.none
                        , text = string
                        , onPress =
                            string
                                |> ToggleTextInputChip
                                |> Just
                        }
                    )
        , text = model.textInput
        , placeholder = Nothing
        , label = "Chips"
        , onChange = SetTextInput
        }
            |> Widget.textInput style.textInput
      , model.chipTextInput
            |> Set.diff
                ([ "A", "B", "C" ]
                    |> Set.fromList
                )
            |> Set.toList
            |> List.map
                (\string ->
                    Widget.button style.textInput.chipButton
                        { onPress =
                            string
                                |> ToggleTextInputChip
                                |> Just
                        , text = string
                        , icon = Element.none
                        }
                )
            |> Element.wrappedRow [ Element.spacing 10 ]
      ]
        |> Element.column Grid.simple
    , Element.none
    )


view :
    Theme ->
    { msgMapper : Msg -> msg
    , showDialog : msg
    , changedSheet : Maybe Part -> msg
    }
    -> Model
    ->
        { title : String
        , description : String
        , items : List ( String, Element msg, Element msg )
        }
view theme { msgMapper, showDialog, changedSheet } model =
    let
        style = Theme.toStyle theme

        map (a,b,c) =
            ( a
            , b |> Element.map msgMapper
            , c |> Element.map msgMapper
            )
    in
    { title = "Stateless Views"
    , description = "Stateless views are simple functions that view some content. No wiring required."
    , items =
        [ iconButton style model |> map
        , select style model |> map
        , multiSelect style model |> map
        , expansionPanel style model |> map
        , modal style changedSheet model
        , carousel style model |> map
        , tab style model |> map
        , dialog style showDialog model
        , textInput style model |> map
        ]
    }
