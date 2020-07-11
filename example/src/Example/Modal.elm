module Example.Modal exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element)
import FeatherIcons
import Widget
import Widget.Style exposing (ButtonStyle, ColumnStyle)
import Widget.Style.Material as Material
import Browser

type alias Style style msg =
    { style
        | cardColumn : ColumnStyle msg
        , primaryButton : ButtonStyle msg
    }

materialStyle : Style {} msg
materialStyle =
    { cardColumn = Material.cardColumn Material.defaultPalette
    , primaryButton = Material.containedButton Material.defaultPalette
    }

type Model
    = IsEnabled Bool


type Msg
    = ToggleModal Bool


init : ( Model, Cmd Msg )
init =
    ( IsEnabled True
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ToggleModal bool ->
            ( IsEnabled bool
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
--}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (IsEnabled isEnabled) =
    Widget.button style.primaryButton
        { text = "show Modal"
        , icon =
            FeatherIcons.eye
                |> FeatherIcons.withSize 16
                |> FeatherIcons.toHtml []
                |> Element.html
                |> Element.el []
        , onPress =
            ToggleModal True
                |> msgMapper
                |> Just
        }
        |> Element.el
            ([ Element.height <| Element.minimum 200 <| Element.fill
             , Element.width <| Element.minimum 400 <| Element.fill
             ]
                ++ (if isEnabled then
                        Widget.modal
                            { onDismiss =
                                ToggleModal False
                                    |> msgMapper
                                    |> Just
                            , content =
                                "Click on the area around this box to close it."
                                    |> Element.text
                                    |> List.singleton
                                    |> Element.paragraph []
                                    |> List.singleton
                                    |> Widget.column style.cardColumn
                                    |> Element.el
                                        [ Element.height <| Element.px 100
                                        , Element.width <| Element.px 250
                                        , Element.centerX
                                        , Element.centerY
                                        ]
                            }

                    else
                        []
                   )
            )

main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = view identity materialStyle >> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }