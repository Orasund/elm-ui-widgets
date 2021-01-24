module Example.MultiSelect exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Set exposing (Set)
import Widget
import Widget exposing (ButtonStyle, RowStyle)
import Widget.Style.Material as Material


type alias Style style msg =
    { style
        | buttonRow : RowStyle msg
        , selectButton : ButtonStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { buttonRow = Material.buttonRow
    , selectButton = Material.toggleButton Material.defaultPalette
    }


type Model
    = Selected (Set Int)


type Msg
    = ChangedSelected Int


init : ( Model, Cmd Msg )
init =
    ( Selected <| Set.empty
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Selected selected) =
    case msg of
        ChangedSelected int ->
            ( selected
                |> (if selected |> Set.member int then
                        Set.remove int

                    else
                        Set.insert int
                   )
                |> Selected
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (Selected selected) =
    { selected = selected
    , options =
        [ 1, 2, 42 ]
            |> List.map
                (\int ->
                    { text = String.fromInt int
                    , icon = always Element.none
                    }
                )
    , onSelect = ChangedSelected >> msgMapper >> Just
    }
        |> Widget.multiSelect
        |> Widget.buttonRow
            { elementRow = style.buttonRow
            , content = style.selectButton
            }


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
