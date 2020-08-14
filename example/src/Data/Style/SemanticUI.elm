module Data.Style.SemanticUI exposing (style)

import Data.Style exposing (Style)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html
import Html.Attributes as Attributes
import Widget.Style exposing (ButtonStyle, ColumnStyle, LayoutStyle, RowStyle)
import Widget.Style.Template as Template


button : ButtonStyle msg
button =
    { container =
        [ Attributes.class "ui basic button" |> Element.htmlAttribute
        ]
    , labelRow = [ Element.spacing 6 ]
    , text = []
    , ifDisabled =
        [ Attributes.class "disabled" |> Element.htmlAttribute
        ]
    , ifActive =
        [ Attributes.class "active" |> Element.htmlAttribute
        ]
    , otherwise = []
    }


selectButton : ButtonStyle msg
selectButton =
    { container =
        [ Attributes.class "ui  button" |> Element.htmlAttribute
        ]
    , labelRow = [ Element.spacing 6 ]
    , text = []
    , ifDisabled =
        [ Attributes.class "disabled" |> Element.htmlAttribute
        ]
    , ifActive =
        [ Attributes.class "active" |> Element.htmlAttribute
        ]
    , otherwise = []
    }


primaryButton : ButtonStyle msg
primaryButton =
    { container =
        [ Attributes.class "ui primary button" |> Element.htmlAttribute
        ]
    , labelRow = [ Element.spacing 6 ]
    , text = []
    , ifDisabled =
        [ Attributes.class "disabled" |> Element.htmlAttribute
        ]
    , ifActive =
        [ Attributes.class "active" |> Element.htmlAttribute
        ]
    , otherwise = []
    }


row : RowStyle msg
row =
    { containerRow = [ Element.spacing 4 ]
    , element = []
    , ifFirst = []
    , ifLast = []
    , otherwise = []
    }


buttonRow : RowStyle msg
buttonRow =
    { containerRow =
        [ Attributes.class "ui buttons" |> Element.htmlAttribute
        ]
    , element = []
    , ifFirst = []
    , ifLast = []
    , otherwise = []
    }


cardColumn : ColumnStyle msg
cardColumn =
    { containerColumn =
        [ Attributes.class "ui card" |> Element.htmlAttribute
        ]
    , element =
        [ Attributes.class "content" |> Element.htmlAttribute
        ]
    , ifFirst = []
    , ifLast = [ Attributes.class "extra" |> Element.htmlAttribute ]
    , otherwise = [ Attributes.class "extra" |> Element.htmlAttribute ]
    }


layout : LayoutStyle msg
layout =
    { container = []
    , snackbar = Template.snackbar <| ":snackbar"
    , layout = Element.layout
    , header = []
    , sheet = []
    , sheetButton = Template.button <| ":sheetButton"
    , menuButton = Template.button <| ":menuButton"
    , menuTabButton = Template.button <| ":menuTabButton"
    , menuIcon = Template.icon <| "menuIcon"
    , moreVerticalIcon = Template.icon <| "moreVerticalIcon"
    , spacing = 4
    , title = []
    , searchIcon = Template.icon <| "searchIcon"
    , search = []
    , searchFill = []
    }


style : Style msg
style =
    { sortTable = Template.sortTable <| "sortTable"
    , row = row
    , buttonRow = buttonRow
    , cardColumn = cardColumn
    , column = Template.column <| "column"
    , button = button
    , primaryButton = primaryButton
    , tab = Template.tab <| "tab"
    , textInput = Template.textInput <| "textInput"
    , chipButton = Template.button <| "chipButton"
    , expansionPanel = Template.expansionPanel "expansionPanel"
    , selectButton = selectButton
    , dialog = Template.dialog "dialog"
    , progressIndicator = Template.progressIndicator "progressIndicator"
    , layout = Template.layout "layout"
    }
