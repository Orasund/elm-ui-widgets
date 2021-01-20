module Data.Style.SemanticUI exposing (style)

import Data.Style exposing (Style)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html
import Html.Attributes as Attributes
import Widget.Style exposing (ButtonStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, LayoutStyle, ProgressIndicatorStyle, RowStyle, SortTableStyle, TabStyle, TextInputStyle)
import Widget.Style.Template as Template


sortTable : SortTableStyle msg
sortTable =
    { containerTable = [ Attributes.class "ui celled table" |> Element.htmlAttribute ]
    , headerButton = button
    , ascIcon =
        Html.i [ Attributes.class "dropdown icon" ] []
            |> Element.html
    , descIcon =
        Html.i [ Attributes.class "dropdown icon" ] []
            |> Element.html
    , defaultIcon = Element.none
    }


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


chipButton : ButtonStyle msg
chipButton =
    { container =
        [ Attributes.class "ui  label" |> Element.htmlAttribute
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


column : ColumnStyle msg
column =
    { containerColumn = [ Element.spacing 4 ]
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
        [ Element.width <| Element.fill
        , Attributes.class "content" |> Element.htmlAttribute
        ]
    , ifFirst = []
    , ifLast = []
    , otherwise = []
    }


expansionPanel : ExpansionPanelStyle msg
expansionPanel =
    { containerColumn = [ Attributes.class "ui accordion" |> Element.htmlAttribute ]
    , panelRow = [ Attributes.class "title" |> Element.htmlAttribute ]
    , labelRow = []
    , content = [ Attributes.class "content active" |> Element.htmlAttribute ]
    , expandIcon =
        Html.i [ Attributes.class "dropdown icon" ] []
            |> Element.html
    , collapseIcon =
        Html.i [ Attributes.class "dropdown icon" ] []
            |> Element.html
    }


dialog : DialogStyle msg
dialog =
    { containerColumn = [ Attributes.class "ui active modal" |> Element.htmlAttribute ]
    , title = [ Attributes.class "header" |> Element.htmlAttribute ]
    , buttonRow = [ Attributes.class "actions" |> Element.htmlAttribute ]
    , acceptButton =
        { container =
            [ Attributes.class "ui positive button" |> Element.htmlAttribute
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
    , dismissButton =
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
    , text = [ Attributes.class "description" |> Element.htmlAttribute ]
    }


tab : TabStyle msg
tab =
    { button =
        { container =
            [ Attributes.class "item" |> Element.htmlAttribute
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
    , optionRow =
        [ Attributes.class "ui top attached tabular menu" |> Element.htmlAttribute
        ]
    , containerColumn = []
    , content =
        [ Attributes.class "ui bottom active attached tab segment" |> Element.htmlAttribute
        ]
    }


progressIndicator : ProgressIndicatorStyle msg
progressIndicator =
    { containerFunction =
        \maybeProgress ->
            "progressbar is not supported in Semantic UI"
                |> Element.text
                |> List.singleton
                |> Element.paragraph []
    }


textInput : TextInputStyle msg
textInput =
    { chipButton = chipButton
    , containerRow = [ Element.spacing 4 ]
    , chipsRow =
        [ Element.spacing 2
        ]
    , input = []
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


style =
    { sortTable = sortTable
    , row = row
    , buttonRow = buttonRow
    , cardColumn = cardColumn
    , column = column
    , button = button
    , primaryButton = primaryButton
    , tab = tab
    , textInput = textInput
    , chipButton = chipButton
    , expansionPanel = expansionPanel
    , selectButton = selectButton
    , dialog = dialog
    , progressIndicator = progressIndicator
    , layout = Template.layout "layout"
    , switch = button
    }
