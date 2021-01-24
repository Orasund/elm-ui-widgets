module Data.Style exposing (Style,style)

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
import Widget.Icon as Icon
import Widget
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , ExpansionPanelStyle
        , RowStyle
        , SortTableStyle
        , TabStyle
        , TextInputStyle
        , ButtonStyle
        , ColumnStyle
        , DialogStyle
        , DividerStyle
        , ExpansionPanelStyle
        , ItemStyle
        , ProgressIndicatorStyle
        , RowStyle
        , SortTableStyle
        , SwitchStyle
        , TabStyle
        , TextInputStyle
        , HeaderStyle
        )
import Widget.Snackbar exposing (SnackbarStyle)
import Widget.Layout exposing (LayoutStyle)
import Widget.Style.Material as Material exposing (Palette)


style : Palette -> Style msg
style palette =
    { sortTable = Material.sortTable palette
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
    , expansionPanelItem = Material.expansionPanelItem palette
    , dialog = Material.alertDialog palette
    , progressIndicator = Material.progressIndicator palette
    , layout = Material.layout palette
    , switch = Material.switch palette
    , fullBleedDivider = Material.fullBleedDivider
    , insetDivider = Material.insetDivider palette
    , middleDividers = Material.middleDividers palette
    , insetHeader = Material.insetHeader palette
    , fullBleedHeader = Material.fullBleedHeader palette
    }





type alias Style msg =
    { dialog : DialogStyle msg
    , expansionPanel : ExpansionPanelStyle msg
    , expansionPanelItem : ItemStyle (ExpansionPanelStyle msg)
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
    , fullBleedDivider : ItemStyle (DividerStyle msg)
    , insetDivider : ItemStyle (DividerStyle msg)
    , middleDividers : ItemStyle (DividerStyle msg)
    , insetHeader : ItemStyle (HeaderStyle msg)
    , fullBleedHeader : ItemStyle (HeaderStyle msg)
    }
