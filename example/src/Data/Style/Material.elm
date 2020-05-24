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
import Icons

sortTable : Palette -> SortTableStyle msg
sortTable palette =
    { containerTable = []
    , headerButton = Material.textButton palette
    , ascIcon = Icons.chevronUp |> Element.html |> Element.el []
    , descIcon = Icons.chevronDown |> Element.html |> Element.el []
    , defaultIcon = Element.none
    }

layout : Palette -> String -> LayoutStyle msg
layout palette string =
    { container = [Font.family
            [ Font.typeface "Roboto"
            , Font.sansSerif
            ]
        ,Font.size 16
    , Font.letterSpacing 0.5]
    , snackbar = Material.snackbar palette
    , layout = Element.layout
    , header = Template.box <| string ++ ":header"
    , menuButton = Template.button <| string ++ ":menuButton"
    , sheetButton = Template.button <| string ++ ":sheetButton"
    , menuTabButton = Template.button <| string ++ ":menuTabButton"
    , sheet = Template.box <| string ++ ":sheet"
    , menuIcon = Template.icon <| string ++ ":menuIcon"
    , moreVerticalIcon = Template.icon <| string ++ ":moreVerticalIcon"
    , spacing = 8
    , title = Template.box <| string ++ ":title"
    , searchIcon = Template.icon <| string ++ ":searchIcon"
    , search = Template.box <| string ++ ":search"
    , searchFill = Template.box <| string ++ ":searchFill"
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
    , tab = Template.tab <| "tab"
    , textInput = Material.textInput palette
    , chipButton = Material.chip palette
    , expansionPanel = Material.expansionPanel palette
    , dialog = Material.alertDialog palette
    , layout = layout palette "layout"
    }
