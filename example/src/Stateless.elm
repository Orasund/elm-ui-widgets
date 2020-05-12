module Stateless exposing (Model, Msg, init, update, view)

import Array
import Data.Example as Example
import Data.Style exposing (Style)
import Data.Theme as Theme exposing (Theme)
import Element exposing (Element)
import Element.Background as Background
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Heroicons.Solid as Heroicons
import Html.Attributes as Attributes
import Icons
import Layout exposing (Part(..))
import Set exposing (Set)
import Widget


type alias Model =
    { chipTextInput : Set String
    , carousel : Int
    , textInput : String
    , table : { title : String, asc : Bool }
    , example : Example.Model
    }


type Msg
    = ToggleTextInputChip String
    | SetCarousel Int
    | SetTextInput String
    | ChangedSorting String
    | ExampleSpecific Example.Msg
    | Idle


init : ( Model, Cmd Msg )
init =
    let
        ( example, cmd ) =
            Example.init
    in
    ( { chipTextInput = Set.empty
      , carousel = 0
      , textInput = ""
      , table = { title = "Name", asc = True }
      , example = example
      }
    , cmd |> Cmd.map ExampleSpecific
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ExampleSpecific exampleMsg ->
            let
                ( exampleModel, exampleCmd ) =
                    Example.update exampleMsg model.example
            in
            ( { model | example = exampleModel }
            , exampleCmd |> Cmd.map ExampleSpecific
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

        SetTextInput string ->
            ( { model | textInput = string }, Cmd.none )

        ChangedSorting string ->
            ( { model
                | table =
                    { title = string
                    , asc =
                        if model.table.title == string then
                            not model.table.asc

                        else
                            True
                    }
              }
            , Cmd.none
            )

        Idle ->
            ( model, Cmd.none )


modal : Style msg -> (Maybe Part -> msg) -> Model -> ( String, Element msg, Element msg )
modal style changedSheet _ =
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
    , Element.none
    )


dialog : Style msg -> msg -> Model -> ( String, Element msg, Element msg )
dialog style showDialog _ =
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
    , [ Element.row Grid.spacedEvenly
            [ "Nothing Selected"
                |> Element.text
                |> Element.el [ Element.width <| Element.fill ]
            , { chips = []
              , text = ""
              , placeholder = Nothing
              , label = "Label"
              , onChange = always Idle
              }
                |> Widget.textInput style.textInput
            ]
      , Element.row Grid.spacedEvenly
            [ "Some chips"
                |> Element.text
                |> Element.el [ Element.width <| Element.fill ]
            , { chips =
                    [ { icon = Icons.triangle |> Element.html |> Element.el []
                      , text = "A"
                      , onPress = Just Idle
                      }
                    , { icon = Icons.circle |> Element.html |> Element.el []
                      , text = "B"
                      , onPress = Just Idle
                      }
                    ]
              , text = ""
              , placeholder = Nothing
              , label = "Label"
              , onChange = always Idle
              }
                |> Widget.textInput style.textInput
            ]
      ]
        |> Element.column Grid.simple
    )


list : Style Msg -> Model -> ( String, Element Msg, Element Msg )
list style _ =
    ( "List"
    , [ Element.text <| "A"
      , Element.text <| "B"
      , Element.text <| "C"
      ]
        |> Widget.column style.cardColumn
    , Element.none
    )


sortTable : Style Msg -> Model -> ( String, Element Msg, Element Msg )
sortTable _ model =
    ( "Sort Table"
    , Widget.sortTable
        { containerTable = Grid.simple
        , headerButton =
            { container = []
            , labelRow = []
            , ifDisabled = []
            , ifActive = []
            }
        , ascIcon = Heroicons.cheveronUp [ Attributes.width 16 ] |> Element.html
        , descIcon = Heroicons.cheveronDown [ Attributes.width 16 ] |> Element.html
        , defaultIcon = Element.none
        }
        { content =
            [ { id = 1, name = "Antonio", rating = 2.456 }
            , { id = 2, name = "Ana", rating = 1.34 }
            , { id = 3, name = "Alfred", rating = 4.22 }
            , { id = 4, name = "Thomas", rating = 3 }
            ]
        , columns =
            [ Widget.intColumn
                { title = "Id"
                , value = .id
                , toString = \int -> "#" ++ String.fromInt int
                , width = Element.fill
                }
            , Widget.stringColumn
                { title = "Name"
                , value = .name
                , toString = identity
                , width = Element.fill
                }
            , Widget.floatColumn
                { title = "rating"
                , value = .rating
                , toString = String.fromFloat
                , width = Element.fill
                }
            ]
        , asc = model.table.asc
        , sortBy = model.table.title
        , onChange = ChangedSorting
        }
    , Element.none
    )


view :
    Theme
    ->
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
        style =
            Theme.toStyle theme

        map ( a, b, c ) =
            ( a
            , b |> Element.map msgMapper
            , c |> Element.map msgMapper
            )
    in
    { title = "Stateless Views"
    , description = "Stateless views are simple functions that view some content. No wiring required."
    , items =
        Example.toCardList
            { idle = Idle |> msgMapper
            , msgMapper = ExampleSpecific >> msgMapper
            , style = style
            , model = model.example
            }
            ++ [ modal style changedSheet model
               , carousel style model |> map
               , dialog style showDialog model
               , textInput style model |> map
               , list style model |> map
               , sortTable style model |> map
               ]
    }
