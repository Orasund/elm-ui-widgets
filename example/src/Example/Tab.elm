module Example.Tab exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element)
import Widget
import Widget.Style exposing (TabStyle)


type alias Style style msg =
    { style
        | tab : TabStyle msg
    }


type alias Model =
    { selected : Maybe Int
    }


type Msg
    = ChangedTab Int


init : ( Model, Cmd Msg )
init =
    ( { selected = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedTab int ->
            ( { model | selected = Just int }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
    Widget.tab style.tab
        { tabs =
            { selected = model.selected
            , options =
                [ 1, 2, 3 ]
                    |> List.map
                        (\int ->
                            { text = "Tab " ++ (int |> String.fromInt)
                            , icon = Element.none
                            }
                        )
            , onSelect = ChangedTab >> msgMapper >> Just
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
