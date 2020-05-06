module Widget exposing
    ( Button, TextButton, iconButton, textButton, button
    , Select, MultiSelect, selectButton, select, multiSelect
    , Dialog, modal, dialog
    , ExpansionPanel, expansionPanel
    , TextInputStyle, textInput, carousel, tab
    , Tab, buttonColumn, buttonRow, column, row
    )

{-| This module contains functions for displaying data.


# Buttons

@docs Button, TextButton, iconButton, textButton, button


# Select

@docs Select, MultiSelect, selectButton, select, multiSelect


# Dialog

@docs Dialog, modal, dialog


# ExpansionPanel

@docs ExpansionPanel, expansionPanel


# Other Widgets

@docs TextInputStyle, textInput, carousel, tab

-}

import Array exposing (Array)
import Element exposing (Attribute, Element)
import Element.Input exposing (Placeholder)
import Internal.Button as Button
import Internal.Dialog as Dialog
import Internal.ExpansionPanel as ExpansionPanel
import Internal.List as List
import Internal.Select as Select
import Internal.TextInput as TextInput
import Set exposing (Set)
import Widget.Style exposing (ButtonStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, RowStyle, TabStyle)



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
        , body : Element msg
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
- OTHER STATELESS WIDGETS
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
tab style { tabs, content } =
    [ tabs
        |> select
        |> List.map (selectButton style.button)
        |> Element.row style.optionRow
    , tabs.selected
        |> content
        |> Element.el style.content
    ]
        |> Element.column style.containerColumn


{-| A Carousel circles through a non empty list of contents.
-}
carousel :
    { content : ( a, Array a )
    , current : Int
    , label : a -> Element msg
    }
    -> Element msg
carousel { content, current, label } =
    let
        ( head, tail ) =
            content
    in
    (if current <= 0 then
        head

     else if current > Array.length tail then
        tail
            |> Array.get (Array.length tail - 1)
            |> Maybe.withDefault head

     else
        tail
            |> Array.get (current - 1)
            |> Maybe.withDefault head
    )
        |> label
