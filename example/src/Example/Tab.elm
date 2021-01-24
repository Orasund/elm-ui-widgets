module Example.Tab exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Widget
import Widget exposing (TabStyle)
import Widget.Style.Material as Material


type alias Style style msg =
    { style
        | tab : TabStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { tab = Material.tab Material.defaultPalette
    }


type Model
    = Selected (Maybe Int)


type Msg
    = ChangedTab Int


init : ( Model, Cmd Msg )
init =
    ( Selected Nothing
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ChangedTab int ->
            ( Selected <| Just int
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (Selected selected) =
    Widget.tab style.tab
        { tabs =
            { selected = selected
            , options =
                [ 1, 2, 3 ]
                    |> List.map
                        (\int ->
                            { text = "Tab " ++ (int |> String.fromInt)
                            , icon = always Element.none
                            }
                        )
            , onSelect = ChangedTab >> msgMapper >> Just
            }
        , content =
            \s ->
                (case s of
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


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
