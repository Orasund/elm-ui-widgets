module Example.Button exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element)
import FeatherIcons
import Widget
import Widget.Style exposing (ButtonStyle)


type alias Style style msg =
    { style
        | primaryButton : ButtonStyle msg
        , button : ButtonStyle msg
    }


type alias Model =
    { isButtonEnabled : Bool
    }


type Msg
    = ChangedButtonStatus Bool


init : ( Model, Cmd Msg )
init =
    ( { isButtonEnabled = True
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedButtonStatus bool ->
            ( { model | isButtonEnabled = bool }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
    [ Widget.button style.primaryButton
        { text = "disable me"
        , icon =
            FeatherIcons.slash
                |> FeatherIcons.withSize 16
                |> FeatherIcons.toHtml []
                |> Element.html
                |> Element.el []
        , onPress =
            if model.isButtonEnabled then
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
                |> FeatherIcons.withSize 16
                |> FeatherIcons.toHtml []
                |> Element.html
                |> Element.el []
        , onPress =
            ChangedButtonStatus True
                |> msgMapper
                |> Just
        }
    ]
        |> Element.row
            [ Element.spaceEvenly
            , Element.width <| Element.fill
            ]
