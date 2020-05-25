module Widget exposing
    ( Button, TextButton, iconButton, textButton, button
    , Select, MultiSelect, selectButton, select, multiSelect
    , Dialog, modal, dialog
    , ExpansionPanel, expansionPanel
    , row, column, buttonRow, buttonColumn
    , SortTable,Column, sortTable, floatColumn, intColumn, stringColumn, unsortableColumn
    , TextInput, textInput
    , Tab, tab
    )

{-| This module contains different stateless view functions. No wiring required.

These widgets should be used by defining the styling seperately:

```
Widget.button Material.primaryButton
    { text = "disable me"
    , icon =
        FeatherIcons.slash
            |> FeatherIcons.withSize 16
            |> FeatherIcons.toHtml []
            |> Element.html
            |> Element.el []
    , onPress =
        if isButtonEnabled then
            ChangedButtonStatus False
                |> Just

        else
            Nothing
    }
```

Every widgets comes with a type. You can think of the widgets as building blocks.
You can create you own widgets by sticking widgets types together.

# Buttons

![Button](https://orasund.github.io/elm-ui-widgets/assets/button.png)

@docs Button, TextButton, iconButton, textButton, button


# Select

![Select](https://orasund.github.io/elm-ui-widgets/assets/select.png)

@docs Select, selectButton, select

![multiSelect](https://orasund.github.io/elm-ui-widgets/assets/multiSelect.png)

@docs MultiSelect, multiSelect


# Dialog

![dialog](https://orasund.github.io/elm-ui-widgets/assets/dialog.png)

@docs Dialog, modal, dialog


# Expansion Panel

![expansionPanel](https://orasund.github.io/elm-ui-widgets/assets/expansionPanel.png)

@docs ExpansionPanel, expansionPanel


# List

![list](https://orasund.github.io/elm-ui-widgets/assets/list.png)

@docs row, column, buttonRow, buttonColumn


# Sort Table

![sortTable](https://orasund.github.io/elm-ui-widgets/assets/sortTable.png)

@docs SortTable,Column, sortTable, floatColumn, intColumn, stringColumn, unsortableColumn


# Text Input

![textInput](https://orasund.github.io/elm-ui-widgets/assets/textInput.png)

@docs TextInput, textInput


# Tab

![tab](https://orasund.github.io/elm-ui-widgets/assets/textInput.png)

@docs Tab, tab

-}

import Element exposing (Attribute, Element, Length)
import Element.Input exposing (Placeholder)
import Internal.Button as Button
import Internal.Dialog as Dialog
import Internal.ExpansionPanel as ExpansionPanel
import Internal.List as List
import Internal.Select as Select
import Internal.SortTable as SortTable
import Internal.Tab as Tab
import Internal.TextInput as TextInput
import Set exposing (Set)
import Widget.Style exposing (ButtonStyle,TextInputStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, RowStyle, SortTableStyle, TabStyle)



{----------------------------------------------------------
- BUTTON
----------------------------------------------------------}


{-| Button widget type
-}
type alias Button msg =
    { text : String
    , icon : Element Never
    , onPress : Maybe msg
    }


{-| Button widget type with no icon
-}
type alias TextButton msg =
    { text : String
    , onPress : Maybe msg
    }


{-| A button containing only an icon, the text is used for screenreaders.
-}
iconButton :
    ButtonStyle msg
    ->
        { text : String
        , icon : Element Never
        , onPress : Maybe msg
        }
    -> Element msg
iconButton =
    Button.iconButton


{-| A button with just text and not icon.
-}
textButton :
    ButtonStyle msg
    ->
        { textButton
            | text : String
            , onPress : Maybe msg
        }
    -> Element msg
textButton style { text, onPress } =
    Button.textButton style
        { text = text
        , onPress = onPress
        }


{-| A button containing a text and an icon.
-}
button :
    ButtonStyle msg
    ->
        { text : String
        , icon : Element Never
        , onPress : Maybe msg
        }
    -> Element msg
button =
    Button.button



{----------------------------------------------------------
- SELECT
----------------------------------------------------------}


{-| Select widget type

Technical Remark:

* A more suitable name would be "Choice"

-}
type alias Select msg =
    { selected : Maybe Int
    , options :
        List
            { text : String
            , icon : Element Never
            }
    , onSelect : Int -> Maybe msg
    }


{-| Multi Select widget type

Technical Remark:

* A more suitable name would be "Options"

-}
type alias MultiSelect msg =
    { selected : Set Int
    , options :
        List
            { text : String
            , icon : Element Never
            }
    , onSelect : Int -> Maybe msg
    }


{-| A simple button that can be selected.
-}
selectButton :
    ButtonStyle msg
    -> ( Bool, Button msg )
    -> Element msg
selectButton =
    Select.selectButton


{-| Selects one out of multiple options. This can be used for radio buttons or Menus.
-}
select :
    Select msg
    -> List ( Bool, Button msg )
select =
    Select.select


{-| Selects multible options. This can be used for checkboxes.
-}
multiSelect :
    MultiSelect msg
    -> List ( Bool, Button msg )
multiSelect =
    Select.multiSelect



{----------------------------------------------------------
- DIALOG
----------------------------------------------------------}


{-| Dialog widget type
-}
type alias Dialog msg =
    { title : Maybe String
    , body : Element msg
    , accept : Maybe (TextButton msg)
    , dismiss : Maybe (TextButton msg)
    }


{-| A modal.

Technical Remark:

* To stop the screen from scrolling, set the height of the layout to the height of the screen.

-}
modal : { onDismiss : Maybe msg, content : Element msg } -> List (Attribute msg)
modal =
    Dialog.modal


{-| A Dialog Window.
-}
dialog :
    DialogStyle msg
    ->
        { title : Maybe String
        , text : String
        , accept : Maybe (TextButton msg)
        , dismiss : Maybe (TextButton msg)
        }
    -> List (Attribute msg)
dialog =
    Dialog.dialog



{----------------------------------------------------------
- EXPANSION PANEL
----------------------------------------------------------}

{-| Expansion Panel widget type
-}
type alias ExpansionPanel msg =
    { onToggle : Bool -> msg
    , icon : Element Never
    , text : String
    , expandIcon : Element Never
    , collapseIcon : Element Never
    , content : Element msg
    , isExpanded : Bool
    }

{-| An expansion Panel
-}
expansionPanel :
    ExpansionPanelStyle msg
    ->
        { onToggle : Bool -> msg
        , icon : Element Never
        , text : String
        , content : Element msg
        , isExpanded : Bool
        }
    -> Element msg
expansionPanel =
    ExpansionPanel.expansionPanel



{----------------------------------------------------------
- TEXT INPUT
----------------------------------------------------------}

{-| Text Input widget type
-}
type alias TextInput msg =
    { chips : List (Button msg)
    , text : String
    , placeholder : Maybe (Placeholder msg)
    , label : String
    , onChange : String -> msg
    }

{-| A text Input that allows to include chips. -}
textInput :
    TextInputStyle msg
    ->
        { chips : List (Button msg)
        , text : String
        , placeholder : Maybe (Placeholder msg)
        , label : String
        , onChange : String -> msg
        }
    -> Element msg
textInput =
    TextInput.textInput



{----------------------------------------------------------
- LIST
----------------------------------------------------------}

{-| Replacement of `Element.row`
-}
row : RowStyle msg -> List (Element msg) -> Element msg
row =
    List.row

{-| Replacement of `Element.column`
-}
column : ColumnStyle msg -> List (Element msg) -> Element msg
column =
    List.column

{-| A row of buttons
-}
buttonRow :
    { list : RowStyle msg
    , button : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonRow =
    List.buttonRow

{-| A column of buttons
-}
buttonColumn :
    { list : ColumnStyle msg
    , button : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonColumn =
    List.buttonColumn



{----------------------------------------------------------
- SORT TABLE
----------------------------------------------------------}


{-| Column for the Sort Table widget type
-}
type alias Column a =
    SortTable.Column a

{-|  Sort Table widget type
-}
type alias SortTable a msg=
    { content : List a
    , columns : List (Column a)
    , sortBy : String
    , asc : Bool
    , onChange : String -> msg
    }

{-| An unsortable Column, when trying to sort by this column, nothing will change.
-}
unsortableColumn :
    { title : String
    , toString : a -> String
    , width : Length
    }
    -> Column a
unsortableColumn =
    SortTable.unsortableColumn


{-| A Column containing a Int
-}
intColumn :
    { title : String
    , value : a -> Int
    , toString : Int -> String
    , width : Length
    }
    -> Column a
intColumn =
    SortTable.intColumn


{-| A Column containing a Float
-}
floatColumn :
    { title : String
    , value : a -> Float
    , toString : Float -> String
    , width : Length
    }
    -> Column a
floatColumn =
    SortTable.floatColumn


{-| A Column containing a String
-}
stringColumn :
    { title : String
    , value : a -> String
    , toString : String -> String
    , width : Length
    }
    -> Column a
stringColumn =
    SortTable.stringColumn


{-| The View
-}
sortTable :
    SortTableStyle msg
    ->
        { content : List a
        , columns : List (Column a)
        , sortBy : String
        , asc : Bool
        , onChange : String -> msg
        }
    -> Element msg
sortTable =
    SortTable.sortTable



{----------------------------------------------------------
- TAB
----------------------------------------------------------}

{-| Tab widget type
-}
type alias Tab msg =
    { tabs : Select msg
    , content : Maybe Int -> Element msg
    }


{-| Displayes a list of contents in a tab
-}
tab :
    TabStyle msg
    ->
        { tabs : Select msg
        , content : Maybe Int -> Element msg
        }
    -> Element msg
tab =
    Tab.tab
