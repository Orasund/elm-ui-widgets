module Widget.Style.Template exposing
    ( box, decoration, icon
    , button, switch, column, dialog, expansionPanel, layout, row, snackbar, sortTable, tab, textInput, progressIndicator
    )

{-| ![Example using the Template style](https://orasund.github.io/elm-ui-widgets/assets/template-style.png)

This package contains mockups designed for writing your own style.

Start by copying the following code and then replace the fields one by one.

```
type alias Style msg =
    { dialog : DialogStyle msg
    , expansionPanel : ExpansionPanelStyle msg
    , button : ButtonStyle msg
    , primaryButton : ButtonStyle msg
    , tab : TabStyle msg
    , textInput : TextInputStyle msg
    , chipButton : ButtonStyle msg
    , row : RowStyle msg
    , buttonRow : RowStyle msg
    , column : ColumnStyle msg
    , cardColumn : ColumnStyle msg
    , sortTable : SortTableStyle msg
    , selectButton : ButtonStyle msg
    , layout : LayoutStyle msg
    }

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
```


# Base Elements

@docs box, decoration, icon


# Mockups

@docs button, switch, column, dialog, expansionPanel, layout, row, snackbar, sortTable, tab, textInput, progressIndicator

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
        , ProgressIndicatorStyle
        , RowStyle
        , SnackbarStyle
        , SortTableStyle
        , TabStyle
        , TextInputStyle
        , SwitchStyle
        )


fontSize : Int
fontSize =
    10


{-| A box representing an element
-}
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


{-| An additional attribute representing a state change.
-}
decoration : String -> List (Attribute msg)
decoration string =
    [ Element.below <|
        Element.el [ Font.size <| fontSize ] <|
            Element.text string
    , Background.color <| Element.rgb 0.66 0.66 0.66
    ]


{-| A circle representing an icon
-}
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

{-| A boolean switch
-}
switch : String -> SwitchStyle msg
switch string =
    { containerButton = box <| string ++ ":containerButton"
    , content =
        { container = box <| string ++ ":content:container"
        , ifDisabled = decoration <| string ++ ":content:ifDisabled"
        , ifActive = decoration <| string ++ ":content:ifActive"
        , otherwise = decoration <| string ++ ":content:otherwise"
        }
    , contentInFront =
        { container = box <| string ++ ":contentInFront:container"
        , ifDisabled = decoration <| string ++ ":contentInFront:ifDisabled"
        , ifActive = decoration <| string ++ ":contentInFront:ifActive"
        , otherwise = decoration <| string ++ ":contentInFront:otherwise"
        , content =
            { container = box <| string ++ ":contentInFront:content:container"
            , ifDisabled = decoration <| string ++ ":contentInFront:content:ifDisabled"
            , ifActive = decoration <| string ++ ":contentInFront:content:ifActive"
            , otherwise = decoration <| string ++ ":contentInFront:content:otherwise"
            }
        }
    }

{-|

```
button : String -> ButtonStyle msg
button string =
    { container = box <| string ++ ":container"
    , labelRow = box <| string ++ ":labelRow"
    , text = box <| string ++ ":text"
    , ifDisabled = decoration <| string ++ ":ifDisabled"
    , ifActive = decoration <| string ++ ":ifActive"
    , otherwise = decoration <| string ++ ":otherwise"
    }
```

-}
button : String -> ButtonStyle msg
button string =
    { container = box <| string ++ ":container"
    , labelRow = box <| string ++ ":labelRow"
    , text = box <| string ++ ":text"
    , ifDisabled = decoration <| string ++ ":ifDisabled"
    , ifActive = decoration <| string ++ ":ifActive"
    , otherwise = decoration <| string ++ ":otherwise"
    }


{-|

```
snackbar : String -> SnackbarStyle msg
snackbar string =
    { containerRow = box <| string ++ ":containerRow"
    , button = button <| string ++ ":button"
    , text = box <| string ++ ":text"
    }
```

-}
snackbar : String -> SnackbarStyle msg
snackbar string =
    { containerRow = box <| string ++ ":containerRow"
    , button = button <| string ++ ":button"
    , text = box <| string ++ ":text"
    }


{-|

```
dialog : String -> DialogStyle msg
dialog string =
    { containerColumn = box <| string ++ ":containerColumn"
    , title = box <| string ++ ":title"
    , text = box <| string ++ ":text"
    , buttonRow = box <| string ++ ":buttonRow"
    , acceptButton = button <| string ++ ":acceptButton"
    , dismissButton = button <| string ++ ":dismissButton"
    }
```

-}
dialog : String -> DialogStyle msg
dialog string =
    { containerColumn = box <| string ++ ":containerColumn"
    , title = box <| string ++ ":title"
    , text = box <| string ++ ":text"
    , buttonRow = box <| string ++ ":buttonRow"
    , acceptButton = button <| string ++ ":acceptButton"
    , dismissButton = button <| string ++ ":dismissButton"
    }


{-|

```
expansionPanel : String -> ExpansionPanelStyle msg
expansionPanel string =
    { containerColumn = box <| string ++ ":containerColumn"
    , panelRow = box <| string ++ ":panelRow"
    , labelRow = box <| string ++ ":labelRow"
    , content = box <| string ++ ":content"
    , expandIcon = icon <| string ++ ":expandIcon"
    , collapseIcon = icon <| string ++ ":collapseIcon"
    }

```

-}
expansionPanel : String -> ExpansionPanelStyle msg
expansionPanel string =
    { containerColumn = box <| string ++ ":containerColumn"
    , panelRow = box <| string ++ ":panelRow"
    , labelRow = box <| string ++ ":labelRow"
    , content = box <| string ++ ":content"
    , expandIcon = icon <| string ++ ":expandIcon"
    , collapseIcon = icon <| string ++ ":collapseIcon"
    }


{-|

```
textInput : String -> TextInputStyle msg
textInput string =
    { chipButton = button <| string ++ ":chipButton"
    , chipsRow = box <| string ++ ":chipsRow"
    , containerRow = box <| string ++ ":containerRow"
    , input = box <| string ++ ":input"
    }

```

-}
textInput : String -> TextInputStyle msg
textInput string =
    { chipButton = button <| string ++ ":chipButton"
    , chipsRow = box <| string ++ ":chipsRow"
    , containerRow = box <| string ++ ":containerRow"
    , input = box <| string ++ ":input"
    }


{-|

```
tab : String -> TabStyle msg
tab string =
    { button = button <| string ++ ":button"
    , optionRow = box <| string ++ ":optionRow"
    , containerColumn = box <| string ++ ":containerColumn"
    , content = box <| string ++ ":content"
    }
```

-}
tab : String -> TabStyle msg
tab string =
    { button = button <| string ++ ":button"
    , optionRow = box <| string ++ ":optionRow"
    , containerColumn = box <| string ++ ":containerColumn"
    , content = box <| string ++ ":content"
    }


{-|

```
row : String -> RowStyle msg
row string =
    { containerRow = box <| string ++ ":containerRow"
    , element = box <| string ++ ":element"
    , ifFirst = decoration <| string ++ ":ifFirst"
    , ifLast = decoration <| string ++ ":ifLast"
    , otherwise = decoration <| string ++ ":otherwise"
    }
```

-}
row : String -> RowStyle msg
row string =
    { containerRow = box <| string ++ ":containerRow"
    , element = box <| string ++ ":element"
    , ifFirst = decoration <| string ++ ":ifFirst"
    , ifLast = decoration <| string ++ ":ifLast"
    , otherwise = decoration <| string ++ ":otherwise"
    }


{-|

```
column : String -> ColumnStyle msg
column string =
    { containerColumn = box <| string ++ ":containerColumn"
    , element = box <| string ++ ":element"
    , ifFirst = decoration <| string ++ ":ifFirst"
    , ifLast = decoration <| string ++ ":ifLast"
    , otherwise = decoration <| string ++ ":otherwise"
    }
```

-}
column : String -> ColumnStyle msg
column string =
    { containerColumn = box <| string ++ ":containerColumn"
    , element = box <| string ++ ":element"
    , ifFirst = decoration <| string ++ ":ifFirst"
    , ifLast = decoration <| string ++ ":ifLast"
    , otherwise = decoration <| string ++ ":otherwise"
    }


{-|

```
sortTable : String -> SortTableStyle msg
sortTable string =
    { containerTable = box <| string ++ ":containerTable"
    , headerButton = button <| string ++ ":headerButton"
    , ascIcon = icon <| string ++ ":ascIcon"
    , descIcon = icon <| string ++ ":descIcon"
    , defaultIcon = icon <| string ++ ":defaultIcon"
    }
```

-}
sortTable : String -> SortTableStyle msg
sortTable string =
    { containerTable = box <| string ++ ":containerTable"
    , headerButton = button <| string ++ ":headerButton"
    , ascIcon = icon <| string ++ ":ascIcon"
    , descIcon = icon <| string ++ ":descIcon"
    , defaultIcon = icon <| string ++ ":defaultIcon"
    }


{-|

```
progressIndicator : String -> ProgressIndicatorStyle msg
progressIndicator string =
    { icon = (\_ -> icon <| string ++ ":icon")
    }
```

-}
progressIndicator : String -> ProgressIndicatorStyle msg
progressIndicator string =
    { containerFunction = \_ -> icon <| string ++ ":icon"
    }


{-|

```
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
```

-}
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
