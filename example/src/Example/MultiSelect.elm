module Example.MultiSelect exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element)
import Set exposing (Set)
import Widget
import Widget.Style exposing (ButtonStyle, RowStyle)


type alias Style style msg =
    { style
        | row : RowStyle msg
        , button : ButtonStyle msg
    }


type alias Model =
    { selected : Set Int
    }


type Msg
    = ChangedSelected Int


init : ( Model, Cmd Msg )
init =
    ( { selected = Set.empty }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedSelected int ->
            ( { model
                | selected =
                    model.selected
                        |> (if model.selected |> Set.member int then
                                Set.remove int

                            else
                                Set.insert int
                           )
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
    { selected = model.selected
    , options =
        [ 1, 2, 42 ]
            |> List.map
                (\int ->
                    { text = String.fromInt int
                    , icon = Element.none
                    }
                )
    , onSelect = ChangedSelected >> msgMapper >> Just
    }
        |> Widget.multiSelect
        |> Widget.buttonRow
            { list = style.row
            , button = style.button
            }
