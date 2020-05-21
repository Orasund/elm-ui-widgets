module Example.Select exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element)
import Widget
import Widget.Style exposing (ButtonStyle, RowStyle)


type alias Style style msg =
    { style
        | buttonRow : RowStyle msg
        , selectButton : ButtonStyle msg
    }


type Model
    = Selected (Maybe Int)


type Msg
    = ChangedSelected Int


init : ( Model, Cmd Msg )
init =
    ( Selected Nothing
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ChangedSelected int ->
            ( Selected <| Just int
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (Selected selected) =
    { selected = selected
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
            { list = style.buttonRow
            , button = style.selectButton
            }
