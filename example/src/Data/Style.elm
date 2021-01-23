module Data.Style exposing (Style)

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
        , SortTableStyle
        , SwitchStyle
        , TabStyle
        , TextInputStyle
        , TitleStyle
        )


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
    , insetTitle : ItemStyle (TitleStyle msg)
    , fullBleedTitle : ItemStyle (TitleStyle msg)
    }
