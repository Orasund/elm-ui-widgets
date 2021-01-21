module Example.Button exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import FeatherIcons
import Widget
import Widget.Icon as Icon
import Widget.Style exposing (ButtonStyle, RowStyle)
import Widget.Style.Material as Material


type alias Style style msg =
    { style
        | primaryButton : ButtonStyle msg
        , button : ButtonStyle msg
        , row : RowStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { primaryButton = Material.containedButton Material.defaultPalette
    , button = Material.outlinedButton Material.defaultPalette
    , row = Material.row
    }


type Model
    = IsButtonEnabled Bool


type Msg
    = ChangedButtonStatus Bool


init : ( Model, Cmd Msg )
init =
    ( IsButtonEnabled True
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ChangedButtonStatus bool ->
            ( IsButtonEnabled bool
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (IsButtonEnabled isButtonEnabled) =
    [ Widget.button style.primaryButton
        { text = "disable me"
        , icon =
            FeatherIcons.slash
                |> Icon.elmFeather FeatherIcons.toHtml
        , onPress =
            if isButtonEnabled then
                ChangedButtonStatus False
                    |> msgMapper
                    |> Just

            else
                Nothing
        }
    , Widget.iconButton style.button
        { text = "reset"
        , icon =
            FeatherIcons.repeat
                |> Icon.elmFeather FeatherIcons.toHtml
        , onPress =
            ChangedButtonStatus True
                |> msgMapper
                |> Just
        }
    ]
        |> Widget.row style.row


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
