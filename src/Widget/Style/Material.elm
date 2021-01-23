module Widget.Style.Material exposing
    ( Palette, defaultPalette, darkPalette
    , containedButton, outlinedButton, textButton
    , iconButton, toggleButton, buttonRow
    , switch
    , cardColumn
    , chip, textInput
    , alertDialog
    , expansionPanel, expansionPanelItem
    , row, column, fullBleedDivider
    , progressIndicator
    , snackbar
    , tab, tabButton
    , layout, insetDivider
    , middleDividers,insetTitle, fullBleedTitle
    )

{-| ![Example using the Material Design style](https://orasund.github.io/elm-ui-widgets/assets/material-style.png)

This module implements a Material design theme for all widgets.

The stylings are following [the official Material Design guidelines](https://material.io/components) as close as possible.
Please use these widgets in combination with the official guidelines.

The typograpahy is taken from [the material design guidelines](https://material.io/design/typography/the-type-system.html#type-scale).
Its recommended to use a font size of 16px width and the [Roboto Font](https://fonts.google.com/specimen/Roboto?query=Ro).

The style are not opaque, so you can change every styling to your needs.

If you have any suggestions or improvements, be sure to leave a PR or a Issue over at the github repos.

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


# Switch

@docs switch


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

@docs expansionPanel, expansionPanelItem


# List

The [List widget](https://material.io/components/lists) is a very complex widget that sadly only particially made it into this package.

@docs row, column

# Item

A List is build from items.
You way want to use special items to visually organize the content of your list.

@docs fullBleedDivider, insetDivider, middleDividers, insetTitle, fullBleedTitle

# Progress Indicator

@docs progressIndicator


# Snackbar

@docs snackbar


# Tab

@docs tab, tabButton


# Layout

@docs layout


# Advanced

To create your own Material Widgets, here are all internal functions.
Note that you might want to checkout the [file on GitHub](https://github.com/Orasund/elm-ui-widgets/blob/master/src/Widget/Style/Material.elm) if you want to tweak some internal behaviour.

-}

import Color exposing (Color)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attributes
import Svg exposing (Svg)
import Svg.Attributes
import Widget.Icon as Icon exposing (Icon)
import Widget.Style
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , ExpansionPanelStyle
        , ItemStyle
        , LayoutStyle
        , ProgressIndicatorStyle
        , RowStyle
        , SnackbarStyle
        , SwitchStyle
        , TabStyle
        , TextInputStyle
        , DividerStyle
        , TitleStyle
        )
import Widget.Style.Customize as Customize
import Widget.Style.Material.Color as MaterialColor
import Widget.Style.Material.Typography as Typography


fromColor : Color -> Element.Color
fromColor =
    Color.toRgba >> Element.fromRgb



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


textAndBackground : Color -> List (Element.Attr decorative msg)
textAndBackground color =
    [ color
        |> fromColor
        |> Background.color
    , color
        |> MaterialColor.accessibleTextColor
        |> fromColor
        |> Font.color
    ]



{-------------------------------------------------------------------------------
-- B U T T O N
-------------------------------------------------------------------------------}


baseButton : Palette -> ButtonStyle msg
baseButton _ =
    { elementButton =
        Typography.button
            ++ [ Element.height <| Element.px 36
               , Element.paddingXY 8 8
               , Border.rounded <| 4
               ]
    , ifDisabled =
        [ Element.htmlAttribute <| Attributes.style "cursor" "not-allowed"
        ]
    , ifActive = []
    , otherwise = []
    , content =
        { elementRow =
            [ Element.spacing <| 8
            , Element.width <| Element.minimum 32 <| Element.shrink
            , Element.centerY
            ]
        , content =
            { text = { contentText = [ Element.centerX ] }
            , icon =
                { ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , ifActive =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                }
            }
        }
    }


{-| A contained button representing the most important action of a group.
-}
containedButton : Palette -> ButtonStyle msg
containedButton palette =
    { elementButton =
        (baseButton palette |> .elementButton)
            ++ [ Border.shadow <| MaterialColor.shadow 2
               , Element.mouseDown <|
                    [ palette.primary
                        |> MaterialColor.withShade palette.on.primary MaterialColor.buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    , Border.shadow <| MaterialColor.shadow 12
                    ]
               , Element.focused <|
                    [ palette.primary
                        |> MaterialColor.withShade palette.on.primary MaterialColor.buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    , Border.shadow <| MaterialColor.shadow 6
                    ]
               , Element.mouseOver <|
                    [ palette.primary
                        |> MaterialColor.withShade palette.on.primary MaterialColor.buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    , Border.shadow <| MaterialColor.shadow 6
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonDisabledOpacity
                    |> fromColor
                    |> Background.color
               , Font.color <| fromColor <| MaterialColor.gray
               , Border.shadow <| MaterialColor.shadow 0
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.primary
            |> MaterialColor.withShade palette.on.primary MaterialColor.buttonHoverOpacity
            |> fromColor
            |> Background.color
        , palette.primary
            |> MaterialColor.accessibleTextColor
            |> fromColor
            |> Font.color
        ]
    , otherwise =
        [ palette.primary
            |> fromColor
            |> Background.color
        , palette.primary
            |> MaterialColor.accessibleTextColor
            |> fromColor
            |> Font.color
        ]
    , content =
        { elementRow =
            (baseButton palette |> .content |> .elementRow)
                ++ [ Element.paddingXY 8 0 ]
        , content =
            { text = { contentText = baseButton palette |> (\b -> b.content.content.text.contentText) }
            , icon =
                { ifActive =
                    { size = 18
                    , color =
                        palette.primary
                            |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color =
                        palette.primary
                            |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }


{-| A outlined button representing an important action within a group.
-}
outlinedButton : Palette -> ButtonStyle msg
outlinedButton palette =
    { elementButton =
        (baseButton palette |> .elementButton)
            ++ [ Border.width <| 1
               , Font.color <| fromColor <| palette.primary
               , palette.on.surface
                    |> MaterialColor.scaleOpacity 0.14
                    |> MaterialColor.withShade palette.primary MaterialColor.buttonHoverOpacity
                    |> fromColor
                    |> Border.color
               , Element.mouseDown
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.focused
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.mouseOver
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
                    |> fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.primary
            |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
            |> fromColor
            |> Background.color
        ]
    , otherwise =
        []
    , content =
        { elementRow =
            (baseButton palette
                |> .content
                |> .elementRow
            )
                ++ [ Element.paddingXY 8 0 ]
        , content =
            { text =
                { contentText =
                    baseButton palette
                        |> .content
                        |> .content
                        |> .text
                        |> .contentText
                }
            , icon =
                { ifActive =
                    { size = 18
                    , color = palette.primary
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = palette.primary
                    }
                }
            }
        }
    }


{-| A text button representing a simple action within a group.
-}
textButton : Palette -> ButtonStyle msg
textButton palette =
    { elementButton =
        (baseButton palette |> .elementButton)
            ++ [ Font.color <| fromColor <| palette.primary
               , Element.mouseDown
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.focused
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.mouseOver
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
                    |> fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.primary
            |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
            |> fromColor
            |> Background.color
        ]
    , otherwise =
        []
    , content =
        { elementRow = baseButton palette |> (\b -> b.content.elementRow)
        , content =
            { text = { contentText = baseButton palette |> (\b -> b.content.content.text.contentText) }
            , icon =
                { ifActive =
                    { size = 18
                    , color = palette.primary
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = palette.primary
                    }
                }
            }
        }
    }


{-| A ToggleButton. Only use as a group in combination with `buttonRow`.

Toggle buttons should only be used with the `iconButton` widget, else use chips instead.

Technical Remark:

  - Border color was not defined in the [specification](https://material.io/components/buttons#toggle-button)
  - There are two different versions, one where the selected color is gray and another where the color is primary.
    I noticed the gray version was used more often, so i went with that one.

-}
toggleButton : Palette -> ButtonStyle msg
toggleButton palette =
    { elementButton =
        Typography.button
            ++ [ Element.width <| Element.px 48
               , Element.height <| Element.px 48
               , Element.padding 4
               , Border.width <| 1
               , Element.mouseDown <|
                    [ palette.surface
                        |> MaterialColor.withShade palette.on.surface MaterialColor.buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    , palette.on.surface
                        |> MaterialColor.scaleOpacity 0.14
                        |> MaterialColor.withShade palette.on.surface MaterialColor.buttonPressedOpacity
                        |> fromColor
                        |> Border.color
                    ]
               , Element.focused []
               , Element.mouseOver <|
                    [ palette.surface
                        |> MaterialColor.withShade palette.on.surface MaterialColor.buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    , palette.on.surface
                        |> MaterialColor.scaleOpacity 0.14
                        |> MaterialColor.withShade palette.on.surface MaterialColor.buttonHoverOpacity
                        |> fromColor
                        |> Border.color
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ palette.surface
                    |> fromColor
                    |> Background.color
               , palette.on.surface
                    |> MaterialColor.scaleOpacity 0.14
                    |> fromColor
                    |> Border.color
               , MaterialColor.gray
                    |> fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               ]
    , ifActive =
        [ palette.surface
            |> MaterialColor.withShade palette.on.surface MaterialColor.buttonSelectedOpacity
            |> fromColor
            |> Background.color
        , palette.surface
            |> MaterialColor.accessibleTextColor
            |> fromColor
            |> Font.color
        , palette.on.surface
            |> MaterialColor.scaleOpacity 0.14
            |> MaterialColor.withShade palette.on.surface MaterialColor.buttonSelectedOpacity
            |> fromColor
            |> Border.color
        , Element.mouseOver []
        ]
    , otherwise =
        [ palette.surface
            |> fromColor
            |> Background.color
        , palette.surface
            |> MaterialColor.accessibleTextColor
            |> fromColor
            |> Font.color
        , palette.on.surface
            |> MaterialColor.scaleOpacity 0.14
            |> fromColor
            |> Border.color
        ]
    , content =
        { elementRow =
            [ Element.spacing <| 8
            , Element.height Element.fill
            , Element.width Element.fill
            , Border.rounded 24
            , Element.padding 8
            , Element.focused <|
                (palette.surface
                    |> MaterialColor.withShade palette.on.surface MaterialColor.buttonFocusOpacity
                    |> textAndBackground
                )
            ]
        , content =
            { text = { contentText = [ Element.centerX ] }
            , icon =
                { ifActive =
                    { size = 24
                    , color =
                        palette.surface
                            |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 24
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 24
                    , color =
                        palette.surface
                            |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }


{-| An single selectable icon.

Technical Remark:

  - Could not find any specification details

-}
iconButton : Palette -> ButtonStyle msg
iconButton palette =
    { elementButton =
        (baseButton palette |> .elementButton)
            ++ [ Element.height <| Element.px 48
               , Border.rounded 24
               , Element.mouseDown
                    [ palette.surface
                        |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.focused
                    [ palette.surface
                        |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.mouseOver
                    [ palette.surface
                        |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
                    |> fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.surface
            |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
            |> fromColor
            |> Background.color
        ]
    , otherwise =
        []
    , content =
        { elementRow =
            [ Element.spacing 8
            , Element.width <| Element.shrink
            , Element.centerY
            , Element.centerX
            ]
        , content =
            { text = { contentText = baseButton palette |> (\b -> b.content.content.text.contentText) }
            , icon =
                { ifActive =
                    { size = 18
                    , color = palette.primary
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = palette.primary
                    }
                }
            }
        }
    }


{-| A boolean switch

Technical Remark:

  - The specification states that the disabled switch should have a color dependend on its activness. This is not implemented.

-}
switch : Palette -> SwitchStyle msg
switch palette =
    { elementButton =
        [ Element.height <| Element.px 38
        , Element.width <| Element.px 58
        , Element.mouseDown []
        , Element.focused []
        , Element.mouseOver []
        ]
    , content =
        { element =
            [ Element.height <| Element.px 14
            , Element.width <| Element.px 34
            , Border.rounded <| 10
            ]
        , ifDisabled =
            [ Element.htmlAttribute <| Attributes.style "cursor" "not-allowed"
            , palette.surface
                |> MaterialColor.withShade MaterialColor.gray (0.5 * MaterialColor.buttonDisabledOpacity)
                |> fromColor
                |> Background.color
            ]
        , ifActive =
            [ palette.primary
                |> MaterialColor.scaleOpacity 0.5
                |> fromColor
                |> Background.color
            ]
        , otherwise =
            [ MaterialColor.gray
                |> MaterialColor.scaleOpacity 0.5
                |> fromColor
                |> Background.color
            ]
        }
    , contentInFront =
        { element =
            [ Element.height <| Element.px 38
            , Element.width <| Element.px 38
            , Border.rounded <| 19
            ]
        , ifDisabled =
            [ Element.htmlAttribute <| Attributes.style "cursor" "not-allowed" ]
        , ifActive =
            [ Element.mouseDown
                [ palette.primary
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> fromColor
                    |> Background.color
                ]
            , Element.focused
                [ palette.primary
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> fromColor
                    |> Background.color
                ]
            , Element.mouseOver
                [ palette.primary
                    |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                    |> fromColor
                    |> Background.color
                ]
            , Element.alignRight
            ]
        , otherwise =
            [ Element.mouseDown
                [ Color.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> fromColor
                    |> Background.color
                ]
            , Element.focused
                [ Color.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> fromColor
                    |> Background.color
                ]
            , Element.mouseOver
                [ Color.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                    |> fromColor
                    |> Background.color
                ]
            , Element.alignLeft
            ]
        , content =
            { element =
                [ Element.height <| Element.px 20
                , Element.width <| Element.px 20
                , Element.centerY
                , Element.centerX
                , Border.rounded <| 10
                , Border.shadow <| MaterialColor.shadow 2
                , palette.surface
                    |> fromColor
                    |> Background.color
                ]
            , ifDisabled =
                [ palette.surface
                    |> MaterialColor.withShade Color.gray MaterialColor.buttonDisabledOpacity
                    |> fromColor
                    |> Background.color
                , Element.mouseDown []
                , Element.mouseOver []
                , Element.focused []
                ]
            , ifActive =
                [ palette.primary
                    |> MaterialColor.withShade palette.on.primary MaterialColor.buttonHoverOpacity
                    |> fromColor
                    |> Background.color
                ]
            , otherwise =
                [ palette.surface
                    |> MaterialColor.withShade palette.on.surface MaterialColor.buttonHoverOpacity
                    |> fromColor
                    |> Background.color
                ]
            }
        }
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
    { elementButton =
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
                |> MaterialColor.scaleOpacity 0.12
                |> MaterialColor.withShade palette.on.surface MaterialColor.buttonPressedOpacity
                |> fromColor
                |> Background.color
            ]
        , Element.focused <|
            [ palette.on.surface
                |> MaterialColor.scaleOpacity 0.12
                |> MaterialColor.withShade palette.on.surface MaterialColor.buttonFocusOpacity
                |> fromColor
                |> Background.color
            ]
        , Element.mouseOver <|
            [ palette.on.surface
                |> MaterialColor.scaleOpacity 0.12
                |> MaterialColor.withShade palette.on.surface MaterialColor.buttonHoverOpacity
                |> fromColor
                |> Background.color
            ]
        ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ (palette.on.surface
                    |> MaterialColor.scaleOpacity 0.12
                    |> MaterialColor.withShade palette.on.surface MaterialColor.buttonDisabledOpacity
                    |> textAndBackground
               )
            ++ [ Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.on.surface
            |> MaterialColor.scaleOpacity 0.12
            |> MaterialColor.withShade palette.on.surface MaterialColor.buttonSelectedOpacity
            |> fromColor
            |> Background.color
        , palette.on.surface
            |> MaterialColor.scaleOpacity 0.12
            |> MaterialColor.accessibleTextColor
            |> fromColor
            |> Font.color
        , Border.shadow <| MaterialColor.shadow 4
        ]
    , otherwise =
        [ palette.on.surface
            |> MaterialColor.scaleOpacity 0.12
            |> fromColor
            |> Background.color
        , palette.on.surface
            |> MaterialColor.scaleOpacity 0.12
            |> MaterialColor.accessibleTextColor
            |> fromColor
            |> Font.color
        ]
    , content =
        { elementRow = [ Element.spacing 0, Element.centerY ]
        , content =
            { text =
                { contentText =
                    [ Element.paddingEach
                        { top = 0
                        , right = 0
                        , bottom = 0
                        , left = 8
                        }
                    ]
                }
            , icon =
                { ifActive =
                    { size = 18
                    , color =
                        palette.on.surface
                            |> MaterialColor.scaleOpacity 0.12
                            |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 18
                    , color =
                        palette.on.surface
                            |> MaterialColor.scaleOpacity 0.12
                            |> MaterialColor.accessibleTextColor
                    }
                , otherwise =
                    { size = 18
                    , color =
                        palette.on.surface
                            |> MaterialColor.scaleOpacity 0.12
                            |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }



{-------------------------------------------------------------------------------
-- L I S T
-------------------------------------------------------------------------------}


{-| A simple styling for a row.
-}
row : RowStyle msg
row =
    { elementRow =
        [ Element.paddingXY 0 8
        , Element.spacing 8
        ]
    , content =
        { element = []
        , ifSingleton = []
        , ifFirst = []
        , ifLast = []
        , otherwise = []
        }
    }


{-| A simple styling for a column.
-}
column : ColumnStyle msg
column =
    { elementColumn =
        [ Element.paddingXY 0 8
        , Element.spacing 8
        ]
    , content =
        { element = []
        , ifSingleton = []
        , ifFirst = []
        , ifLast = []
        , otherwise = []
        }
    }

{-| A divider covering the full length
-}
fullBleedDivider : ItemStyle (DividerStyle msg)
fullBleedDivider =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.px 1
        , Element.padding 0
        , Border.widthEach
            { bottom = 0
            , left = 1
            , right = 1
            , top = 0
            }
        ]
    , content = { element = [Element.width <| Element.fill, Element.height <| Element.px 1
    ,Color.gray
            |> fromColor
            |> Background.color]
                }
    }

{-| A divider covering only parts of the width
-}
insetDivider : Palette -> ItemStyle (DividerStyle msg)
insetDivider palette =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.px 1
        , Border.widthEach
            { bottom = 0
            , left = 1
            , right = 1
            , top = 0
            }
        , Element.paddingEach
            { bottom = 0
            , left = 72
            , right = 0
            , top = 0
            }
        ]
    , content = { element = [Element.width <| Element.fill, Element.height <| Element.px 1
    ,Color.gray
            |> fromColor
            |> Background.color]
                }
    }

{-| A divider in the center
-}
middleDividers : Palette -> ItemStyle (DividerStyle msg)
middleDividers palette =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.px 1
        , Border.widthEach
            { bottom = 0
            , left = 1
            , right = 1
            , top = 0
            }
        , Element.paddingEach
            { bottom = 0
            , left = 16
            , right = 16
            , top = 0
            }
        ]
    , content = { element = [Element.width <| Element.fill, Element.height <| Element.px 1
    ,Color.gray
            |> fromColor
            |> Background.color]
                }
    }

{-| A title of a section of a list. Comes with a inset divider.
-}
insetTitle : Palette -> ItemStyle (TitleStyle msg)
insetTitle palette =
    { element =
        [ Element.width <| Element.fill
        , Border.widthEach
            { bottom = 0
            , left = 1
            , right = 1
            , top = 0
            }
        , Element.paddingEach
            { bottom = 0
            , left = 72
            , right = 0
            , top = 0
            }
        ]
    , content = 
        { elementColumn = 
            [ Element.width <| Element.fill
            , Element.spacing <| 12
            ]
        , content =
            { divider = insetDivider palette
                |> .content
            , title = Typography.body2 ++ [MaterialColor.gray
            |> fromColor
            |> Font.color]
            }
        }
    }

{-| A title of a section of a list. Comes with a full bleed divider.
-}
fullBleedTitle : Palette -> ItemStyle (TitleStyle msg)
fullBleedTitle palette =
    { element =
        [ Element.width <| Element.fill
        , Element.padding 0
        , Border.widthEach
            { bottom = 0
            , left = 1
            , right = 1
            , top = 0
            }
        ]
    , content = 
        { elementColumn = 
            [ Element.width <| Element.fill
            , Element.spacing <| 8
            ]
        , content =
            { divider = insetDivider palette
                |> .content
            , title = Typography.caption ++ [MaterialColor.gray
            |> fromColor
            |> Font.color
            , Element.paddingXY 16 0]
            }
        }
    }

{-| a Row of buttons.

Only use in combination with `toggleButton`

-}
buttonRow : RowStyle msg
buttonRow =
    { elementRow = []
    , content =
        { element = []
        , ifSingleton =
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
    }


{-| A List styled like a card.

Technical Remark:

This is a simplification of the [Material Design Card
](https://material.io/components/cards) and might get replaced at a later date.

-}
cardColumn : Palette -> ColumnStyle msg
cardColumn palette =
    { elementColumn =
        [ Element.width <| Element.fill
        , Element.mouseOver <|
            [ Border.shadow <| MaterialColor.shadow 4 ]
        , Element.alignTop
        , Border.rounded 4
        ]
    , content =
        { element =
            [ Element.padding 16
            , palette.surface
                |> fromColor
                |> Background.color
            , palette.surface
                |> MaterialColor.accessibleTextColor
                |> fromColor
                |> Font.color
            , palette.on.surface
                |> MaterialColor.scaleOpacity 0.14
                |> fromColor
                |> Border.color
            , Element.width <| Element.minimum 344 <| Element.fill
            ]
        , ifSingleton =
            [ Border.rounded 4
            ]
        , ifFirst =
            [ Border.roundEach
                { topLeft = 4
                , topRight = 4
                , bottomLeft = 0
                , bottomRight = 0
                }
            , Border.widthEach
                { top = 1
                , left = 1
                , right = 1
                , bottom = 0
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
                , bottom = 0
                }
            ]
        }
    }



{-------------------------------------------------------------------------------
-- D I A L O G
-------------------------------------------------------------------------------}


{-| An alert dialog for important decisions. Use a snackbar for less important notification.
-}
alertDialog : Palette -> DialogStyle msg
alertDialog palette =
    { elementColumn =
        [ Border.rounded 4
        , Element.fill
            |> Element.maximum 560
            |> Element.minimum 280
            |> Element.width
        , Element.height <| Element.minimum 182 <| Element.shrink
        , Background.color <| fromColor <| palette.surface
        ]
    , content =
        { title =
            { contentText = Typography.h6 ++ [ Element.paddingXY 24 20 ]
            }
        , text =
            { contentText = [ Element.paddingXY 24 0 ]
            }
        , buttons =
            { elementRow =
                [ Element.paddingXY 8 8
                , Element.spacing 8
                , Element.alignRight
                , Element.alignBottom
                ]
            , content =
                { accept = containedButton palette
                , dismiss = textButton palette
                }
            }
        }
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


expand_less : Icon
expand_less { size, color } =
    icon "0 0 48 48"
        size
        [ Svg.path
            [ Svg.Attributes.d "M24 16L12 28l2.83 2.83L24 21.66l9.17 9.17L36 28z"
            , Svg.Attributes.stroke (Color.toCssString color)
            ]
            []
        ]


expand_more : Icon
expand_more { size, color } =
    icon "0 0 48 48"
        size
        [ Svg.path
            [ Svg.Attributes.d "M33.17 17.17L24 26.34l-9.17-9.17L12 20l12 12 12-12z"
            , Svg.Attributes.stroke (Color.toCssString color)
            ]
            []
        ]


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
    expansionPanelItem palette
        |> .content
        |> Customize.mapContent
            (\record ->
                { record
                    | panel =
                        record.panel
                            |> Customize.elementRow
                                [ Element.height <| Element.px 48
                                , Element.padding 14
                                ]
                    , content =
                        record.content
                            |> Customize.element
                                [ Element.paddingEach
                                    { top = 0
                                    , right = 14
                                    , bottom = 14
                                    , left = 14
                                    }
                                ]
                }
            )


{-| A variant on the expansion Panel optimized to be used inside a card.

This is a small workaround to allow expansion panels within cards.

-}
expansionPanelItem : Palette -> ItemStyle (ExpansionPanelStyle msg)
expansionPanelItem palette =
    { element = []
    , content =
        { elementColumn =
            [ Background.color <| fromColor <| palette.surface
            , Element.spacing 14
            , Element.width <| Element.fill
            ]
        , content =
            { panel =
                { elementRow =
                    [ Element.spaceEvenly
                    , Element.width <| Element.fill
                    ]
                , content =
                    { label =
                        { elementRow = [ Element.spacing 32 ]
                        , content =
                            { icon =
                                { size = 16
                                , color = MaterialColor.gray
                                }
                            , text = { elementText = [] }
                            }
                        }
                    , expandIcon = expand_more
                    , collapseIcon = expand_less
                    , icon =
                        { size = 24
                        , color = MaterialColor.gray
                        }
                    }
                }
            , content =
                { element = [ Element.width <| Element.fill ]
                }
            }
        }
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
    { elementFunction =
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

Technical Remark:

  - The text color of the button was not given in the specification. This implementation
    adujsts the luminance of the color to fit the [w3 accessability standard](https://www.w3.org/TR/WCAG20/#Contrast)

-}
snackbar : Palette -> SnackbarStyle msg
snackbar palette =
    { elementRow =
        [ MaterialColor.dark
            |> fromColor
            |> Background.color
        , MaterialColor.dark
            |> MaterialColor.accessibleTextColor
            |> fromColor
            |> Font.color
        , Border.rounded 4
        , Element.width <| Element.maximum 344 <| Element.fill
        , Element.paddingXY 8 6
        , Element.spacing 8
        , Border.shadow <| MaterialColor.shadow 2
        ]
    , content =
        { text =
            { elementText =
                [ Element.centerX
                , Element.paddingXY 10 8
                ]
            }
        , button =
            textButton palette
                |> Customize.elementButton
                    [ MaterialColor.dark
                        |> MaterialColor.accessibleWithTextColor palette.primary
                        |> fromColor
                        |> Font.color
                    ]
        }
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
    { elementRow =
        (palette.surface
            |> textAndBackground
        )
            ++ [ Element.spacing 8
               , Element.paddingXY 8 0
               , Border.width 1
               , Border.rounded 4
               , palette.on.surface
                    |> MaterialColor.scaleOpacity 0.14
                    |> fromColor
                    |> Border.color
               , Element.focused
                    [ Border.shadow <| MaterialColor.shadow 4
                    , palette.primary
                        |> fromColor
                        |> Border.color
                    ]
               , Element.mouseOver [ Border.shadow <| MaterialColor.shadow 2 ]
               ]
    , content =
        { chips =
            { elementRow = [ Element.spacing 8 ]
            , content = chip palette
            }
        , text =
            { elementTextInput =
                (palette.surface
                    |> textAndBackground
                )
                    ++ [ Border.width 0
                       , Element.mouseOver []
                       , Element.focused []
                       , Element.centerY
                       ]
            }
        }
    }


searchInput : Palette -> TextInputStyle msg
searchInput palette =
    textInputBase palette
        |> Customize.mapElementRow
            (always
                [ Element.alignRight
                , Element.paddingXY 8 8
                , Border.rounded 4
                ]
            )
        |> Customize.mapContent
            (\record ->
                { record
                    | text =
                        record.text
                            |> Customize.elementTextInput
                                [ Border.width 0
                                , Element.paddingXY 8 8
                                , Element.height <| Element.px 32
                                , Element.width <| Element.maximum 360 <| Element.fill
                                ]
                }
            )


textInputBase : Palette -> TextInputStyle msg
textInputBase palette =
    { elementRow = palette.surface |> textAndBackground
    , content =
        { chips =
            { elementRow = [ Element.spacing 8 ]
            , content = chip palette
            }
        , text =
            { elementTextInput =
                (palette.surface
                    |> textAndBackground
                )
                    ++ [ Border.width 0
                       , Element.mouseOver []
                       , Element.focused []
                       ]
            }
        }
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
    { elementButton =
        Typography.button
            ++ [ Element.height <| Element.px 48
               , Element.fill
                    |> Element.maximum 360
                    |> Element.minimum 90
                    |> Element.width
               , Element.paddingXY 12 16
               , Font.color <| fromColor <| palette.primary
               , Element.mouseDown
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.focused
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.mouseOver
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
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
    , content =
        { elementRow =
            [ Element.spacing <| 8
            , Element.centerY
            , Element.centerX
            ]
        , content =
            { text = { contentText = [] }
            , icon =
                { ifActive =
                    { size = 18
                    , color = palette.primary
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = palette.primary
                    }
                }
            }
        }
    }


{-| A Tab bar meant for only the upper most level. Do not use a tab within a tab.
-}
tab : Palette -> TabStyle msg
tab palette =
    { elementColumn = [ Element.spacing 8, Element.width <| Element.fill ]
    , content =
        { tabs =
            { elementRow =
                [ Element.spaceEvenly
                , Border.shadow <| MaterialColor.shadow 4
                , Element.spacing 8
                , Element.width <| Element.fill
                ]
            , content = tabButton palette
            }
        , content = [ Element.width <| Element.fill ]
        }
    }



{-------------------------------------------------------------------------------
-- L A Y O U T
-------------------------------------------------------------------------------}


more_vert : Icon
more_vert { size, color } =
    icon "0 0 48 48"
        size
        [ Svg.path
            [ Svg.Attributes.d "M24 16c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 4c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4zm0 12c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4z"
            , Svg.Attributes.stroke <| Color.toCssString color
            ]
            []
        ]


search : Icon
search { size, color } =
    icon "0 0 48 48"
        size
        [ Svg.path
            [ Svg.Attributes.d "M31 28h-1.59l-.55-.55C30.82 25.18 32 22.23 32 19c0-7.18-5.82-13-13-13S6 11.82 6 19s5.82 13 13 13c3.23 0 6.18-1.18 8.45-3.13l.55.55V31l10 9.98L40.98 38 31 28zm-12 0c-4.97 0-9-4.03-9-9s4.03-9 9-9 9 4.03 9 9-4.03 9-9 9z"
            , Svg.Attributes.stroke <| Color.toCssString color
            ]
            []
        ]


menu : Icon
menu { size, color } =
    icon "0 0 48 48"
        size
        [ Svg.path
            [ Svg.Attributes.d "M6 36h36v-4H6v4zm0-10h36v-4H6v4zm0-14v4h36v-4H6z"
            , Svg.Attributes.stroke <| Color.toCssString color
            ]
            []
        ]


menuTabButton : Palette -> ButtonStyle msg
menuTabButton palette =
    { elementButton =
        Typography.button
            ++ [ Element.height <| Element.px 56
               , Element.fill
                    |> Element.maximum 360
                    |> Element.minimum 90
                    |> Element.width
               , Element.paddingXY 12 16
               , palette.primary
                    |> MaterialColor.accessibleTextColor
                    |> fromColor
                    |> Font.color
               , Element.alignBottom
               , Element.mouseDown
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.focused
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                        |> fromColor
                        |> Background.color
                    ]
               , Element.mouseOver
                    [ palette.primary
                        |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                        |> fromColor
                        |> Background.color
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
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
    , content =
        { elementRow =
            [ Element.spacing <| 8
            , Element.centerY
            , Element.centerX
            ]
        , content =
            { text = { contentText = [] }
            , icon =
                { ifActive =
                    { size = 18
                    , color = palette.primary |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = palette.primary |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }


drawerButton : Palette -> ButtonStyle msg
drawerButton palette =
    { elementButton =
        [ Font.size 14
        , Font.semiBold
        , Font.letterSpacing 0.25
        , Element.height <| Element.px 36
        , Element.width <| Element.fill
        , Element.paddingXY 8 8
        , Border.rounded <| 4
        , palette.surface
            |> MaterialColor.accessibleTextColor
            |> fromColor
            |> Font.color
        , Element.mouseDown
            [ palette.primary
                |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                |> fromColor
                |> Background.color
            ]
        , Element.focused
            [ palette.primary
                |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                |> fromColor
                |> Background.color
            ]
        , Element.mouseOver
            [ palette.primary
                |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                |> fromColor
                |> Background.color
            ]
        ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
                    |> fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.primary
            |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
            |> fromColor
            |> Background.color
        , palette.primary
            |> fromColor
            |> Font.color
        ]
    , otherwise =
        []
    , content =
        { elementRow = baseButton palette |> .content |> .elementRow
        , content =
            { text = { contentText = baseButton palette |> (\b -> b.content.content.text.contentText) }
            , icon =
                { ifActive =
                    { size = 18
                    , color = palette.surface |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = palette.surface |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
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
    , menuButton =
        iconButton palette
            |> Customize.mapContent
                (Customize.mapContent
                    (\record ->
                        { record
                            | icon =
                                { ifActive =
                                    { size = record.icon.ifActive.size
                                    , color =
                                        palette.primary
                                            |> MaterialColor.accessibleTextColor
                                    }
                                , ifDisabled =
                                    record.icon.ifDisabled
                                , otherwise =
                                    { size = record.icon.otherwise.size
                                    , color =
                                        palette.primary
                                            |> MaterialColor.accessibleTextColor
                                    }
                                }
                        }
                    )
                )
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
    , title = Typography.h6 ++ [ Element.paddingXY 8 0 ]
    , searchIcon = search
    , search = searchInput palette
    , searchFill = textInputBase palette
    }
