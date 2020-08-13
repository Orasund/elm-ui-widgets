module Widget.Style.Material exposing
    ( Palette, defaultPalette, darkPalette
    , containedButton, outlinedButton, textButton
    , iconButton, toggleButton, buttonRow
    , cardColumn
    , chip, textInput
    , alertDialog
    , expansionPanel
    , row, column
    , progressIndicator
    , snackbar
    , tab, tabButton
    , layout
    )

{-| ![Example using the Material Design style](https://orasund.github.io/elm-ui-widgets/assets/material-style.png)

This module implements a Material design theme for all widgets.

The stylings are following [the official Material Design guidelines](https://material.io/components) as close as possible.
Please use these widgets in combination with the official guidelines.

The typograpahy is taken from [the material design guidelines](https://material.io/design/typography/the-type-system.html#type-scale).
Its recommended to use a font size of 16px width and the [Roboto Font](https://fonts.google.com/specimen/Roboto?query=Ro).

The style are not opaque, so you can change every styling to your needs.

If you have any suggestions or improvements, be sure to leave a PR or a Issue over at the github repos.

You can use the theme by copying the following code:

    type alias Style msg =
        { dialog : DialogStyle msg
        , expansionPanel : ExpansionPanelStyle msg
        , button : ButtonStyle msg
        , primaryButton : ButtonStyle msg
        , tab : TabStyle msg
        , textInput : TextInputStyle msg
        , chipButton : ButtonStyle msg
        , row : RowStyle msg
        , buttonRow : RowStyle msg
        , column : ColumnStyle msg
        , cardColumn : ColumnStyle msg
        , sortTable : SortTableStyle msg
        , selectButton : ButtonStyle msg
        , progressIndicator : ProgressIndicatorStyle msg
        , layout : LayoutStyle msg
        }

    sortTable : Palette -> SortTableStyle msg
    sortTable palette =
        { containerTable = []
        , headerButton = Material.textButton palette
        , ascIcon = Icons.chevronUp |> Element.html |> Element.el []
        , descIcon = Icons.chevronDown |> Element.html |> Element.el []
        , defaultIcon = Element.none
        }

    style : Palette -> Style msg
    style palette =
        { sortTable = sortTable palette
        , row = Material.row
        , buttonRow = Material.buttonRow
        , cardColumn = Material.cardColumn palette
        , column = Material.column
        , button = Material.outlinedButton palette
        , primaryButton = Material.containedButton palette
        , selectButton = Material.toggleButton palette
        , tab = Material.tab palette
        , textInput = Material.textInput palette
        , chipButton = Material.chip palette
        , expansionPanel = Material.expansionPanel palette
        , dialog = Material.alertDialog palette
        , progressIndicator = Material.progressIndicator palette
        , layout = Material.layout palette
        }


# Palette

@docs Palette, defaultPalette, darkPalette


# Button

Different styles for buttons have different meanings.

  - Use `textButton` as your default button
  - Use `containedButton` for any important action
  - Use `outlinedButton` if you have more then one important action.
    Use `containedButton` for **the most** important action of the group.

@docs containedButton, outlinedButton, textButton

@docs iconButton, toggleButton, buttonRow


# Card

In the material design specification the card is not really specified at all.
Im practice the List seams more useful then a own card widget.
Thus for now we only provide a card containing a list.

@docs cardColumn


# Chip

@docs chip, textInput


# Dialog

@docs alertDialog


# Expansion Panel

@docs expansionPanel


# List

The [List widget](https://material.io/components/lists) is a very complex widget that sadly only particially made it into this package.

@docs row, column


# Progress Indicator

@docs progressIndicator


# Snackbar

@docs snackbar


# Tab

@docs tab, tabButton


# Layout

@docs layout

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
        , LayoutStyle
        , ProgressIndicatorStyle
        , RowStyle
        , SnackbarStyle
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


{-| The material design comes with customizable color palettes.

Check out [the official documentation about the color system](https://material.io/design/color/the-color-system.html#color-theme-creation) to see how these colors are used.

For the `-on` colors you can use white, for transitions into white, or black,for transitions into black. Other colors are also possible, but i've not seen any website acutally using a different color.

-}
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


{-| The default color theme.

![The default theme](https://lh3.googleusercontent.com/k6WO1fd7T40A9JvSVfHqs0CPLFyTEDCecsVGxEDhOaTP0wUTPYOVVkxt60hKxBprgNoMqs8OyKqtlaQ4tDBtQJs-fTcZrpZEjxhUVQ=w1064-v0)

_Image take from [material.io](https://material.io/design/color/the-color-system.html#color-theme-creation)_

-}
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


{-| The offical dark theme of google.

![The dark theme](https://lh3.googleusercontent.com/tv7J2o4ZiSmLYwyBslBs_PLzKyzI8QUV5qdvHGfoAQn9r7pY4Hj5SmW27m3zUWeDtRSE8Cb5_5PQmkbavDfw7XbIL8EodIKZhilRdg=w1064-v0)

_Image take from [material.io](https://material.io/design/color/dark-theme.html#ui-application)_

-}
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

        ratioBlack : Float
        ratioBlack =
            1.05 / (l + 0.05)

        ratioWhite : Float
        ratioWhite =
            (l + 0.05) / 0.05
    in
    if ratioBlack < ratioWhite then
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


toCIELCH : Color -> { l : Float, c : Float, h : Float }
toCIELCH =
    Convert.colorToLab
        >> (\{ l, a, b } ->
                { l = l
                , c = sqrt (a * a + b * b)
                , h = atan2 b a
                }
           )


fromCIELCH : { l : Float, c : Float, h : Float } -> Color
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


{-| A contained button representing the most important action of a group.

![Contained Button](https://material.io/develop/images/content/79e62add1830d33fc90edb22212bce53.svg)

_Image taken from [material.io](https://material.io/develop/android/components/buttons/)_

-}
containedButton : Palette -> ButtonStyle msg
containedButton palette =
    { container =
        (baseButton palette |> .container)
            ++ [ Border.shadow <| shadow 2
               , Element.mouseDown <|
                    [ palette.primary
                        |> withShade palette.on.primary buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    , Border.shadow <| shadow 12
                    ]
               , Element.focused <|
                    [ palette.primary
                        |> withShade palette.on.primary buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    , Border.shadow <| shadow 6
                    ]
               , Element.mouseOver <|
                    [ palette.primary
                        |> withShade palette.on.primary buttonHoverOpacity
                        |> fromColor
                        |> Background.color
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


{-| A outlined button representing an important action within a group.

![Outlined Button](https://material.io/develop/images/content/2b50635d38c5fdec260f09be9aeafb10.svg)

_Image taken from [material.io](https://material.io/develop/android/components/buttons/)_

-}
outlinedButton : Palette -> ButtonStyle msg
outlinedButton palette =
    { container =
        (baseButton palette |> .container)
            ++ [ Border.width <| 1
               , Font.color <| fromColor <| palette.primary
               , palette.on.surface
                    |> scaleOpacity 0.14
                    |> withShade palette.primary buttonHoverOpacity
                    |> fromColor
                    |> Border.color
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
        ]
    , otherwise =
        []
    }


{-| A text button representing a simple action within a group.

![Text Button](https://material.io/develop/images/content/d3079632c6f54d86f9b7093d541c2ee9.svg)

_Image taken from [material.io](https://material.io/develop/android/components/buttons/)_

-}
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


{-| A ToggleButton. Only use as a group in combination with `buttonRow`.

![Toggle Button](https://material.io/develop/images/content/749a1ba8591d02356fa1d6eea2641d96.svg)

_Image taken from [material.io](https://material.io/develop/android/components/buttons/)_

Toggle buttons should only be used with the `iconButton` widget, else use chips instead.

Technical Remark:

  - Border color was not defined in the [specification](https://material.io/components/buttons#toggle-button)
  - There are two different versions, one where the selected color is gray and another where the color is primary.
    I noticed the gray version was used more often, so i went with that one.

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
                    [ palette.surface
                        |> withShade palette.on.surface buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    , palette.on.surface
                        |> scaleOpacity 0.14
                        |> withShade palette.on.surface buttonPressedOpacity
                        |> fromColor
                        |> Border.color
                    ]
               , Element.focused []
               , Element.mouseOver <|
                    [ palette.surface
                        |> withShade palette.on.surface buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    , palette.on.surface
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
        [ palette.surface
            |> withShade palette.on.surface buttonSelectedOpacity
            |> fromColor
            |> Background.color
        , palette.surface
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


{-| An single selectable icon.

![Icon Button](https://material.io/develop/images/content/9bc212d8a3ef79bb7ed83a5359651505.png)

_Image taken from [material.io](https://material.io/develop/android/components/buttons/)_

Technical Remark:

  - Could not find any specification details

-}
iconButton : Palette -> ButtonStyle msg
iconButton palette =
    { container =
        (baseButton palette |> .container)
            ++ [ Element.height <| Element.px 48
               , Border.rounded 24

               --, Font.color <| fromColor <| palette.primary
               , Element.mouseDown
                    [ palette.surface
                        |> scaleOpacity buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.focused
                    [ palette.surface
                        |> scaleOpacity buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.mouseOver
                    [ palette.surface
                        |> scaleOpacity buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    ]
               ]
    , labelRow =
        [ Element.spacing 8
        , Element.width <| Element.shrink
        , Element.centerY
        , Element.centerX
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
        [ palette.surface
            |> scaleOpacity buttonHoverOpacity
            |> fromColor
            |> Background.color
        ]
    , otherwise =
        []
    }



{-------------------------------------------------------------------------------
-- C H I P
-------------------------------------------------------------------------------}


{-| Chips have the same behaviour as buttons but are visually less important.

In the [official documentation](https://material.io/components/chips#types) chips have different names depending on where they are used:

  - **Input Chips** are used inside a text field. Use `textInput` for this feature.
  - **Choice Chips** are used for selcting an option.
    The material design guidelines recommend using `toggleButton` for icons with no text and chips for text with no icons.
  - **Filter Chips** are used for selecting multiple options. They typically have a done-icon when selected.
  - **Action chips** are like button. Make sure to include an icon when using action chips.

Technical Remark:

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
            [ palette.on.surface
                |> scaleOpacity 0.12
                |> withShade palette.on.surface buttonPressedOpacity
                |> fromColor
                |> Background.color
            ]
        , Element.focused <|
            [ palette.on.surface
                |> scaleOpacity 0.12
                |> withShade palette.on.surface buttonFocusOpacity
                |> fromColor
                |> Background.color
            ]
        , Element.mouseOver <|
            [ palette.on.surface
                |> scaleOpacity 0.12
                |> withShade palette.on.surface buttonHoverOpacity
                |> fromColor
                |> Background.color
            ]
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
        [ palette.on.surface
            |> scaleOpacity 0.12
            |> withShade palette.on.surface buttonSelectedOpacity
            |> fromColor
            |> Background.color
        , palette.on.surface
            |> scaleOpacity 0.12
            |> accessibleTextColor
            |> fromColor
            |> Font.color
        , Border.shadow <| shadow 4
        ]
    , otherwise =
        [ palette.on.surface
            |> scaleOpacity 0.12
            |> fromColor
            |> Background.color
        , palette.on.surface
            |> scaleOpacity 0.12
            |> accessibleTextColor
            |> fromColor
            |> Font.color
        ]
    }



{-------------------------------------------------------------------------------
-- L I S T
-------------------------------------------------------------------------------}


{-| A simple styling for a row.
-}
row : RowStyle msg
row =
    { containerRow =
        [ Element.paddingXY 0 8
        , Element.spacing 8
        ]
    , element = []
    , ifFirst = []
    , ifLast = []
    , otherwise = []
    }


{-| A simple styling for a column.
-}
column : ColumnStyle msg
column =
    { containerColumn =
        [ Element.paddingXY 0 8
        , Element.spacing 8
        ]
    , element = []
    , ifFirst = []
    , ifLast = []
    , otherwise = []
    }


{-| a Row of buttons.

Only use in combination with `toggleButton`

-}
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


{-| A List styled like a card.

Technical Remark:

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


{-| An alert dialog for important decisions. Use a snackbar for less important notification.

![Alert Dialog](https://material.io/develop/images/content/9d61e2d1bd60599344c7fae5e71c9667.png)

_Image taken from [material.io](https://material.io/develop/android/components/buttons/)_

-}
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


icon : String -> Int -> List (Svg Never) -> Element Never
icon string size =
    Svg.svg
        [ Svg.Attributes.height <| String.fromInt size
        , Svg.Attributes.stroke "currentColor"
        , Svg.Attributes.fill "currentColor"

        --, Svg.Attributes.strokeLinecap "round"
        --, Svg.Attributes.strokeLinejoin "round"
        --, Svg.Attributes.strokeWidth "2"
        , Svg.Attributes.viewBox string
        , Svg.Attributes.width <| String.fromInt size
        ]
        >> Element.html
        >> Element.el []


expand_less : Element Never
expand_less =
    icon "0 0 48 48" 24 [ Svg.path [ Svg.Attributes.d "M24 16L12 28l2.83 2.83L24 21.66l9.17 9.17L36 28z" ] [] ]


expand_more : Element Never
expand_more =
    icon "0 0 48 48" 24 [ Svg.path [ Svg.Attributes.d "M33.17 17.17L24 26.34l-9.17-9.17L12 20l12 12 12-12z" ] [] ]


{-| The expansion Panel is an outdated part of the material design specification.
In modern implementation it gets replaced with a very sophisticated list widget.

Technical Remarks:

  - The expansion panel is part of an [older version](https://material.io/archive/guidelines/components/expansion-panels.html) of the Material Design.
    The newer version is part of the List component.
    The styling is taken from the [new specification](https://material.io/components/lists#specs).
  - The Icons are taken from [danmarcab/material-icons](https://dark.elm.dmy.fr/packages/danmarcab/material-icons/latest/).

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
-- P R O G R E S S   I N D I C A T O R
-------------------------------------------------------------------------------}


indeterminateCircularIcon : Color.Color -> List (Attribute msg) -> Element msg
indeterminateCircularIcon color attribs =
    -- Based on example at https://codepen.io/FezVrasta/pen/oXrgdR
    Svg.svg
        [ Svg.Attributes.height "48px"
        , Svg.Attributes.width "48px"
        , Svg.Attributes.viewBox "0 0 66 66"
        , Svg.Attributes.xmlSpace "http://www.w3.org/2000/svg"
        ]
        [ Svg.g []
            [ Svg.animateTransform
                [ Svg.Attributes.attributeName "transform"
                , Svg.Attributes.type_ "rotate"
                , Svg.Attributes.values "0 33 33;270 33 33"
                , Svg.Attributes.begin "0s"
                , Svg.Attributes.dur "1.4s"
                , Svg.Attributes.fill "freeze"
                , Svg.Attributes.repeatCount "indefinite"
                ]
                []
            , Svg.circle
                [ Svg.Attributes.fill "none"
                , Svg.Attributes.stroke (Color.toCssString color)
                , Svg.Attributes.strokeWidth "5"
                , Svg.Attributes.strokeLinecap "square"
                , Svg.Attributes.cx "33"
                , Svg.Attributes.cy "33"
                , Svg.Attributes.r "30"
                , Svg.Attributes.strokeDasharray "187"
                , Svg.Attributes.strokeDashoffset "610"
                ]
                [ Svg.animateTransform
                    [ Svg.Attributes.attributeName "transform"
                    , Svg.Attributes.type_ "rotate"
                    , Svg.Attributes.values "0 33 33;135 33 33;450 33 33"
                    , Svg.Attributes.begin "0s"
                    , Svg.Attributes.dur "1.4s"
                    , Svg.Attributes.fill "freeze"
                    , Svg.Attributes.repeatCount "indefinite"
                    ]
                    []
                , Svg.animate
                    [ Svg.Attributes.attributeName "stroke-dashoffset"
                    , Svg.Attributes.values "187;46.75;187"
                    , Svg.Attributes.begin "0s"
                    , Svg.Attributes.dur "1.4s"
                    , Svg.Attributes.fill "freeze"
                    , Svg.Attributes.repeatCount "indefinite"
                    ]
                    []
                ]
            ]
        ]
        |> Element.html
        |> Element.el attribs


determinateCircularIcon : Color.Color -> List (Attribute msg) -> Float -> Element msg
determinateCircularIcon color attribs progress =
    -- With help from https://css-tricks.com/building-progress-ring-quickly/
    let
        strokeDashoffset =
            let
                clampedProgress =
                    clamp 0 1 progress
            in
            -- 188 is circumference of circle in pixels
            188
                - (188 * clampedProgress)
                |> round
    in
    Svg.svg
        [ Svg.Attributes.height "48px"
        , Svg.Attributes.width "48px"
        , Svg.Attributes.viewBox "0 0 66 66"
        , Svg.Attributes.xmlSpace "http://www.w3.org/2000/svg"
        ]
        [ Svg.g []
            [ Svg.circle
                [ Svg.Attributes.fill "none"
                , Svg.Attributes.stroke (Color.toCssString color)
                , Svg.Attributes.strokeWidth "5"
                , Svg.Attributes.strokeLinecap "butt"
                , Svg.Attributes.cx "33"
                , Svg.Attributes.cy "33"
                , Svg.Attributes.r "30"
                , Svg.Attributes.strokeDasharray "188 188"
                , Svg.Attributes.strokeDashoffset (String.fromInt strokeDashoffset)
                , Svg.Attributes.transform "rotate(-90 33 33)"
                ]
                []
            ]
        ]
        |> Element.html
        |> Element.el attribs


{-| A circular progress indicator
-}
progressIndicator : Palette -> ProgressIndicatorStyle msg
progressIndicator palette =
    { containerFunction =
        \maybeProgress ->
            case maybeProgress of
                Nothing ->
                    indeterminateCircularIcon palette.primary []

                Just progress ->
                    determinateCircularIcon palette.primary [] progress
    }



{-------------------------------------------------------------------------------
-- S N A C K B A R
-------------------------------------------------------------------------------}


{-| A typical snackbar

![Snackbar](https://material.io/develop/images/content/f2ec5451582a06af5eb20e3dfb3d27d5.svg)

_Image take from [material.io](https://material.io/develop/android/components/snackbar/)_

Technical Remark:

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


{-| A text input style that is included only to support input chips.

Technical Remark:

  - This is just a temporary implementation. It will soon be replaced with the official implementation.

-}
textInput : Palette -> TextInputStyle msg
textInput palette =
    { chipButton = chip palette
    , chipsRow = [ Element.spacing 8 ]
    , containerRow =
        (palette.surface
            |> textAndBackground
        )
            ++ [ Element.spacing 8
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
        (palette.surface
            |> textAndBackground
        )
            ++ [ Border.width 0
               , Element.mouseOver []
               , Element.focused []
               ]
    }



{-------------------------------------------------------------------------------
-- T A B
-------------------------------------------------------------------------------}


{-| A single Tab button.

Technical Remark:

  - The official specification states that the background color should be the surface color,
    but the pictures and actuall implementations all have no background color.
    So here the background color is also not set.

-}
tabButton : Palette -> ButtonStyle msg
tabButton palette =
    { container =
        buttonFont
            ++ [ Element.height <| Element.px 48
               , Element.fill
                    |> Element.maximum 360
                    |> Element.minimum 90
                    |> Element.width
               , Element.paddingXY 12 16
               , Font.color <| fromColor <| palette.primary
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
    , labelRow =
        [ Element.spacing <| 8
        , Element.centerY
        , Element.centerX
        ]
    , text = []
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
        [ Element.height <| Element.px 48
        , Border.widthEach
            { bottom = 2
            , left = 0
            , right = 0
            , top = 0
            }
        ]
    , otherwise =
        []
    }


{-| A Tab bar meant for only the upper most level. Do not use a tab within a tab.
-}
tab : Palette -> TabStyle msg
tab palette =
    { button = tabButton palette
    , optionRow =
        [ Element.spaceEvenly
        , Border.shadow <| shadow 4
        , Element.spacing 8
        , Element.width <| Element.fill
        ]
    , containerColumn = [ Element.spacing 8, Element.width <| Element.fill ]
    , content = [ Element.width <| Element.fill ]
    }



{-------------------------------------------------------------------------------
-- L A Y O U T
-------------------------------------------------------------------------------}


more_vert : Element Never
more_vert =
    icon "0 0 48 48" 24 [ Svg.path [ Svg.Attributes.d "M24 16c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 4c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4zm0 12c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4z" ] [] ]


search : Element Never
search =
    icon "0 0 48 48" 24 [ Svg.path [ Svg.Attributes.d "M31 28h-1.59l-.55-.55C30.82 25.18 32 22.23 32 19c0-7.18-5.82-13-13-13S6 11.82 6 19s5.82 13 13 13c3.23 0 6.18-1.18 8.45-3.13l.55.55V31l10 9.98L40.98 38 31 28zm-12 0c-4.97 0-9-4.03-9-9s4.03-9 9-9 9 4.03 9 9-4.03 9-9 9z" ] [] ]


menu : Element Never
menu =
    icon "0 0 48 48" 24 [ Svg.path [ Svg.Attributes.d "M6 36h36v-4H6v4zm0-10h36v-4H6v4zm0-14v4h36v-4H6z" ] [] ]


menuTabButton : Palette -> ButtonStyle msg
menuTabButton palette =
    { container =
        buttonFont
            ++ [ Element.height <| Element.px 56
               , Element.fill
                    |> Element.maximum 360
                    |> Element.minimum 90
                    |> Element.width
               , Element.paddingXY 12 16
               , palette.primary
                    |> accessibleTextColor
                    |> fromColor
                    |> Font.color
               , Element.alignBottom
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
    , labelRow =
        [ Element.spacing <| 8
        , Element.centerY
        , Element.centerX
        ]
    , text = []
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
        [ Border.widthEach
            { bottom = 2
            , left = 0
            , right = 0
            , top = 0
            }
        ]
    , otherwise =
        []
    }


drawerButton : Palette -> ButtonStyle msg
drawerButton palette =
    { container =
        [ Font.size 14
        , Font.semiBold
        , Font.letterSpacing 0.25
        , Element.height <| Element.px 36
        , Element.width <| Element.fill
        , Element.paddingXY 8 8
        , Border.rounded <| 4
        , palette.surface
            |> accessibleTextColor
            |> fromColor
            |> Font.color
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
        , palette.primary
            |> fromColor
            |> Font.color
        ]
    , otherwise =
        []
    }


{-| The Layout Widget combines the following Material design concepts:

  - Top bar
  - Navigation drawer
  - Side Sheet
  - Dialog
  - Snackbar

Future updates might try to seperate them into there own widgets.
But for now they are only available as an all-in-one solution.

Technical Remark:

  - The Icons are taken from [danmarcab/material-icons](https://dark.elm.dmy.fr/packages/danmarcab/material-icons/latest/).
  - The drawer button as not taken from the specification (This will been to be added later)

-}
layout : Palette -> LayoutStyle msg
layout palette =
    { container =
        (palette.background |> textAndBackground)
            ++ [ Font.family
                    [ Font.typeface "Roboto"
                    , Font.sansSerif
                    ]
               , Font.size 16
               , Font.letterSpacing 0.5
               ]
    , snackbar = snackbar palette
    , layout = Element.layout
    , header =
        (palette.primary
            |> textAndBackground
        )
            ++ [ Element.height <| Element.px 56
               , Element.padding 16
               , Element.width <| Element.minimum 360 <| Element.fill
               ]
    , menuButton = iconButton palette
    , sheetButton = drawerButton palette
    , menuTabButton = menuTabButton palette
    , sheet =
        (palette.surface |> textAndBackground)
            ++ [ Element.width <| Element.maximum 360 <| Element.fill
               , Element.padding 8
               , Element.spacing 8
               ]
    , menuIcon = menu
    , moreVerticalIcon = more_vert
    , spacing = 8
    , title = h6 ++ [ Element.paddingXY 8 0 ]
    , searchIcon = search
    , search =
        (palette.surface |> textAndBackground)
            ++ [ Element.spacing 8
               , Element.paddingXY 8 8
               , Element.height <| Element.px 32
               , Border.width 1
               , Border.rounded 4
               , palette.on.surface
                    |> scaleOpacity 0.14
                    |> fromColor
                    |> Border.color
               , Element.focused
                    [ Border.shadow <| shadow 4
                    ]
               , Element.mouseOver [ Border.shadow <| shadow 2 ]
               , Element.width <| Element.maximum 360 <| Element.fill
               , Element.alignRight
               ]
    , searchFill =
        palette.surface |> textAndBackground
    }
