module Data.Style exposing (Style, style)

import Color exposing (Color)
import Color.Accessibility as Accessibility
import Color.Convert as Convert
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FeatherIcons
import Html.Attributes as Attributes
import Icons
import Widget
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , DividerStyle
        , ExpansionItemStyle
        , HeaderStyle
        , ImageItemStyle
        , ItemStyle
        , MultiLineItemStyle
        , ProgressIndicatorStyle
        , RowStyle
        , SortTableStyle
        , SwitchStyle
        , TabStyle
        , TextInputStyle
        , TextItemStyle
        )
import Widget.Icon as Icon
import Widget.Layout exposing (LayoutStyle)
import Widget.Snackbar exposing (SnackbarStyle)
import Widget.Style.Material as Material exposing (Palette)


style : Palette -> Style msg
style palette =
    { containedButton = Material.containedButton Material.defaultPalette
    , outlinedButton = Material.outlinedButton Material.defaultPalette
    , textButton = Material.textButton Material.defaultPalette
    , iconButton = Material.iconButton Material.defaultPalette
    , sortTable = Material.sortTable palette
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
    , dialog = Material.alertDialog palette
    , progressIndicator = Material.progressIndicator palette
    , layout = Material.layout palette
    , switch = Material.switch palette
    , fullBleedDivider = Material.fullBleedDivider palette
    , insetDivider = Material.insetDivider palette
    , middleDivider = Material.middleDivider palette
    , insetHeader = Material.insetHeader palette
    , fullBleedHeader = Material.fullBleedHeader palette
    , textItem = Material.textItem palette
    , multiLineItem = Material.multiLineItem palette
    , imageItem = Material.imageItem palette
    , expansionItem = Material.expansionItem Material.defaultPalette
    }


type alias Style msg =
    { containedButton : ButtonStyle msg
    , outlinedButton : ButtonStyle msg
    , textButton : ButtonStyle msg
    , iconButton : ButtonStyle msg
    , dialog : DialogStyle msg
    , button : ButtonStyle msg
    , switch : SwitchStyle msg
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
    , insetDivider : ItemStyle (DividerStyle msg) msg
    , middleDivider : ItemStyle (DividerStyle msg) msg
    , fullBleedDivider : ItemStyle (DividerStyle msg) msg
    , insetHeader : ItemStyle (HeaderStyle msg) msg
    , fullBleedHeader : ItemStyle (HeaderStyle msg) msg
    , textItem : ItemStyle (TextItemStyle msg) msg
    , multiLineItem : ItemStyle (MultiLineItemStyle msg) msg
    , imageItem : ItemStyle (ImageItemStyle msg) msg
    , expansionItem : ExpansionItemStyle msg
    }
