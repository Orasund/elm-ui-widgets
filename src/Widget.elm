module Widget exposing
    ( Button, TextButton, iconButton, textButton, button
    , Select, selectButton, select
    , MultiSelect, multiSelect
    , DialogV2, modal, dialog
    , ExpansionPanelV2, expansionPanel
    , row, column, buttonRow, buttonColumn
    , SortTable, Column, sortTable, floatColumn, intColumn, stringColumn, unsortableColumn
    , TextInput, textInput
    , Tab, tab
    , Dialog, ExpansionPanel
    , circularProgressIndicator
    )

{-| This module contains different stateless view functions. No wiring required.

These widgets should be used by defining the styling seperately:

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

Every widgets comes with a type. You can think of the widgets as building blocks.
You can create you own widgets by sticking widgets types together.


# Buttons

![Button](https://orasund.github.io/elm-ui-widgets/assets/button.png)

[Open in Ellie](https://ellie-app.com/9p5QGZ3hgPLa1)

@docs Button, TextButton, iconButton, textButton, button


# Select

![Select](https://orasund.github.io/elm-ui-widgets/assets/select.png)

[Open in Ellie](https://ellie-app.com/9p5QSzQDMCca1)

@docs Select, selectButton, select

![MultiSelect](https://orasund.github.io/elm-ui-widgets/assets/multiSelect.png)

[Open in Ellie](https://ellie-app.com/9p5R5crjqfya1)

@docs MultiSelect, multiSelect


# Dialog

![Dialog](https://orasund.github.io/elm-ui-widgets/assets/dialog.png)

[Open in Ellie](https://ellie-app.com/9p5Rdz625TZa1)

@docs DialogV2, modal, dialog


# Expansion Panel

![ExpansionPanel](https://orasund.github.io/elm-ui-widgets/assets/expansionPanel.png)

[Open in Ellie](https://ellie-app.com/9p5Rv5jfVdFa1)

@docs ExpansionPanelV2, expansionPanel


# List

![List](https://orasund.github.io/elm-ui-widgets/assets/list.png)

[Open in Ellie](https://ellie-app.com/9p5RJnDVVCKa1)

@docs row, column, buttonRow, buttonColumn


# Sort Table

![SortTable](https://orasund.github.io/elm-ui-widgets/assets/sortTable.png)

[Open in Ellie](https://ellie-app.com/9p5RXw44B4Ja1)

@docs SortTable, Column, sortTable, floatColumn, intColumn, stringColumn, unsortableColumn


# Text Input

![textInput](https://orasund.github.io/elm-ui-widgets/assets/textInput.png)

[Open in Ellie](https://ellie-app.com/9p5S6cvWCmBa1)

@docs TextInput, textInput


# Tab

![tab](https://orasund.github.io/elm-ui-widgets/assets/tab.png)

[Open in Ellie](https://ellie-app.com/9p5Sdbvp4jZa1)

@docs Tab, tab


# DEPRECATED

@docs Dialog, ExpansionPanel

-}

import Element exposing (Attribute, Element, Length)
import Element.Input exposing (Placeholder)
import Internal.Button as Button
import Internal.Dialog as Dialog
import Internal.ExpansionPanel as ExpansionPanel
import Internal.List as List
import Internal.ProgressIndicator as ProgressIndicator
import Internal.Select as Select
import Internal.SortTable as SortTable
import Internal.Tab as Tab
import Internal.TextInput as TextInput
import Set exposing (Set)
import Widget.Style exposing (ButtonStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, ProgressIndicatorStyle, RowStyle, SortTableStyle, TabStyle, TextInputStyle)



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
    let
        fun : ButtonStyle msg -> Button msg -> Element msg
        fun =
            Button.iconButton
    in
    fun


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
    let
        fun : ButtonStyle msg -> TextButton msg -> Element msg
        fun =
            Button.textButton
    in
    fun style
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
    let
        fun : ButtonStyle msg -> Button msg -> Element msg
        fun =
            Button.button
    in
    fun



{----------------------------------------------------------
- SELECT
----------------------------------------------------------}


{-| Select widget type

Technical Remark:

  - A more suitable name would be "Choice"

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

  - A more suitable name would be "Options"

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


{-| DEPRECATED

Use `DialogV2` instead

-}
type alias Dialog msg =
    { title : Maybe String
    , body : Element msg
    , accept : Maybe (TextButton msg)
    , dismiss : Maybe (TextButton msg)
    }


{-| Dialog widget type
-}
type alias DialogV2 msg =
    { title : Maybe String
    , text : String
    , accept : Maybe (TextButton msg)
    , dismiss : Maybe (TextButton msg)
    }


{-| A modal.

Technical Remark:

  - To stop the screen from scrolling, set the height of the layout to the height of the screen.

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
    let
        fun : DialogStyle msg -> DialogV2 msg -> List (Attribute msg)
        fun =
            Dialog.dialog
    in
    fun



{----------------------------------------------------------
- EXPANSION PANEL
----------------------------------------------------------}


{-| DEPRECATED

Use `ExpansionPanelV2` instead

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


{-| Expansion Panel widget type
-}
type alias ExpansionPanelV2 msg =
    { onToggle : Bool -> msg
    , icon : Element Never
    , text : String
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
    let
        fun : ExpansionPanelStyle msg -> ExpansionPanelV2 msg -> Element msg
        fun =
            ExpansionPanel.expansionPanel
    in
    fun



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


{-| A text Input that allows to include chips.
-}
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
    let
        fun : TextInputStyle msg -> TextInput msg -> Element msg
        fun =
            TextInput.textInput
    in
    fun



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


{-| Sort Table widget type
-}
type alias SortTable a msg =
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

`value >> toString` field will be used for displaying the content.

`value` will be used for comparing the content

For example `value = String.toLower` will make the sorting case-insensitive.

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
    let
        fun : SortTableStyle msg -> SortTable a msg -> Element msg
        fun =
            SortTable.sortTable
    in
    fun



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
    let
        fun : TabStyle msg -> Tab msg -> Element msg
        fun =
            Tab.tab
    in
    fun



{----------------------------------------------------------
- PROGRESS INDICATOR
----------------------------------------------------------}


type alias ProgressIndicator =
    { maybeProgressPercent : Maybe Int }


circularProgressIndicator :
    ProgressIndicatorStyle msg
    -> { maybeProgressPercent : Maybe Int }
    -> Element msg
circularProgressIndicator =
    ProgressIndicator.circularProgressIndicator
