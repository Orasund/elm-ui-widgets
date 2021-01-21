module Example.Dialog exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import FeatherIcons
import Widget
import Widget.Style exposing (ButtonStyle, DialogStyle)
import Widget.Style.Material as Material
import Widget.Icon as Icon

type alias Style style msg =
    { style
        | dialog : DialogStyle msg
        , primaryButton : ButtonStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { dialog = Material.alertDialog Material.defaultPalette
    , primaryButton = Material.containedButton Material.defaultPalette
    }


type Model
    = IsOpen Bool


type Msg
    = OpenDialog Bool


init : ( Model, Cmd Msg )
init =
    ( IsOpen True
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        OpenDialog bool ->
            ( IsOpen bool
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (IsOpen isOpen) =
    Widget.button style.primaryButton
        { text = "show Dialog"
        , icon =
            FeatherIcons.eye
                |> Icon.elmFeather FeatherIcons.toHtml
        , onPress =
            OpenDialog True
                |> msgMapper
                |> Just
        }
        |> Element.el
            ([ Element.height <| Element.minimum 200 <| Element.fill
             , Element.width <| Element.minimum 400 <| Element.fill
             ]
                ++ (if isOpen then
                        { text = "This is a dialog window"
                        , title = Just "Dialog"
                        , accept =
                            Just
                                { text = "Ok"
                                , onPress =
                                    Just <|
                                        msgMapper <|
                                            OpenDialog False
                                }
                        , dismiss =
                            Just
                                { text = "Dismiss"
                                , onPress =
                                    Just <|
                                        msgMapper <|
                                            OpenDialog False
                                }
                        }
                            |> Widget.dialog style.dialog

                    else
                        []
                   )
            )


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
