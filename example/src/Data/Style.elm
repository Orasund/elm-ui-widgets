module Data.Style exposing (Style)

import Element exposing (Attribute)
import Widget.Style exposing (ButtonStyle, DialogStyle, ExpansionPanelStyle,
    SnackbarStyle ,RowStyle,ColumnStyle,TextInputStyle,TabStyle)

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
        }
        msg