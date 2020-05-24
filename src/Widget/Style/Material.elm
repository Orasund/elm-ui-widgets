module Widget.Style.Material exposing
    ( Palette, defaultPalette
    , containedButton, outlinedButton, textButton
    , toggleButton, buttonRow
    , alertDialog
    , row, column, cardColumn
    , expansionPanel
    , chip, darkPalette, snackbar, textInput
    )

{-|


# Style

@docs style


# Palette

@docs Palette, defaultPalette


# Button

@docs containedButton, outlinedButton, textButton

@docs toggleButton, buttonRow


# Dialog

@docs alertDialog


# List

@docs row, column, cardColumn


# Expansion Panel

@docs expansionPanel

-}

import Color exposing (Color)
import Color.Accessibility as Accessibility
import Color.Convert as Convert
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attributes
import Svg exposing (Svg)
import Svg.Attributes
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
-- T Y P O G R A P H Y
-------------------------------------------------------------------------------}


buttonFont : List (Attribute msg)
buttonFont =
    [ Element.htmlAttribute <| Attributes.style "text-transform" "uppercase"
    , Font.size 14
    , Font.semiBold --medium
    , Font.letterSpacing 1.25
    ]


h6 : List (Attribute msg)
h6 =
    [ Font.size 20
    , Font.semiBold --medium
    , Font.letterSpacing 0.15
    ]



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
    let
        l : Float
        l =
            1
                + (color |> Color.toRgba |> .alpha)
                * (Accessibility.luminance color - 1)
    in
    if (1.05 / (l + 0.05)) < 7 then
        Color.rgb255 0 0 0

    else
        Color.rgb255 255 255 255


accessibleWithTextColor : Color -> Color -> Color
accessibleWithTextColor c color =
    let
        l1 : Float
        l1 =
            1
                + (c |> Color.toRgba |> .alpha)
                * (Accessibility.luminance c - 1)

        l2 : Float
        l2 =
            1
                + (color |> Color.toRgba |> .alpha)
                * (Accessibility.luminance color - 1)

        newConstrast : Float
        newConstrast =
            7

        lighterLuminance : Float
        lighterLuminance =
            newConstrast * (l2 + 0.05) - 0.05

        darkerLuminance : Float
        darkerLuminance =
            (l2 + 0.05) - 0.05 / newConstrast
    in
    c
        |> (if l1 > l2 then
                if ((l1 + 0.05) / (l2 + 0.05)) < 7 then
                    Convert.colorToLab
                        >> (\col ->
                                { col | l = 100 * lighterLuminance }
                           )
                        >> Convert.labToColor

                else
                    identity

            else if ((l2 + 0.05) / (l1 + 0.05)) < 7 then
                Convert.colorToLab
                    >> (\col ->
                            { col | l = 100 * darkerLuminance }
                       )
                    >> Convert.labToColor

            else
                identity
           )


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


{-| using noahzgordon/elm-color-extra for colors
-}
withShade : Color -> Float -> Color -> Color
withShade c2 amount c1 =
    let
        alpha =
            c1
                |> Color.toRgba
                |> .alpha

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


dark : Color
dark =
    Color.rgb255 50 50 50


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


textAndBackground : Color -> List (Element.Attr decorative msg)
textAndBackground color =
    [ color
        |> fromColor
        |> Background.color
    , color
        |> accessibleTextColor
        |> fromColor
        |> Font.color
    ]



{-------------------------------------------------------------------------------
-- B U T T O N
-------------------------------------------------------------------------------}


