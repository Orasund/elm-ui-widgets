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
        )


type alias Style msg =
    Widget.Style.Style
        { dialog : DialogStyle msg
        , expansionPanel : ExpansionPanelStyle msg
        , button : ButtonStyle msg
        , primaryButton : ButtonStyle msg
        , tab : TabStyle msg
        , textInput : TextInputStyle msg
        , chipButton : ButtonStyle msg
        , row : RowStyle msg
        , column : ColumnStyle msg
        , cardColumn : ColumnStyle msg
        , sortTable : SortTableStyle msg
        }
        msg
