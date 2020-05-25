module Example.Dialog exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element)
import FeatherIcons
import Widget
import Widget.Style exposing (ButtonStyle, DialogStyle)


type alias Style style msg =
    { style
        | dialog : DialogStyle msg
        , primaryButton : ButtonStyle msg
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


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (IsOpen isOpen) =
    Widget.button style.primaryButton
        { text = "show Dialog"
        , icon =
            FeatherIcons.eye
                |> FeatherIcons.withSize 16
                |> FeatherIcons.toHtml []
                |> Element.html
                |> Element.el []
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
