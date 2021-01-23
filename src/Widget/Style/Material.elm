module Widget.Style.Material exposing
    ( Palette, defaultPalette, darkPalette
    , containedButton, outlinedButton, textButton
    , iconButton, toggleButton, buttonRow
    , switch
    , cardColumn
    , chip, textInput
    , alertDialog
    , expansionPanel, expansionPanelItem
    , row, column
    , fullBleedDivider, insetDivider, middleDividers, insetTitle, fullBleedTitle
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
import Internal.Material.Button as Button
import Internal.Material.Chip as Chip
import Internal.Material.Dialog as Dialog
import Internal.Material.ExpansionPanel as ExpansionPanel
import Internal.Material.Layout as Layout
import Internal.Material.List as List
import Internal.Material.Palette as Palette
import Internal.Material.ProgressIndicator as ProgressIndicator
import Internal.Material.Snackbar as Snackbar
import Internal.Material.Switch as Switch
import Internal.Material.Tab as Tab
import Internal.Material.TextInput as TextInput
import Widget.Style
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , DividerStyle
        , ExpansionPanelStyle
        , ItemStyle
        , LayoutStyle
        , ProgressIndicatorStyle
        , RowStyle
        , SnackbarStyle
        , SwitchStyle
        , TabStyle
        , TextInputStyle
        , TitleStyle
        )



--------------------------------------------------------------------------------
-- C O L O R
--------------------------------------------------------------------------------


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
    Palette.defaultPalette


