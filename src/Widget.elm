module Widget exposing
    ( Button, TextButton, iconButton, textButton, button
    , Select, MultiSelect, selectButton, select, multiSelect
    , Dialog, modal, dialog
    , ExpansionPanel, expansionPanel
    , row, column, buttonRow, buttonColumn
    , ColumnType, sortTable, floatColumn, intColumn, stringColumn, unsortableColumn
    , TextInputStyle, textInput
    , Tab, tab
    )

{-| This module contains functions for displaying data.


# Buttons

@docs Button, TextButton, iconButton, textButton, button


# Select

@docs Select, MultiSelect, selectButton, select, multiSelect


# Dialog

@docs Dialog, modal, dialog


# Expansion Panel

@docs ExpansionPanel, expansionPanel


# List

@docs row, column, buttonRow, buttonColumn


# Sort Table

@docs ColumnType, sortTable, floatColumn, intColumn, stringColumn, unsortableColumn


# Text Input

@docs TextInputStyle, textInput


# Tab

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
import Widget.Style exposing (ButtonStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, RowStyle, SortTableStyle, TabStyle)



{----------------------------------------------------------
- BUTTON
----------------------------------------------------------}


{-| A Button as a type
-}
type alias Button msg =
    { text : String
    , icon : Element Never
    , onPress : Maybe msg
    }


{-| A Button with just text as a type
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


{-| A list of options with at most one selected.

Alternaitve Name: Choice

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


{-| A list of options with multiple selected.

Alternative Name: Options

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


{-| A Dialog window displaying an important choice.
-}
type alias Dialog msg =
    { title : Maybe String
    , body : Element msg
    , accept : Maybe (TextButton msg)
    , dismiss : Maybe (TextButton msg)
    }


{-| A modal.

NOTE: to stop the screen from scrolling, set the height of the layout to the height of the screen.

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
- DIALOG
----------------------------------------------------------}


type alias ExpansionPanel msg =
    { onToggle : Bool -> msg
    , icon : Element Never
    , text : String
    , expandIcon : Element Never
    , collapseIcon : Element Never
    , content : Element msg
    , isExpanded : Bool
    }


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


{-| -}
type alias TextInputStyle msg =
    { chipButton : ButtonStyle msg
    , containerRow : List (Attribute msg)
    , chipsRow : List (Attribute msg)
    , input : List (Attribute msg)
    }


{-| -}
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


row : RowStyle msg -> List (Element msg) -> Element msg
row =
    List.row


column : ColumnStyle msg -> List (Element msg) -> Element msg
column =
    List.column


buttonRow :
    { list : RowStyle msg
    , button : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonRow =
    List.buttonRow


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


{-| A Sortable list allows you to sort coulmn.
-}
type alias ColumnType a =
    SortTable.ColumnType a


type alias Column a =
    SortTable.Column a


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
