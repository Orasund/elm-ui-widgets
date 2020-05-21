module Data.Style exposing (Style)

import Widget.Style
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , ExpansionPanelStyle
        , RowStyle
        , SortTableStyle
        , TabStyle
        , TextInputStyle
        , LayoutStyle
        )


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
        , layout : LayoutStyle msg
        }