{-| The offical dark theme of google.

![The dark theme](https://lh3.googleusercontent.com/tv7J2o4ZiSmLYwyBslBs_PLzKyzI8QUV5qdvHGfoAQn9r7pY4Hj5SmW27m3zUWeDtRSE8Cb5_5PQmkbavDfw7XbIL8EodIKZhilRdg=w1064-v0)

_Image take from [material.io](https://material.io/design/color/dark-theme.html#ui-application)_

-}
darkPalette : Palette
darkPalette =
    Palette.darkPalette



--------------------------------------------------------------------------------
-- B U T T O N
--------------------------------------------------------------------------------


{-| A contained button representing the most important action of a group.
-}
containedButton : Palette -> ButtonStyle msg
containedButton =
    Button.containedButton


{-| A outlined button representing an important action within a group.
-}
outlinedButton : Palette -> ButtonStyle msg
outlinedButton =
    Button.outlinedButton


{-| A text button representing a simple action within a group.
-}
textButton : Palette -> ButtonStyle msg
textButton =
    Button.textButton


{-| A ToggleButton. Only use as a group in combination with `buttonRow`.

Toggle buttons should only be used with the `iconButton` widget, else use chips instead.

Technical Remark:

  - Border color was not defined in the [specification](https://material.io/components/buttons#toggle-button)
  - There are two different versions, one where the selected color is gray and another where the color is primary.
    I noticed the gray version was used more often, so i went with that one.

-}
toggleButton : Palette -> ButtonStyle msg
toggleButton =
    Button.toggleButton


{-| An single selectable icon.

Technical Remark:

  - Could not find any specification details

-}
iconButton : Palette -> ButtonStyle msg
iconButton =
    Button.iconButton



--------------------------------------------------------------------------------
-- Switch
--------------------------------------------------------------------------------


{-| A boolean switch

Technical Remark:

  - The specification states that the disabled switch should have a color dependend on its activness. This is not implemented.

-}
switch : Palette -> SwitchStyle msg
switch =
    Switch.switch



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
chip =
    Chip.chip



{-------------------------------------------------------------------------------
-- L I S T
-------------------------------------------------------------------------------}


{-| A simple styling for a row.
-}
row : RowStyle msg
row =
    List.row


{-| A simple styling for a column.
-}
column : ColumnStyle msg
column =
    List.column


{-| A divider covering the full length
-}
fullBleedDivider : ItemStyle (DividerStyle msg)
fullBleedDivider =
    List.fullBleedDivider


{-| A divider covering only parts of the width
-}
insetDivider : Palette -> ItemStyle (DividerStyle msg)
insetDivider =
    List.insetDivider


{-| A divider in the center
-}
middleDividers : Palette -> ItemStyle (DividerStyle msg)
middleDividers =
    List.middleDividers


{-| A title of a section of a list. Comes with a inset divider.
-}
insetTitle : Palette -> ItemStyle (TitleStyle msg)
insetTitle =
    List.insetTitle


{-| A title of a section of a list. Comes with a full bleed divider.
-}
fullBleedTitle : Palette -> ItemStyle (TitleStyle msg)
fullBleedTitle =
    List.fullBleedTitle


{-| a Row of buttons.

Only use in combination with `toggleButton`

-}
buttonRow : RowStyle msg
buttonRow =
    List.buttonRow


{-| A List styled like a card.

Technical Remark:

This is a simplification of the [Material Design Card
](https://material.io/components/cards) and might get replaced at a later date.

-}
cardColumn : Palette -> ColumnStyle msg
cardColumn =
    List.cardColumn



{-------------------------------------------------------------------------------
-- D I A L O G
-------------------------------------------------------------------------------}


{-| An alert dialog for important decisions. Use a snackbar for less important notification.
-}
alertDialog : Palette -> DialogStyle msg
alertDialog =
    Dialog.alertDialog



{-------------------------------------------------------------------------------
-- E X P A N S I O N   P A N E L
-------------------------------------------------------------------------------}


{-| The expansion Panel is an outdated part of the material design specification.
In modern implementation it gets replaced with a very sophisticated list widget.

Technical Remarks:

  - The expansion panel is part of an [older version](https://material.io/archive/guidelines/components/expansion-panels.html) of the Material Design.
    The newer version is part of the List component.
    The styling is taken from the [new specification](https://material.io/components/lists#specs).
  - The Icons are taken from [danmarcab/material-icons](https://dark.elm.dmy.fr/packages/danmarcab/material-icons/latest/).

-}
expansionPanel : Palette -> ExpansionPanelStyle msg
expansionPanel =
    ExpansionPanel.expansionPanel


{-| A variant on the expansion Panel optimized to be used inside a card.

This is a small workaround to allow expansion panels within cards.

-}
expansionPanelItem : Palette -> ItemStyle (ExpansionPanelStyle msg)
expansionPanelItem =
    ExpansionPanel.expansionPanelItem



{-------------------------------------------------------------------------------
-- P R O G R E S S   I N D I C A T O R
-------------------------------------------------------------------------------}


{-| A circular progress indicator
-}
progressIndicator : Palette -> ProgressIndicatorStyle msg
progressIndicator =
    ProgressIndicator.progressIndicator



{-------------------------------------------------------------------------------
-- S N A C K B A R
-------------------------------------------------------------------------------}


{-| A typical snackbar

Technical Remark:

  - The text color of the button was not given in the specification. This implementation
    adujsts the luminance of the color to fit the [w3 accessability standard](https://www.w3.org/TR/WCAG20/#Contrast)

-}
snackbar : Palette -> SnackbarStyle msg
snackbar =
    Snackbar.snackbar



{-------------------------------------------------------------------------------
-- T E X T   I N P U T
-------------------------------------------------------------------------------}


{-| A text input style that is included only to support input chips.

Technical Remark:

  - This is just a temporary implementation. It will soon be replaced with the official implementation.

-}
textInput : Palette -> TextInputStyle msg
textInput =
    TextInput.textInput



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
tabButton =
    Tab.tabButton


{-| A Tab bar meant for only the upper most level. Do not use a tab within a tab.
-}
tab : Palette -> TabStyle msg
tab =
    Tab.tab



{-------------------------------------------------------------------------------
-- L A Y O U T
-------------------------------------------------------------------------------}


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
layout =
    Layout.layout
