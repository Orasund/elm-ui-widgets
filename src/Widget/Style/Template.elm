module Widget.Style.Template exposing (box, button, column, decoration, dialog, expansionPanel, icon, layout, row, snackbar, sortTable, tab, textInput)

{-| This package
-}

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
        , LayoutStyle
        , RowStyle
        , SnackbarStyle
        , SortTableStyle
        , TabStyle
        , TextInputStyle
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
    , text = box <| string ++ ":text"
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
    , text = box <| string ++ ":text"
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


layout : String -> LayoutStyle msg
layout string =
    { container = box <| string ++ ":container"
    , snackbar = snackbar <| string ++ ":snackbar"
    , layout = Element.layout
    , header = box <| string ++ ":header"
    , menuButton = button <| string ++ ":menuButton"
    , sheetButton = button <| string ++ ":sheetButton"
    , menuTabButton = button <| string ++ ":menuTabButton"
    , sheet = box <| string ++ ":sheet"
    , menuIcon = icon <| string ++ ":menuIcon"
    , moreVerticalIcon = icon <| string ++ ":moreVerticalIcon"
    , spacing = 8
    , title = box <| string ++ ":title"
    , searchIcon = icon <| string ++ ":searchIcon"
    , search = box <| string ++ ":search"
    , searchFill = box <| string ++ ":searchFill"
    }
