module Example.Switch exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import FeatherIcons
import Widget
import Widget exposing (RowStyle, SwitchStyle)
import Widget.Style.Material as Material


type alias Style style msg =
    { style
        | switch : SwitchStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { switch = Material.switch Material.defaultPalette
    }


type Model
    = IsButtonEnabled Bool


type Msg
    = ToggledButtonStatus


init : ( Model, Cmd Msg )
init =
    ( IsButtonEnabled False
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (IsButtonEnabled buttonEnabled) =
    case msg of
        ToggledButtonStatus ->
            ( IsButtonEnabled <| not buttonEnabled
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (IsButtonEnabled isButtonEnabled) =
    Widget.switch style.switch
        { description = "click me"
        , active = isButtonEnabled
        , onPress =
            ToggledButtonStatus
                |> msgMapper
                |> Just
        }


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
