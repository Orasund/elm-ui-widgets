module Data.Style.Template exposing (style)

import Data.Style exposing (Style)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Widget.Style
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , ExpansionPanelStyle
        , RowStyle
        , SnackbarStyle
        , TabStyle
        , TextInputStyle
        ,SortTableStyle
        )


fontSize : Int
fontSize =
    10


box : String -> List (Attribute msg)
box string =
    [ Border.width 1
    , Background.color <| Element.rgba 1 1 1 0.5
    , Element.padding 10
    , Element.spacing 10
    , Element.above <|
        Element.el [ Font.size <| fontSize ] <|
            Element.text string
    ]


decoration : String -> List (Attribute msg)
decoration string =
    [ Element.below <|
        Element.el [ Font.size <| fontSize ] <|
            Element.text string
    , Background.color <| Element.rgb 0.66 0.66 0.66
    ]


icon : String -> Element msg
icon string =
    Element.none
        |> Element.el
            [ Element.width <| Element.px 12
            , Element.height <| Element.px 12
            , Border.rounded 6
            , Border.width 1
            , Element.above <|
                Element.el [ Font.size <| fontSize ] <|
                    Element.text string
            ]


button : String -> ButtonStyle msg
button string =
    { container = box <| string ++ ":container"
    , labelRow = box <| string ++ ":labelRow"
    , ifDisabled = decoration <| string ++ ":ifDisabled"
    , ifActive = decoration <| string ++ ":ifActive"
    , otherwise = decoration <| string ++ ":otherwise"
    }


snackbar : String -> SnackbarStyle msg
snackbar string =
    { containerRow = box <| string ++ ":containerRow"
    , button = button <| string ++ ":button"
    , text = box <| string ++ ":text"
    }


dialog : String -> DialogStyle msg
dialog string =
    { containerColumn = box <| string ++ ":containerColumn"
    , title = box <| string ++ ":title"
    , buttonRow = box <| string ++ ":buttonRow"
    , acceptButton = button <| string ++ ":acceptButton"
    , dismissButton = button <| string ++ ":dismissButton"
    }


expansionPanel : String -> ExpansionPanelStyle msg
expansionPanel string =
    { containerColumn = box <| string ++ ":containerColumn"
    , panelRow = box <| string ++ ":panelRow"
    , labelRow = box <| string ++ ":labelRow"
    , content = box <| string ++ ":content"
    , expandIcon = icon <| string ++ ":expandIcon"
    , collapseIcon = icon <| string ++ ":collapseIcon"
    }


textInput : String -> TextInputStyle msg
textInput string =
    { chipButton = button <| string ++ ":chipButton"
    , chipsRow = box <| string ++ ":chipsRow"
    , containerRow = box <| string ++ ":containerRow"
    , input = box <| string ++ ":input"
    }


tab : String -> TabStyle msg
tab string =
    { button = button <| string ++ ":button"
    , optionRow = box <| string ++ ":optionRow"
    , containerColumn = box <| string ++ ":containerColumn"
    , content = box <| string ++ ":content"
    }


row : String -> RowStyle msg
row string =
    { containerRow = box <| string ++ ":containerRow"
    , element = box <| string ++ ":element"
    , ifFirst = box <| string ++ ":ifFirst"
    , ifLast = box <| string ++ ":ifLast"
    , otherwise = box <| string ++ ":otherwise"
    }


column : String -> ColumnStyle msg
column string =
    { containerColumn = box <| string ++ ":containerColumn"
    , element = box <| string ++ ":element"
    , ifFirst = box <| string ++ ":ifFirst"
    , ifLast = box <| string ++ ":ifLast"
    , otherwise = box <| string ++ ":otherwise"
    }


sortTable : String -> SortTableStyle msg
sortTable string =
    { containerTable = box <| string ++ ":containerTable"
    , headerButton = button <| string ++ ":headerButton"
    , ascIcon = icon <| string ++ ":ascIcon"
    , descIcon = icon <| string ++ ":descIcon"
    , defaultIcon = icon <| string ++ ":defaultIcon"
    }


style : Style msg
style =
    { sortTable = sortTable <| "sortTable"
    , row = row <| "row"
    , cardColumn = column <| "cardRow"
    , column = column <| "column"
    , button = button <| "button"
    , primaryButton = button <| "primaryButton"
    , tab = tab <| "tab"
    , textInput = textInput <| "textInput"
    , chipButton = button <| "chipButton"
    , expansionPanel = expansionPanel "expansionPanel"
    , dialog = dialog "dialog"
    , snackbar = snackbar "snackbar"
    , layout = Element.layout
    , header = box "header"
    , menuButton = button "menuButton"
    , sheetButton = button "sheetButton"
    , menuTabButton = button "menuTabButton"
    , sheet = box "sheet"
    , menuIcon = icon "menuIcon"
    , moreVerticalIcon = icon "moreVerticalIcon"
    , spacing = 8
    , title = box "title"
    , searchIcon = icon "searchIcon"
    , search = box "search"
    , searchFill = box "searchFill"
    }
