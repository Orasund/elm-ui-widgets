module Widget.Style.Material exposing
    ( Palette, defaultPalette
    , buttonRow, containedButton, darkPalette, outlinedButton, row, textButton, toggleButton
    )

{-|


# Style

@docs style


# Palette

@docs Palette, defaultPalette


# Button

Material design comes with four types of buttons:

  - Contained buttons for **primary** actions
  - Outlined buttons for **secondary** actions
  - Text buttons for normal actions
  - Toggle buttons for **selecting** an action out of a group

![All four types next to eachother](https://lh3.googleusercontent.com/WTxHKH2jzRSMpsFtwfL-FzlD2wpmFSclAEEx5x55hOpn4IaVcXuYg7DWk6ruqww8WCi-FOItzwz88LTMuTF_15zBTHxU22VCzvebDg=w1064-v0)
_(Image taken from [material.io](https://material.io/components/buttons#usage))_

| ![Use primary buttons for a single action](https://lh3.googleusercontent.com/O0Xmm8U4xZmXhpGjM1PZQi3K2HGGPhmurZV0Y-Fge-pWBMVIXeI2y_Pdgmsvc5k1pdW-MCsZw5wLPsIb4VEEW4_98RpJqSK_G3eyDg=w1064-v0) | ![Only use one primary button per group](https://lh3.googleusercontent.com/T9NXwqJ3_K_HZQm3_-Lhlp6O6E67OLmIpxC7239p6WLlCAxCa4s01lEgxyNz6uMdPdkpmiyu02RmvPCEfJRugyUuwkSyKuj-V9wupA=w1064-v0) |
| ![Secondary buttons can be used like primary buttons. You can have multiple secondary buttons per group](https://lh3.googleusercontent.com/fNDmzeeVxcH-QHf_EWBCYny1sxKv4qs91qheWWYYwRyd-IEWJut9UtjOSVdbEvQbUC_E-Yh9wTJ_GQG3aXc8HdVT-uVicCAv1meoIQ=w1064-v0) | ![Use select buttons for different options](https://lh3.googleusercontent.com/esmi4QrTD57XxgjEwlR4LP9DenkSUkTUJPJfVhtBtdmahh5xifRJfV_ItOQp5Fm2EVeVORhtZfRqFBmdNzg3cZyW7pkKTCjJOYAfUg=w1064-v0) |
_(Images taken from [material.io](https://material.io/components/buttons#usage))_

-}

import Color exposing (Color)
import Color.Accessibility as Accessibility
import Color.Convert as Convert
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attributes
import Widget.Style
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , ExpansionPanelStyle
        , RowStyle
        , SnackbarStyle
        , SortTableStyle
        , TabStyle
        , TextInputStyle
        )



{-------------------------------------------------------------------------------
-- C O L O R
-------------------------------------------------------------------------------}


type alias Palette =
    { primary : Color --Color.rgb255 0x62 0x00 0xEE
    , secondary : Color --Color.rgb255 0x03 0xda 0xc6
    , background : Color --Color.rgb255 0xFF 0xFF 0xFF
    , surface : Color --Color.rgb255 0xFF 0xFF 0xFF
    , error : Color --Color.rgb255 0xB0 0x00 0x20
    , on :
        { primary : Color --Color.rgb255 0xFF 0xFF 0xFF
        , secondary : Color --Color.rgb255 0x00 0x00 0x00
        , background : Color --Color.rgb255 0x00 0x00 0x00
        , surface : Color --Color.rgb255 0x00 0x00 0x00
        , error : Color --Color.rgb255 0xFF 0xFF 0xFF
        }
    }


defaultPalette : Palette
defaultPalette =
    { primary = Color.rgb255 0x62 0x00 0xEE
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


darkPalette : Palette
darkPalette =
    { primary = Color.rgb255 0xBB 0x86 0xFC
    , secondary = Color.rgb255 0x03 0xDA 0xC6
    , background = Color.rgb255 0x12 0x12 0x12
    , surface = Color.rgb255 0x12 0x12 0x12
    , error = Color.rgb255 0xCF 0x66 0x79
    , on =
        { primary = Color.rgb255 0x00 0x00 0x00
        , secondary = Color.rgb255 0x00 0x00 0x00
        , background = Color.rgb255 0xFF 0xFF 0xFF
        , surface = Color.rgb255 0xFF 0xFF 0xFF
        , error = Color.rgb255 0x00 0x00 0x00
        }
    }


buttonHoverOpacity : Float
buttonHoverOpacity =
    0.08


buttonFocusOpacity : Float
buttonFocusOpacity =
    0.24


buttonPressedOpacity : Float
buttonPressedOpacity =
    0.32


buttonDisabledOpacity : Float
buttonDisabledOpacity =
    0.38


buttonSelectedOpacity : Float
buttonSelectedOpacity =
    0.16


accessibleTextColor : Color -> Color
accessibleTextColor color =
    if (1.05 / (Accessibility.luminance color + 0.05)) < 7 then
        Color.rgb255 0 0 0

    else
        Color.rgb255 255 255 255


{-| using noahzgordon/elm-color-extra for colors
-}
withShade : Color -> Float -> Color -> Color
withShade c2 amount c1 =
    let
        alpha =
            c1
                |> Color.toRgba
                |> .alpha

        toCIELCH =
            Convert.colorToLab
                >> (\{ l, a, b } ->
                        { l = l
                        , c = sqrt (a * a + b * b)
                        , h = atan2 b a
                        }
                   )

        fromCIELCH =
            (\{ l, c, h } ->
                { l = l
                , a = c * cos h
                , b = c * sin h
                }
            )
                >> Convert.labToColor

        fun a b =
            { l = (a.l * (1 - amount) + b.l * amount) / 1
            , c = (a.c * (1 - amount) + b.c * amount) / 1
            , h = (a.h * (1 - amount) + b.h * amount) / 1
            }
    in
    fun (toCIELCH c1) (toCIELCH c2)
        |> fromCIELCH
        |> Color.toRgba
        |> (\color -> { color | alpha = alpha })
        |> Color.fromRgba


scaleOpacity : Float -> Color -> Color
scaleOpacity opacity =
    Color.toRgba
        >> (\color -> { color | alpha = color.alpha * opacity })
        >> Color.fromRgba


gray : Color
gray =
    Color.rgb255 0x77 0x77 0x77


fromColor : Color -> Element.Color
fromColor =
    Color.toRgba >> Element.fromRgb


shadow :
    Float
    ->
        { offset : ( Float, Float )
        , size : Float
        , blur : Float
        , color : Element.Color
        }
shadow float =
    { color = Element.rgba255 0x00 0x00 0x00 0.2
    , offset = ( 0, float )
    , size = 0
    , blur = float
    }



{-------------------------------------------------------------------------------
-- B U T T O N
-------------------------------------------------------------------------------}


baseButton : Palette -> ButtonStyle msg
baseButton _ =
    { container =
        [ Element.height <| Element.px 36
        , Element.htmlAttribute <| Attributes.style "text-transform" "uppercase"
        , Element.paddingXY 8 8
        , Border.rounded <| 4
        , Font.size 14
        , Font.medium
        , Font.letterSpacing 1.25
        ]
    , labelRow =
        [ Element.spacing <| 8
        , Element.width <| Element.minimum 32 <| Element.shrink
        , Element.centerY
        ]
    , text = [ Element.centerX ]
    , ifDisabled =
        [ Element.htmlAttribute <| Attributes.style "cursor" "not-allowed"
        ]
    , ifActive = []
    , otherwise = []
    }


containedButton : Palette -> ButtonStyle msg
containedButton palette =
    { container =
        (baseButton palette |> .container)
            ++ [ Border.shadow <| shadow 2
               , Element.mouseDown
                    [ palette.primary
                        |> withShade palette.on.primary buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    , palette.primary
                        |> withShade palette.on.primary buttonPressedOpacity
                        |> accessibleTextColor
                        |> fromColor
                        |> Font.color
                    , Border.shadow <| shadow 12
                    ]
               , Element.mouseOver
                    [ palette.primary
                        |> withShade palette.on.primary buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    , palette.primary
                        |> withShade palette.on.primary buttonHoverOpacity
                        |> accessibleTextColor
                        |> fromColor
                        |> Font.color
                    , Border.shadow <| shadow 6
                    ]
               , Element.focused
                    [ palette.primary
                        |> withShade palette.on.primary buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    , palette.primary
                        |> withShade palette.on.primary buttonFocusOpacity
                        |> accessibleTextColor
                        |> fromColor
                        |> Font.color
                    , Border.shadow <| shadow 6
                    ]
               ]
    , labelRow =
        (baseButton palette |> .labelRow)
            ++ [ Element.paddingXY 8 0
               ]
    , text = baseButton palette |> .text
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ gray
                    |> scaleOpacity buttonDisabledOpacity
                    |> fromColor
                    |> Background.color
               , Font.color <| fromColor <| gray
               , Border.shadow <| shadow 0
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.primary
            |> withShade palette.on.primary buttonHoverOpacity
            |> fromColor
            |> Background.color
        , palette.primary
            |> withShade palette.on.primary buttonHoverOpacity
            |> accessibleTextColor
            |> fromColor
            |> Font.color
        ]
    , otherwise =
        [ palette.primary
            |> fromColor
            |> Background.color
        , palette.primary
            |> accessibleTextColor
            |> fromColor
            |> Font.color
        ]
    }


outlinedButton : Palette -> ButtonStyle msg
outlinedButton palette =
    { container =
        (baseButton palette |> .container)
            ++ [ Border.width <| 1
               , Border.color <| fromColor <| gray
               , Font.color <| fromColor <| palette.primary
               , Element.mouseDown
                    [ palette.primary
                        |> scaleOpacity buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    , gray
                        |> withShade palette.primary buttonPressedOpacity
                        |> fromColor
                        |> Border.color
                    ]
               , Element.mouseOver
                    [ palette.primary
                        |> scaleOpacity buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    , gray
                        |> withShade palette.primary buttonHoverOpacity
                        |> fromColor
                        |> Border.color
                    ]
               , Element.focused
                    [ palette.primary
                        |> scaleOpacity buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    , gray
                        |> withShade palette.primary buttonFocusOpacity
                        |> fromColor
                        |> Border.color
                    ]
               ]
    , labelRow =
        (baseButton palette |> .labelRow)
            ++ [ Element.paddingXY 8 0
               ]
    , text = baseButton palette |> .text
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ gray
                    |> fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.primary
            |> scaleOpacity buttonHoverOpacity
            |> fromColor
            |> Background.color
        , gray
            |> withShade palette.primary buttonHoverOpacity
            |> fromColor
            |> Border.color
        ]
    , otherwise =
        []
    }


textButton : Palette -> ButtonStyle msg
textButton palette =
    { container =
        (baseButton palette |> .container)
            ++ [ Font.color <| fromColor <| palette.primary
               , Element.mouseDown
                    [ palette.primary
                        |> scaleOpacity buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.mouseOver
                    [ palette.primary
                        |> scaleOpacity buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.focused
                    [ palette.primary
                        |> scaleOpacity buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    ]
               ]
    , labelRow = baseButton palette |> .labelRow
    , text = baseButton palette |> .text
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ gray
                    |> fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.primary
            |> scaleOpacity buttonHoverOpacity
            |> fromColor
            |> Background.color
        ]
    , otherwise =
        []
    }


{-| Implementation Detail:

  - Border color was not defined in the [specification](https://material.io/components/buttons#toggle-button)

-}
toggleButton : Palette -> ButtonStyle msg
toggleButton palette =
    { container =
        [ Element.width <| Element.px 48
        , Element.height <| Element.px 48
        , Element.padding 4
        , Element.htmlAttribute <| Attributes.style "text-transform" "uppercase"
        , Border.width <| 1
        , Font.size 14
        , Font.medium
        , Font.letterSpacing 1.25
        , Element.mouseDown
            [ palette.surface
                |> withShade palette.on.surface buttonPressedOpacity
                |> fromColor
                |> Background.color
            , palette.surface
                |> withShade palette.on.surface buttonPressedOpacity
                |> accessibleTextColor
                |> fromColor
                |> Font.color
            , palette.on.surface
                |> scaleOpacity 0.14
                |> withShade palette.on.surface buttonPressedOpacity
                |> fromColor
                |> Border.color
            ]
        , Element.mouseOver
            [ palette.surface
                |> withShade palette.on.surface buttonHoverOpacity
                |> fromColor
                |> Background.color
            , palette.surface
                |> withShade palette.on.surface buttonHoverOpacity
                |> accessibleTextColor
                |> fromColor
                |> Font.color
            , palette.on.surface
                |> scaleOpacity 0.14
                |> withShade palette.on.surface buttonHoverOpacity
                |> fromColor
                |> Border.color
            ]
        , Element.focused []
        ]
    , labelRow =
        [ Element.spacing <| 8
        , Element.height Element.fill
        , Element.width Element.fill
        , Border.rounded 24
        , Element.padding 8
        , Element.focused
            [ palette.surface
                |> withShade palette.on.surface buttonFocusOpacity
                |> fromColor
                |> Background.color
            , palette.surface
                |> withShade palette.on.surface buttonFocusOpacity
                |> accessibleTextColor
                |> fromColor
                |> Font.color
            ]
        ]
    , text = [ Element.centerX ]
    , ifDisabled =
        [ palette.surface
            |> fromColor
            |> Background.color
        , palette.on.surface
            |> scaleOpacity 0.14
            |> fromColor
            |> Border.color
        , gray
            |> fromColor
            |> Font.color
        , Element.mouseDown []
        , Element.mouseOver []
        ]
    , ifActive =
        [ palette.surface
            |> withShade palette.on.surface buttonSelectedOpacity
            |> fromColor
            |> Background.color
        , palette.surface
            |> withShade palette.on.surface buttonSelectedOpacity
            |> accessibleTextColor
            |> fromColor
            |> Font.color
        , palette.on.surface
            |> scaleOpacity 0.14
            |> withShade palette.on.surface buttonSelectedOpacity
            |> fromColor
            |> Border.color
        , Element.mouseOver []
        ]
    , otherwise =
        [ palette.surface
            |> fromColor
            |> Background.color
        , palette.surface
            |> accessibleTextColor
            |> fromColor
            |> Font.color
        , palette.on.surface
            |> scaleOpacity 0.14
            |> fromColor
            |> Border.color
        ]
    }



{-------------------------------------------------------------------------------
-- L I S T
-------------------------------------------------------------------------------}


row : RowStyle msg
row =
    { containerRow = [ Element.spacing 8 ]
    , element = []
    , ifFirst = []
    , ifLast = []
    , otherwise = []
    }


buttonRow : RowStyle msg
buttonRow =
    { containerRow = []
    , element =
        [ Border.rounded 2
        ]
    , ifFirst =
        [ Border.roundEach
            { topLeft = 2
            , topRight = 0
            , bottomLeft = 2
            , bottomRight = 0
            }
        ]
    , ifLast =
        [ Border.roundEach
            { topLeft = 0
            , topRight = 2
            , bottomLeft = 0
            , bottomRight = 2
            }
        ]
    , otherwise =
        [ Border.rounded 0
        ]
    }
