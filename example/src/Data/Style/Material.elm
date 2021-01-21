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
import Icons
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


sortTable : Palette -> SortTableStyle msg
sortTable palette =
    { elementTable = []
    , content =
        { header = Material.textButton palette
        , ascIcon = Icons.chevronUp |> Element.html |> Element.el []
        , descIcon = Icons.chevronDown |> Element.html |> Element.el []
        , defaultIcon = Element.none
        }
    }


style : Palette -> Style msg
style palette =
    { sortTable = sortTable palette
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
    , dialog = Material.alertDialog palette
    , progressIndicator = Material.progressIndicator palette
    , layout = Material.layout palette
    , switch = Material.switch palette
    }
