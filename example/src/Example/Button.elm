module Example.Button exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element)
import FeatherIcons
import Widget
import Widget.Style exposing (ButtonStyle, RowStyle)


type alias Style style msg =
    { style
        | primaryButton : ButtonStyle msg
        , button : ButtonStyle msg
        , row : RowStyle msg
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


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (IsButtonEnabled isButtonEnabled) =
    [ Widget.button style.primaryButton
        { text = "disable me"
        , icon =
            FeatherIcons.slash
                |> FeatherIcons.withSize 16
                |> FeatherIcons.toHtml []
                |> Element.html
                |> Element.el []
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
        |> Widget.row style.row
