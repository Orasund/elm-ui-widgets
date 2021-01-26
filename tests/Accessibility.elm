module Accessibility exposing (main)

import Browser
import Color exposing (Color)
import Color.Accessibility as Accessibility
import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Input
import Widget exposing (ButtonStyle, ColumnStyle, RowStyle)
import Widget.Material as Material exposing (Palette)


type alias Style style msg =
    { style
        | primaryButton : ButtonStyle msg
        , button : ButtonStyle msg
        , row : RowStyle msg
        , column : ColumnStyle msg
    }


type MaterialIOTitleColor
    = White
    | Black


primaryColors : List ( String, Color, MaterialIOTitleColor )
primaryColors =
    --, ( "original", Color.rgb255 0x00 0x88 0xCE ) -- #0088ce -- Our own primary color
    [ ( "900", Color.rgb255 0x00 0x58 0x98, White ) -- #005898
    , ( "800", Color.rgb255 0x00 0x78 0xBA, White ) -- #0078ba
    , ( "700", Color.rgb255 0x00 0x89 0xCE, Black ) -- #0089ce -- material.io palette tool primary color
    , ( "600", Color.rgb255 0x05 0x9C 0xE2, Black ) -- #059ce2
    , ( "500", Color.rgb255 0x08 0xAA 0xF1, Black ) -- #08aaf1
    , ( "400", Color.rgb255 0x2C 0xB7 0xF3, Black ) -- #2cb7f3
    , ( "300", Color.rgb255 0x51 0xC4 0xF4, Black ) -- #51c4f4
    , ( "200", Color.rgb255 0x82 0xD5 0xF8, Black ) -- #82d5f8
    , ( "100", Color.rgb255 0xB3 0xE5 0xFA, Black ) -- #b3e5fa
    , ( "050", Color.rgb255 0xE1 0xF5 0xFD, Black ) -- #e1f5fd
    ]


materialStyle : Style {} msg
materialStyle =
    { primaryButton = Material.containedButton Material.defaultPalette
    , button = Material.outlinedButton Material.defaultPalette
    , row = Material.row
    , column = Material.column
    }


customPalette : Color -> Palette
customPalette primaryColor =
    { primary = primaryColor
    , secondary = Color.rgb255 0x03 0xDA 0xC6
    , background = Color.rgb255 0xFF 0xFF 0xFF
    , surface = Color.rgb255 0xFF 0xFF 0xFF
    , error = Color.rgb255 0xB0 0x00 0x20
    , on =
        { primary = Color.rgb255 0xFF 0xFF 0xFF
        , secondary = Color.rgb255 0x00 0x00 0x00
        , background = Color.rgb255 0x00 0x00 0x00
        , surface = Color.rgb255 0x00 0x00 0x00
        , error = Color.rgb255 0xFF 0xFF 0xFF
        }
    }


primaryButtonStyle : Color -> ButtonStyle msg
primaryButtonStyle color =
    let
        newPalette =
            customPalette color
    in
    Material.containedButton newPalette


type Model
    = IsButtonEnabled Bool


type Msg
    = Noop


init : ( Model, Cmd Msg )
init =
    ( IsButtonEnabled True
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element.Element msg
view msgMapper style (IsButtonEnabled isButtonEnabled) =
    let
        colorFromMaterialIOTitleColor : MaterialIOTitleColor -> Color
        colorFromMaterialIOTitleColor materialIOTitleColor =
            case materialIOTitleColor of
                White ->
                    Color.white

                Black ->
                    Color.black

        elmUiColor : Color -> Element.Color
        elmUiColor color =
            color |> Color.toRgba |> Element.fromRgb

        row : ( String, Color, MaterialIOTitleColor ) -> Element.Element msg
        row ( colorCode, color, materialIOTitleColor ) =
            let
                materialFontColor =
                    materialIOTitleColor
                        |> colorFromMaterialIOTitleColor
                        |> elmUiColor

                maximumContrastColor =
                    Accessibility.maximumContrast color [ Color.white, Color.black ]
                        |> Maybe.withDefault Color.red
                        |> elmUiColor
            in
            [ Widget.button (primaryButtonStyle color)
                { text = colorCode ++ " - Elm UI Widgets"
                , icon = always Element.none
                , onPress =
                    if isButtonEnabled then
                        Noop
                            |> msgMapper
                            |> Just

                    else
                        Nothing
                }
            , Element.Input.button
                [ Element.Background.color (elmUiColor color)
                , Element.padding 8
                , Element.Border.rounded 3
                ]
                { onPress = Nothing
                , label =
                    Element.row [ Element.spacingXY 10 0 ]
                        [ Element.el
                            [ Element.Font.color materialFontColor
                            , Element.Font.size 16
                            ]
                            (Element.text (colorCode ++ " - Material IO"))
                        ]
                }
            , Element.Input.button
                [ Element.Background.color (elmUiColor color)
                , Element.padding 8
                , Element.Border.rounded 3
                ]
                { onPress = Nothing
                , label =
                    Element.row [ Element.spacingXY 10 0 ]
                        [ Element.el
                            [ Element.Font.color maximumContrastColor
                            , Element.Font.size 16
                            ]
                            (Element.text (colorCode ++ " - Max Contrast"))
                        ]
                }
            ]
                |> Widget.row style.row

        rows =
            List.map row primaryColors
    in
    rows |> Widget.column style.column


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = view identity materialStyle >> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