baseButton : Palette -> ButtonStyle msg
baseButton _ =
    { container =
        buttonFont
            ++ [ Element.height <| Element.px 36
               , Element.paddingXY 8 8
               , Border.rounded <| 4
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
               , Element.mouseDown <|
                    (palette.primary
                        |> withShade palette.on.primary buttonPressedOpacity
                        |> textAndBackground
                    )
                        ++ [ Border.shadow <| shadow 12 ]
               , Element.focused <|
                    (palette.primary
                        |> withShade palette.on.primary buttonFocusOpacity
                        |> textAndBackground
                    )
                        ++ [ Border.shadow <| shadow 6 ]
               , Element.mouseOver <|
                    (palette.primary
                        |> withShade palette.on.primary buttonHoverOpacity
                        |> textAndBackground
                    )
                        ++ [ Border.shadow <| shadow 6 ]
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
        palette.primary
            |> withShade palette.on.primary buttonHoverOpacity
            |> textAndBackground
    , otherwise =
        palette.primary
            |> textAndBackground
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
               , Element.focused
                    [ palette.primary
                        |> scaleOpacity buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.mouseOver
                    [ palette.primary
                        |> scaleOpacity buttonHoverOpacity
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
        buttonFont
            ++ [ Element.width <| Element.px 48
               , Element.height <| Element.px 48
               , Element.padding 4
               , Border.width <| 1
               , Element.mouseDown <|
                    (palette.surface
                        |> withShade palette.on.surface buttonPressedOpacity
                        |> textAndBackground
                    )
                        ++ [ palette.on.surface
                                |> scaleOpacity 0.14
                                |> withShade palette.on.surface buttonPressedOpacity
                                |> fromColor
                                |> Border.color
                           ]
               , Element.focused []
               , Element.mouseOver <|
                    (palette.surface
                        |> withShade palette.on.surface buttonHoverOpacity
                        |> textAndBackground
                    )
                        ++ [ palette.on.surface
                                |> scaleOpacity 0.14
                                |> withShade palette.on.surface buttonHoverOpacity
                                |> fromColor
                                |> Border.color
                           ]
               ]
    , labelRow =
        [ Element.spacing <| 8
        , Element.height Element.fill
        , Element.width Element.fill
        , Border.rounded 24
        , Element.padding 8
        , Element.focused <|
            (palette.surface
                |> withShade palette.on.surface buttonFocusOpacity
                |> textAndBackground
            )
        ]
    , text = [ Element.centerX ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ palette.surface
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
        (palette.surface
            |> withShade palette.on.surface buttonSelectedOpacity
            |> textAndBackground
        )
            ++ [ palette.on.surface
                    |> scaleOpacity 0.14
                    |> withShade palette.on.surface buttonSelectedOpacity
                    |> fromColor
                    |> Border.color
               , Element.mouseOver []
               ]
    , otherwise =
        (palette.surface
            |> textAndBackground
        )
            ++ [ palette.on.surface
                    |> scaleOpacity 0.14
                    |> fromColor
                    |> Border.color
               ]
    }



{-------------------------------------------------------------------------------
-- C H I P
-------------------------------------------------------------------------------}


{-| Implementation Detail:

  - There seams to be a bug, where in the mouseOver effects are now visible.
    This might have something to do with <https://github.com/mdgriffith/elm-ui/issues/47>.
    This needs to be investigated, but for now i leave it at that.

  - Desided against the implementation of an outlined chip.
    Please open a new issue or a PR if you want to have it implemented.

-}
chip : Palette -> ButtonStyle msg
chip palette =
    { container =
        [ Element.height <| Element.px 32
        , Element.paddingEach
            { top = 0
            , right = 12
            , bottom = 0
            , left = 4
            }
        , Border.rounded <| 16
        , Element.mouseDown <|
            (palette.on.surface
                |> scaleOpacity 0.12
                |> withShade palette.on.surface buttonPressedOpacity
                |> textAndBackground
            )
        , Element.focused <|
            (palette.on.surface
                |> scaleOpacity 0.12
                |> withShade palette.on.surface buttonFocusOpacity
                |> textAndBackground
            )
        , Element.mouseOver <|
            (palette.on.surface
                |> scaleOpacity 0.12
                |> withShade palette.on.surface buttonHoverOpacity
                |> textAndBackground
            )
        ]
    , labelRow = [ Element.spacing 0, Element.centerY ]
    , text =
        [ Element.paddingEach
            { top = 0
            , right = 0
            , bottom = 0
            , left = 8
            }
        ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ (palette.on.surface
                    |> scaleOpacity 0.12
                    |> withShade palette.on.surface buttonDisabledOpacity
                    |> textAndBackground
               )
            ++ [ Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        (palette.on.surface
            |> scaleOpacity 0.12
            |> withShade palette.on.surface buttonSelectedOpacity
            |> textAndBackground
        )
            ++ [ Border.shadow <| shadow 4 ]
    , otherwise =
        palette.on.surface
            |> scaleOpacity 0.12
            |> textAndBackground
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


column : ColumnStyle msg
column =
    { containerColumn = [ Element.spacing 8 ]
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


{-| Implementation Detail:

This is a simplification of the [Material Design Card
](https://material.io/components/cards) and might get replaced at a later date.

-}
cardColumn : Palette -> ColumnStyle msg
cardColumn palette =
    { containerColumn =
        [ Element.width <| Element.fill
        , Element.mouseOver <|
            [ Border.shadow <| shadow 4 ]
        , Element.alignTop
        , Border.rounded 4
        ]
    , element =
        [ Element.padding 16
        , Border.rounded 4
        , Border.width 1
        , palette.surface
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
        , Element.width <| Element.minimum 344 <| Element.fill
        ]
    , ifFirst =
        [ Border.roundEach
            { topLeft = 4
            , topRight = 4
            , bottomLeft = 0
            , bottomRight = 0
            }
        ]
    , ifLast =
        [ Border.roundEach
            { topLeft = 0
            , topRight = 0
            , bottomLeft = 4
            , bottomRight = 4
            }
        , Border.widthEach
            { top = 0
            , left = 1
            , right = 1
            , bottom = 1
            }
        ]
    , otherwise =
        [ Border.rounded 0
        , Border.widthEach
            { top = 0
            , left = 1
            , right = 1
            , bottom = 1
            }
        ]
    }



{-------------------------------------------------------------------------------
-- D I A L O G
-------------------------------------------------------------------------------}


alertDialog : Palette -> DialogStyle msg
alertDialog palette =
    { containerColumn =
        [ Border.rounded 4
        , Element.fill
            |> Element.maximum 560
            |> Element.minimum 280
            |> Element.width
        , Element.height <| Element.minimum 182 <| Element.shrink
        , Background.color <| fromColor <| palette.surface
        ]
    , title = h6 ++ [ Element.paddingXY 24 20 ]
    , text = [ Element.paddingXY 24 0 ]
    , buttonRow =
        [ Element.paddingXY 8 8
        , Element.spacing 8
        , Element.alignRight
        , Element.alignBottom
        ]
    , acceptButton = containedButton palette
    , dismissButton = textButton palette
    }



{-------------------------------------------------------------------------------
-- E X P A N S I O N   P A N E L
-------------------------------------------------------------------------------}


icon : String -> List (Svg Never) -> Element Never
icon size =
    Svg.svg
        [ Svg.Attributes.height "24"
        , Svg.Attributes.stroke "currentColor"
        , Svg.Attributes.fill "currentColor"
        , Svg.Attributes.strokeLinecap "round"
        , Svg.Attributes.strokeLinejoin "round"
        , Svg.Attributes.strokeWidth "2"
        , Svg.Attributes.viewBox size
        , Svg.Attributes.width "24"
        ]
        >> Element.html
        >> Element.el []


expand_less : Element Never
expand_less =
    icon "0 0 48 48" [ Svg.path [ Svg.Attributes.d "M24 16L12 28l2.83 2.83L24 21.66l9.17 9.17L36 28z" ] [] ]


expand_more : Element Never
expand_more =
    icon "0 0 48 48" [ Svg.path [ Svg.Attributes.d "M33.17 17.17L24 26.34l-9.17-9.17L12 20l12 12 12-12z" ] [] ]


{-| Implementation Details:

  - The expansion panel is part of an [older version](https://material.io/archive/guidelines/components/expansion-panels.html) of the Material Design.
    The newer version is part of the List component.
    The styling is taken from the [new specification](https://material.io/components/lists#specs).
  - The Icons are taken from [icidasset/elm-material-icons](https://dark.elm.dmy.fr/packages/icidasset/elm-material-icons/latest) but seem wrong.

-}
expansionPanel : Palette -> ExpansionPanelStyle msg
expansionPanel palette =
    { containerColumn =
        [ Background.color <| fromColor <| palette.surface
        , Element.width <| Element.fill
        ]
    , panelRow =
        [ Element.height <| Element.px 48
        , Element.spaceEvenly
        , Element.padding 14
        , Element.width <| Element.fill
        ]
    , labelRow =
        [ Element.spacing 32
        ]
    , content =
        [ Element.padding 14 ]
    , expandIcon =
        expand_more
            |> Element.el
                [ gray
                    |> fromColor
                    |> Font.color
                ]
    , collapseIcon =
        expand_less
            |> Element.el
                [ gray
                    |> fromColor
                    |> Font.color
                ]
    }



{-------------------------------------------------------------------------------
-- S N A C K B A R
-------------------------------------------------------------------------------}


{-| Implementation Detail:

  - The text color of the button was not given in the specification. This implementation
    adujsts the luminance of the color to fit the [w3 accessability standard](https://www.w3.org/TR/WCAG20/#Contrast)

-}
snackbar : Palette -> SnackbarStyle msg
snackbar palette =
    { containerRow =
        [ dark
            |> fromColor
            |> Background.color
        , dark
            |> accessibleTextColor
            |> fromColor
            |> Font.color
        , Border.rounded 4
        , Element.width <| Element.maximum 344 <| Element.fill
        , Element.paddingXY 8 6
        , Element.spacing 8
        , Border.shadow <| shadow 2
        ]
    , text =
        [ Element.centerX
        , Element.paddingXY 10 8
        ]
    , button =
        textButton palette
            |> (\b ->
                    { b
                        | container =
                            b.container
                                ++ [ dark
                                        |> accessibleWithTextColor palette.primary
                                        |> fromColor
                                        |> Font.color
                                   ]
                    }
               )
    }



{-------------------------------------------------------------------------------
-- T E X T   I N P U T
-------------------------------------------------------------------------------}


{-| Implementation Detail:

  - This is just a temporary implementation. It will soon be replaced with the official implementation.

-}
textInput : Palette -> TextInputStyle msg
textInput palette =
    { chipButton = chip palette
    , chipsRow = [ Element.spacing 8 ]
    , containerRow =
        [ Element.spacing 8
        , Element.paddingXY 8 0
        , Border.width 1
        , Border.rounded 4
        , palette.on.surface
            |> scaleOpacity 0.14
            |> fromColor
            |> Border.color
        , Element.focused
            [ Border.shadow <| shadow 4
            , palette.primary
                |> fromColor
                |> Border.color
            ]
        , Element.mouseOver [ Border.shadow <| shadow 2 ]
        ]
    , input =
        [ Border.width 0
        , Element.mouseOver []
        , Element.focused []
        ]
    }



{-------------------------------------------------------------------------------
-- L A Y O U T
-------------------------------------------------------------------------------}

