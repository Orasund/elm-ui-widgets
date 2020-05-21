module Data.Style.Material exposing (style)

import Color exposing (Color)
import Color.Accessibility as Accessibility
import Color.Convert as Convert
import Data.Style exposing (Style)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attributes
import Widget.Style
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , ExpansionPanelStyle
        , LayoutStyle
        , RowStyle
        , SnackbarStyle
        , SortTableStyle
        , TabStyle
        , TextInputStyle
        )
import Widget.Style.Material as Material exposing (Palette)
import Widget.Style.Template as Template


style : Palette -> Style msg
style palette =
    { sortTable = Template.sortTable <| "sortTable"
    , row = Material.row
    , buttonRow = Material.buttonRow
    , cardColumn = Template.column <| "cardRow"
    , column = Template.column <| "column"
    , button = Material.outlinedButton palette
    , primaryButton = Material.containedButton palette
    , selectButton = Material.toggleButton palette
    , tab = Template.tab <| "tab"
    , textInput = Template.textInput <| "textInput"
    , chipButton = Template.button <| "Button"
    , expansionPanel = Template.expansionPanel "expansionPanel"
    , dialog = Template.dialog <| "dialog"
    , layout = Template.layout "layout"
    }
