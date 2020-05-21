module Data.Style.Template exposing (style)

import Data.Style exposing (Style)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Widget.Style.Template as Template


style : Style msg
style =
    { sortTable = Template.sortTable <| "sortTable"
    , row = Template.row <| "row"
    , buttonRow = Template.row <| "buttonRow"
    , cardColumn = Template.column <| "cardRow"
    , column = Template.column <| "column"
    , button = Template.button <| "button"
    , primaryButton = Template.button <| "primaryButton"
    , tab = Template.tab <| "tab"
    , textInput = Template.textInput <| "textInput"
    , chipButton = Template.button <| "chipButton"
    , expansionPanel = Template.expansionPanel "expansionPanel"
    , selectButton = Template.button "selectButton"
    , dialog = Template.dialog "dialog"
    , layout = Template.layout "layout"
    }
