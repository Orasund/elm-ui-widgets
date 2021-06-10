module Widget.Material exposing
    ( Palette, defaultPalette, darkPalette, gray, lightGray, textGray
    , containedButton, outlinedButton, textButton
    , iconButton, toggleButton, toggleRow
    , switch
    , cardColumn
    , chip, textInput, passwordInput
    , alertDialog
    , row, column
    , menuBar, tabBar
    , sideSheet, bottomSheet
    , fullBleedItem, insetItem, multiLineItem, imageItem, expansionItem, selectItem
    , fullBleedDivider, insetDivider, middleDivider
    , fullBleedHeader, insetHeader
    , progressIndicator
    , sortTable
    , snackbar
    , tab, tabButton
    , buttonRow
    )

{-| This module implements a Material design theme for all widgets.

The stylings are following [the official Material Design guidelines](https://material.io/components) as close as possible.
Please use these widgets in combination with the official guidelines.

The typograpahy is taken from [the Material Design guidelines](https://material.io/design/typography/the-type-system.html#type-scale).
Its recommended to use a font size of 16px width and the [Roboto Font](https://fonts.google.com/specimen/Roboto?query=Ro).

The style are not opaque, so you can change every styling to your needs.

If you have any suggestions or improvements, be sure to leave a [PR or a Issue](https://github.com/Orasund/elm-ui-widgets/issues) over at the github repos.


# Palette

@docs Palette, defaultPalette, darkPalette, gray, lightGray, textGray


# Button

Different styles for buttons have different meanings.

  - Use `textButton` as your default button
  - Use `containedButton` for any important action
  - Use `outlinedButton` if you have more then one important action.
    Use `containedButton` for **the most** important action of the group.

@docs containedButton, outlinedButton, textButton
@docs iconButton, toggleButton, toggleRow


# Switch

@docs switch


# Card

In the material design specification the card is not really specified at all.
Im practice the List seams more useful then a own card widget.
Thus for now we only provide a card containing a list.

@docs cardColumn


# Chip

@docs chip, textInput, passwordInput


# Dialog

@docs alertDialog


# List

@docs row, column


# App Bar

@docs menuBar, tabBar


# Sheet

@docs sideSheet, bottomSheet


# Item

A List is build from items.
You way want to use special items to visually organize the content of your list.

@docs fullBleedItem, insetItem, multiLineItem, imageItem, expansionItem, selectItem
@docs fullBleedDivider, insetDivider, middleDivider
@docs fullBleedHeader, insetHeader


# Progress Indicator

@docs progressIndicator


# Sort Table

@docs sortTable


# Snackbar

@docs snackbar


# Tab

@docs tab, tabButton


# DEPRECATED

@docs buttonRow

-}

import Color exposing (Color)
import Element exposing (Attribute)
import Internal.AppBar exposing (AppBarStyle)
import Internal.Button exposing (ButtonStyle)
import Internal.Dialog exposing (DialogStyle)
import Internal.Item
    exposing
        ( DividerStyle
        , ExpansionItemStyle
        , FullBleedItemStyle
        , HeaderStyle
        , ImageItemStyle
        , InsetItemStyle
        , ItemStyle
        , MultiLineItemStyle
        )
import Internal.List exposing (ColumnStyle, RowStyle)
import Internal.Material.AppBar as AppBar
import Internal.Material.Button as Button
import Internal.Material.Chip as Chip
import Internal.Material.Dialog as Dialog
import Internal.Material.Item as Item
import Internal.Material.List as List
import Internal.Material.Palette as Palette
import Internal.Material.PasswordInput as PasswordInput
import Internal.Material.ProgressIndicator as ProgressIndicator
import Internal.Material.Snackbar as Snackbar
import Internal.Material.SortTable as SortTable
import Internal.Material.Switch as Switch
import Internal.Material.Tab as Tab
import Internal.Material.TextInput as TextInput
import Internal.PasswordInput exposing (PasswordInputStyle)
import Internal.ProgressIndicator exposing (ProgressIndicatorStyle)
import Internal.SortTable exposing (SortTableStyle)
import Internal.Switch exposing (SwitchStyle)
import Internal.Tab exposing (TabStyle)
import Internal.TextInput exposing (TextInputStyle)
import Widget.Icon exposing (Icon)
import Widget.Snackbar exposing (SnackbarStyle)



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


{-| generates a "grayish 50%" color that matches the on-surface color.
-}
gray : Palette -> Color
gray =
    Palette.gray


{-| generates a "grayish 14%" color that matches the on-surface color.
-}
lightGray : Palette -> Color
lightGray =
    Palette.lightGray


{-| generates a grayer text color
-}
textGray : Palette -> Color
textGray =
    Palette.textGray



--------------------------------------------------------------------------------
-- B U T T O N
--------------------------------------------------------------------------------


{-| A contained button representing the most important action of a group.

![containedButton](https://orasund.github.io/elm-ui-widgets/assets/material/containedButton.png)

-}
containedButton : Palette -> ButtonStyle msg
containedButton =
    Button.containedButton


{-| A outlined button representing an important action within a group.

![outlinedButton](https://orasund.github.io/elm-ui-widgets/assets/material/outlinedButton.png)

-}
outlinedButton : Palette -> ButtonStyle msg
outlinedButton =
    Button.outlinedButton


{-| A text button representing a simple action within a group.

![textButton](https://orasund.github.io/elm-ui-widgets/assets/material/textButton.png)

-}
textButton : Palette -> ButtonStyle msg
textButton =
    Button.textButton


{-| A ToggleButton. Only use as a group in combination with `buttonRow`.

Toggle buttons should only be used with the `iconButton` widget, else use chips instead.

![toggleButton](https://orasund.github.io/elm-ui-widgets/assets/material/toggleButton.png)

Technical Remark:

  - Border color was not defined in the [specification](https://material.io/components/buttons#toggle-button)
  - There are two different versions, one where the selected color is gray and another where the color is primary.
    I noticed the gray version was used more often, so i went with that one.

-}
toggleButton : Palette -> ButtonStyle msg
toggleButton =
    Button.toggleButton


{-| An single selectable icon.

![iconButton](https://orasund.github.io/elm-ui-widgets/assets/material/iconButton.png)

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

![switch](https://orasund.github.io/elm-ui-widgets/assets/material/switch.png)

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

![chip](https://orasund.github.io/elm-ui-widgets/assets/material/chip.png)

Technical Remark:

  - Desided against the implementation of an outlined chip.
    Please open a new issue or a PR if you want to have it implemented.

-}
chip : Palette -> ButtonStyle msg
chip =
    Chip.chip



--------------------------------------------------------------------------------
-- APP BAR
--------------------------------------------------------------------------------


{-| An app bar with a menu on the left side

![menuBar](https://orasund.github.io/elm-ui-widgets/assets/material/menuBar.png)

-}
menuBar :
    Palette
    ->
        AppBarStyle
            { menuIcon : Icon msg
            , title : List (Attribute msg)
            }
            msg
menuBar =
    AppBar.menuBar


{-| An app bar with tabs instead of a menu

![tabBar](https://orasund.github.io/elm-ui-widgets/assets/material/tabBar.png)

-}
tabBar :
    Palette
    ->
        AppBarStyle
            { menuTabButton : ButtonStyle msg
            , title : List (Attribute msg)
            }
            msg
tabBar =
    AppBar.tabBar



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


{-| A side sheet. Has a maximal width of 360.

![sideSheet](https://orasund.github.io/elm-ui-widgets/assets/material/sideSheet.png)

-}
sideSheet : Palette -> ColumnStyle msg
sideSheet =
    List.sideSheet


{-| A bottom sheet. Has a maximal width of 360.
Should be align to the bottom right corner of the screen.
-}
bottomSheet : Palette -> ColumnStyle msg
bottomSheet =
    List.bottomSheet



--------------------------------------------------------------------------------
-- ITEM
--------------------------------------------------------------------------------


{-| A divider covering the full length

![fullBleedDivider](https://orasund.github.io/elm-ui-widgets/assets/material/fullBleedDivider.png)

-}
fullBleedDivider : Palette -> ItemStyle (DividerStyle msg) msg
fullBleedDivider =
    Item.fullBleedDivider


{-| A divider covering only parts of the width

![insetDivider](https://orasund.github.io/elm-ui-widgets/assets/material/insetDivider.png)

-}
insetDivider : Palette -> ItemStyle (DividerStyle msg) msg
insetDivider =
    Item.insetDivider


{-| A divider in the center

![middleDivider](https://orasund.github.io/elm-ui-widgets/assets/material/middleDivider.png)

-}
middleDivider : Palette -> ItemStyle (DividerStyle msg) msg
middleDivider =
    Item.middleDivider


{-| A header of a section of a list. Comes with a inset divider.

![insetHeader](https://orasund.github.io/elm-ui-widgets/assets/material/insetHeader.png)

-}
insetHeader : Palette -> ItemStyle (HeaderStyle msg) msg
insetHeader =
    Item.insetHeader


{-| A header of a section of a list. Comes with a full bleed divider.

![fullBleedHeader](https://orasund.github.io/elm-ui-widgets/assets/material/fullBleedHeader.png)

-}
fullBleedHeader : Palette -> ItemStyle (HeaderStyle msg) msg
fullBleedHeader =
    Item.fullBleedHeader


{-| An expandable item.

![expansionItem](https://orasund.github.io/elm-ui-widgets/assets/material/expansionItem.png)

Technical Remarks:

  - The Icons are taken from [danmarcab/material-icons](https://dark.elm.dmy.fr/packages/danmarcab/material-icons/latest/).

-}
expansionItem : Palette -> ExpansionItemStyle msg
expansionItem =
    Item.expansionItem


{-| DEPRECATED

Use Material.toggleRow instead

-}
buttonRow : RowStyle msg
buttonRow =
    List.toggleRow


{-| a Row of buttons.

Only use in combination with `toggleButton`

![buttonRow](https://orasund.github.io/elm-ui-widgets/assets/material/buttonRow.png)

-}
toggleRow : RowStyle msg
toggleRow =
    List.toggleRow


{-| A List styled like a card.

![cardColumn](https://orasund.github.io/elm-ui-widgets/assets/material/cardColumn.png)

Technical Remark:

This is a simplification of the [Material Design Card
](https://material.io/components/cards) and might get replaced at a later date.

-}
cardColumn : Palette -> ColumnStyle msg
cardColumn =
    List.cardColumn


{-| A basic item containg some text, a button. Spans the full width.

![fullBleedItem](https://orasund.github.io/elm-ui-widgets/assets/material/fullBleedItem.png)

-}
fullBleedItem : Palette -> ItemStyle (FullBleedItemStyle msg) msg
fullBleedItem =
    Item.fullBleedItem


{-| A basic item containg some text, a button and some additional information.

![insetItem](https://orasund.github.io/elm-ui-widgets/assets/material/insetItem.png)

-}
insetItem : Palette -> ItemStyle (InsetItemStyle msg) msg
insetItem =
    Item.insetItem


{-| A text item allowing for more text.

![multiLineItem](https://orasund.github.io/elm-ui-widgets/assets/material/multiLineItem.png)

-}
multiLineItem : Palette -> ItemStyle (MultiLineItemStyle msg) msg
multiLineItem =
    Item.multiLineItem


{-| Similar to a textItem but with an image instead of the icon.

If the image is bigger then 40x40, the size of the item will change.

![imageItem](https://orasund.github.io/elm-ui-widgets/assets/material/imageItem.png)

-}
imageItem : Palette -> ItemStyle (ImageItemStyle msg) msg
imageItem =
    Item.imageItem


{-| Displays a selection. This should be combined with Widget.selectItem

![selectItem](https://orasund.github.io/elm-ui-widgets/assets/material/selectItem.png)

-}
selectItem : Palette -> ItemStyle (ButtonStyle msg) msg
selectItem =
    Item.selectItem



{-------------------------------------------------------------------------------
-- D I A L O G
-------------------------------------------------------------------------------}


{-| An alert dialog for important decisions. Use a snackbar for less important notification.

![alertDialog](https://orasund.github.io/elm-ui-widgets/assets/material/alertDialog.png)

-}
alertDialog : Palette -> DialogStyle msg
alertDialog =
    Dialog.alertDialog



{-------------------------------------------------------------------------------
-- P R O G R E S S   I N D I C A T O R
-------------------------------------------------------------------------------}


{-| A circular progress indicator

![progressIndicator](https://orasund.github.io/elm-ui-widgets/assets/material/progressIndicator.png)

-}
progressIndicator : Palette -> ProgressIndicatorStyle msg
progressIndicator =
    ProgressIndicator.progressIndicator



--------------------------------------------------------------------------------
--  SORT TABLE
--------------------------------------------------------------------------------


{-| A sortable table

![sortTable](https://orasund.github.io/elm-ui-widgets/assets/material/sortTable.png)

-}
sortTable : Palette -> SortTableStyle msg
sortTable =
    SortTable.sortTable



{-------------------------------------------------------------------------------
-- S N A C K B A R
-------------------------------------------------------------------------------}


{-| A typical snackbar

![snackbar](https://orasund.github.io/elm-ui-widgets/assets/material/snackbar.png)

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

![textInput](https://orasund.github.io/elm-ui-widgets/assets/material/textInput.png)

Technical Remark:

  - This is just a temporary implementation. It will soon be replaced with the official implementation.

-}
textInput : Palette -> TextInputStyle msg
textInput =
    TextInput.textInput


{-| A text input style for the password Input.
-}
passwordInput : Palette -> PasswordInputStyle msg
passwordInput =
    PasswordInput.passwordInput



{-------------------------------------------------------------------------------
-- T A B
-------------------------------------------------------------------------------}


{-| A single Tab button.

![tabButton](https://orasund.github.io/elm-ui-widgets/assets/material/tabButton.png)

Technical Remark:

  - The official specification states that the background color should be the surface color,
    but the pictures and actuall implementations all have no background color.
    So here the background color is also not set.

-}
tabButton : Palette -> ButtonStyle msg
tabButton =
    Tab.tabButton


{-| A Tab bar meant for only the upper most level. Do not use a tab within a tab.

![tab](https://orasund.github.io/elm-ui-widgets/assets/material/tab.png)

-}
tab : Palette -> TabStyle msg
tab =
    Tab.tab
