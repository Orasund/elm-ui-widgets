module Example.TextInput exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Set exposing (Set)
import Widget exposing (ColumnStyle, TextInputStyle)
import Widget.Style.Material as Material


type alias Style style msg =
    { style
        | textInput : TextInputStyle msg
        , column : ColumnStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { textInput = Material.textInput Material.defaultPalette
    , column = Material.column
    }


type alias Model =
    { chipTextInput : Set String
    , textInput : String
    }


type Msg
    = ToggleTextInputChip String
    | SetTextInput String


init : ( Model, Cmd Msg )
init =
    ( { chipTextInput = Set.empty
      , textInput = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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

        SetTextInput string ->
            ( { model | textInput = string }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
    [ { chips =
            model.chipTextInput
                |> Set.toList
                |> List.map
                    (\string ->
                        { icon = always Element.none
                        , text = string
                        , onPress =
                            string
                                |> ToggleTextInputChip
                                |> msgMapper
                                |> Just
                        }
                    )
      , text = model.textInput
      , placeholder = Nothing
      , label = "Chips"
      , onChange = SetTextInput >> msgMapper
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
                Widget.button style.textInput.content.chips.content
                    { onPress =
                        string
                            |> ToggleTextInputChip
                            |> msgMapper
                            |> Just
                    , text = string
                    , icon = always Element.none
                    }
            )
        |> Element.wrappedRow [ Element.spacing 10 ]
    ]
        |> Widget.column style.column


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
