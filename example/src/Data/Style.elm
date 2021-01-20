module Data.Style exposing (Style)

import Widget.Style
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , ExpansionPanelStyle
        , LayoutStyle
        , ProgressIndicatorStyle
        , RowStyle
        , SortTableStyle
        , TabStyle
        , TextInputStyle
        , SwitchStyle
        )


type alias Style msg =
    { dialog : DialogStyle msg
    , expansionPanel : ExpansionPanelStyle msg
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
    }
