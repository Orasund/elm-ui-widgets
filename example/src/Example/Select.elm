module Example.Select exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Attribute, Element)
import FeatherIcons
import Widget
import Widget.Style exposing (ButtonStyle, RowStyle)


type alias Style style msg =
    { style
        | row : RowStyle msg
        , button : ButtonStyle msg
    }


type alias Model =
    { selected : Maybe Int }


type Msg
    = ChangedSelected Int


init : ( Model, Cmd Msg )
init =
    ( { selected = Nothing }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedSelected int ->
            ( { model
                | selected = Just int
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
        |> Widget.select
        |> Widget.buttonRow
            { list = style.row
            , button = style.button
            }
