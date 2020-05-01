module Stateless exposing (Model, Msg, init, update, view)

import Array exposing (Array)
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
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
import Set exposing (Set)
import Widget.Style exposing (ButtonStyle)
import Layout exposing (Part(..))
import Icons
import Widget
import Element.Font as Font
import Data.Style exposing (style)

type alias Model =
    { selected : Maybe Int
    , multiSelected : Set Int
    , chipTextInput : Set String
    , isCollapsed : Bool
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
    , isCollapsed = False
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
                | isCollapsed = bool
              }
            , Cmd.none
            )
        
        ToggleTextInputChip string ->
            ( { model
                | chipTextInput =
                    model.chipTextInput |>
                        if model.chipTextInput |> Set.member string then
                            Set.remove string
                        else
                            Set.insert string
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
            ( {model | textInput = string },Cmd.none)

        Idle ->
            ( model, Cmd.none)


select : Model -> (String,Element Msg)
select model =
    let
        buttonStyle = style.button
    in
    ( "Select"
    , { selected = model.selected
      , options = 
        [ 1, 2, 42 ]
        |> List.map (\int ->
            { text = String.fromInt int
            , icon = Element.none
            }
        )
      , onSelect = ChangedSelected >> Just
      }
        |> Widget.select
        |> List.indexedMap
            (\i ->
                Widget.selectButton
                    { buttonStyle
                    | container = buttonStyle.container
                        ++ (if i == 0 then
                                Group.left

                            else if i == 2 then
                                Group.right

                            else
                                Group.center
                           )
                    }
            )
        
        |> Element.row Grid.compact
    )


multiSelect : Model -> (String,Element Msg)
multiSelect model =
    let
        buttonStyle = style.button
    in
    ( "Multi Select"
    , { selected = model.multiSelected
      , options = 
        [ 1, 2, 42 ]
        |> List.map (\int -> 
            { text = String.fromInt int
            , icon = Element.none
            })
      , onSelect = ChangedMultiSelected >> Just
      }
        |> Widget.multiSelect
        |> List.indexedMap
            (\i ->
                Widget.selectButton
                    { buttonStyle
                    | container = buttonStyle.container
                        ++ (if i == 0 then
                                Group.left

                            else if i == 2 then
                                Group.right

                            else
                                Group.center
                           )
                    }
            )
        |> Element.row Grid.compact
    )

collapsable : Model -> (String,Element Msg)
collapsable model =
    ( "Collapsable"
    ,   { onToggle = ToggleCollapsable
        , isCollapsed = model.isCollapsed
        , label =
            Element.row (Grid.simple ++ [Element.width<| Element.fill])
                [  if model.isCollapsed then
                        Icons.chevronRight |> Element.html |> Element.el []

                    else
                        Icons.chevronDown  |> Element.html |> Element.el []
                , Element.text <| "Title"
                ]
        , content = Element.text <| "Hello World"
        }
        |>Widget.collapsable
        { containerColumn = Card.simple ++ Grid.simple
            ++ [ Element.padding 8 ]
        , button = []
        }
        
    )

tab : Model -> (String,Element Msg)
tab model =
    ( "Tab"
    , Widget.tab 
            { button = style.tabButton
            , optionRow = Grid.simple
            , containerColumn = Grid.compact
            } 
            { selected = model.tab
            , options = [ 1, 2, 3 ]
                |> List.map (\int ->
                    { text = "Tab " ++ (int |> String.fromInt)
                    , icon = Element.none
                    }
                )
            , onSelect = ChangedTab >> Just
            } <|
            (\selected ->
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
                    |> Element.el (Card.small ++ Group.bottom)
            )
    )

modal : (Maybe Part -> msg) -> Model -> (String,Element msg)
modal changedSheet model =
    ( "Modal"
    ,   [ Input.button Button.simple
            { onPress = Just <| changedSheet <| Just LeftSheet
            , label = Element.text <| "show left sheet"
            }
        ,  Input.button Button.simple
            { onPress = Just <| changedSheet <| Just RightSheet
            , label = Element.text <| "show right sheet"
            }
        ] |> Element.column Grid.simple
    )
    
dialog : msg -> Model -> (String,Element msg)
dialog showDialog model =
    ( "Dialog"
    , Input.button Button.simple
        { onPress = Just showDialog
        , label = Element.text <| "Show dialog"
        }
    )

carousel : Model -> (String,Element Msg)
carousel model =
    ( "Carousel"
    , Widget.carousel
        { content = ( Color.cyan, [ Color.yellow, Color.green, Color.red ] |> Array.fromList )
        , current = model.carousel
        , label =
            \c ->
                [ Element.el [Element.centerY] <|
                Widget.iconButton style.button
                    { onPress = 
                        model.carousel - 1
                        |> \i ->
                            if i < 0 then
                                Nothing
                            else
                                SetCarousel i
                                |> Just
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
                    { onPress = model.carousel + 1
                        |> \i ->
                            if i >= 4 then
                                Nothing
                            else
                                SetCarousel i
                                |> Just
                    , icon =
                        Icons.chevronRight 
                            |> Element.html
                            |> Element.el []
                    , text = "Next"
                    }
                ]
                    |> Element.row (Grid.simple ++ [ Element.centerX, Element.width <| Element.shrink ])
        }
    )

iconButton : Model -> (String,Element Msg)
iconButton model =
    ( "Icon Button"
    ,   [   [ Widget.button style.primaryButton
                { text = "disable me"
                , icon = Icons.slash |> Element.html |> Element.el []        , onPress =
                    if model.button then
                        Just <| ToggleButton False
                    else
                        Nothing
                }
            , Widget.iconButton style.button
                { text = "reset"
                , icon = Icons.repeat |> Element.html |> Element.el []       
                , onPress =  Just <| ToggleButton True
                }
            ]
            |> Element.row Grid.simple
        , Widget.button style.button
            { text = "reset button"
            , icon = Element.none       
            , onPress =  Just <| ToggleButton True
            }
        ] |> Element.column Grid.simple
    )

textInput : Model -> (String,Element Msg)
textInput model =
    ( "Chip Text Input"
    ,   [ { chips =
            model.chipTextInput
            |> Set.toList
            |> List.map (\string ->
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
                (["A","B","C"]
                    |> Set.fromList
                )
            |> Set.toList
            |> List.map
                (\string ->
                    Input.button (Button.simple ++ Tag.simple)
                        { onPress =
                            string
                            |> ToggleTextInputChip
                            |> Just
                        , label = Element.text string
                        }
                )
            |> Element.wrappedRow [ Element.spacing 10 ]
        ] |> Element.column Grid.simple
    )

view : 
    { msgMapper : Msg -> msg
    , showDialog : msg
    , changedSheet : Maybe Part -> msg
    } -> Model 
     -> { title : String
        , description : String
        , items : List (String,Element msg)
        }
view { msgMapper, showDialog, changedSheet } model =
    { title = "Stateless Views"
    , description = "Stateless views are simple functions that view some content. No wiring required."
    , items =
        [ iconButton model  |> Tuple.mapSecond (Element.map msgMapper)
        , select model |> Tuple.mapSecond (Element.map msgMapper)
        , multiSelect model |> Tuple.mapSecond (Element.map msgMapper)
        , collapsable model |> Tuple.mapSecond (Element.map msgMapper)
        , modal changedSheet model
        , carousel model |> Tuple.mapSecond (Element.map msgMapper)
        , tab model |> Tuple.mapSecond (Element.map msgMapper)
        , dialog showDialog model
        , textInput model |> Tuple.mapSecond (Element.map msgMapper)
        ]
    }
