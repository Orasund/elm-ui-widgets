module Widget exposing
    ( ButtonStyle, Button, TextButton, iconButton, textButton, button
    , SwitchStyle, Switch, switch
    , Select, selectButton, select
    , MultiSelect, multiSelect
    , DialogStyle, Dialog, modal, dialog
    , RowStyle, row, buttonRow
    , ColumnStyle, column, buttonColumn
    , ItemStyle, DividerStyle, HeaderStyle, TextItemStyle, ExpansionItemStyle, Item, ExpansionItem, itemList, item, divider, headerItem, textItem, expansionItem
    , SortTableStyle, SortTable, Column, sortTable, floatColumn, intColumn, stringColumn, unsortableColumn
    , TextInputStyle, TextInput, textInput
    , TabStyle, Tab, tab
    , ProgressIndicatorStyle, ProgressIndicator, circularProgressIndicator, imageItem
    , ImageItemStyle
    , MultiLineItemStyle,multiLineItem
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

@docs ButtonStyle, Button, TextButton, iconButton, textButton, button


# Switch

@docs SwitchStyle, Switch, switch


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

@docs DialogStyle, Dialog, modal, dialog



# List

![List](https://orasund.github.io/elm-ui-widgets/assets/list.png)

[Open in Ellie](https://ellie-app.com/9p5RJnDVVCKa1)


## Row

@docs RowStyle, row, buttonRow


## Column

@docs ColumnStyle, column, buttonColumn


## Item

@docs ItemStyle, DividerStyle, HeaderStyle, TextItemStyle,ImageItemStyle, ExpansionItemStyle,MultiLineItemStyle,Item, ExpansionItem, itemList, item, divider, headerItem, buttonDrawer, textItem,imageItem, expansionItem,multiLineItem 


# Sort Table

![SortTable](https://orasund.github.io/elm-ui-widgets/assets/sortTable.png)

[Open in Ellie](https://ellie-app.com/9p5RXw44B4Ja1)

@docs SortTableStyle, SortTable, Column, sortTable, floatColumn, intColumn, stringColumn, unsortableColumn


# Text Input

![textInput](https://orasund.github.io/elm-ui-widgets/assets/textInput.png)

[Open in Ellie](https://ellie-app.com/9p5S6cvWCmBa1)

@docs TextInputStyle, TextInput, textInput


# Tab

![tab](https://orasund.github.io/elm-ui-widgets/assets/tab.png)

[Open in Ellie](https://ellie-app.com/9p5Sdbvp4jZa1)

@docs TabStyle, Tab, tab


# Progress Indicator

![progress Indicator](https://orasund.github.io/elm-ui-widgets/assets/progressIndicator.png)

[Open in Ellie](https://ellie-app.com/c47GJktH2bqa1)

@docs ProgressIndicatorStyle, ProgressIndicator, circularProgressIndicator

-}

import Color exposing (Color)
import Element exposing (Attribute, Element, Length)
import Element.Input exposing (Placeholder)
import Html exposing (Html)
import Internal.Button as Button
import Internal.Dialog as Dialog
import Internal.ExpansionPanel as ExpansionPanel
import Internal.Item as Item 
import Internal.List as List
import Internal.ProgressIndicator as ProgressIndicator
import Internal.Select as Select
import Internal.SortTable as SortTable
import Internal.Switch as Switch
import Internal.Tab as Tab
import Internal.TextInput as TextInput
import Set exposing (Set)
import Widget.Icon exposing (Icon)



{----------------------------------------------------------
- ICON
----------------------------------------------------------}


{-| -}
type alias IconStyle =
    { size : Int
    , color : Color
    }


type alias Icon msg =
    { size : Int
    , color : Color
    }
    -> Element msg



{----------------------------------------------------------
- BUTTON
----------------------------------------------------------}


{-| -}
type alias ButtonStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , ifActive : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { elementRow : List (Attribute msg)
        , content :
            { text : { contentText : List (Attribute msg) }
            , icon :
                { ifDisabled : IconStyle
                , ifActive : IconStyle
                , otherwise : IconStyle
                }
            }
        }
    }


{-| Button widget type
-}
type alias Button msg =
    { text : String
    , icon : Icon msg
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
        , icon : Icon msg
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
        , icon : Icon msg
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
- SWITCH
----------------------------------------------------------}


{-| -}
type alias SwitchStyle msg =
    { elementButton : List (Attribute msg)
    , content :
        { element : List (Attribute msg)
        , ifDisabled : List (Attribute msg)
        , ifActive : List (Attribute msg)
        , otherwise : List (Attribute msg)
        }
    , contentInFront :
        { element : List (Attribute msg)
        , ifDisabled : List (Attribute msg)
        , ifActive : List (Attribute msg)
        , otherwise : List (Attribute msg)
        , content :
            { element : List (Attribute msg)
            , ifDisabled : List (Attribute msg)
            , ifActive : List (Attribute msg)
            , otherwise : List (Attribute msg)
            }
        }
    }


{-| Switch widget type
-}
type alias Switch msg =
    { description : String
    , onPress : Maybe msg
    , active : Bool
    }


{-| A boolean switch
-}
switch :
    SwitchStyle msg
    ->
        { description : String
        , onPress : Maybe msg
        , active : Bool
        }
    -> Element msg
switch =
    let
        fun : SwitchStyle msg -> Switch msg -> Element msg
        fun =
            Switch.switch
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
            , icon : Icon msg
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
            , icon : Icon msg
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


{-| -}
type alias DialogStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { title :
            { contentText : List (Attribute msg)
            }
        , text :
            { contentText : List (Attribute msg)
            }
        , buttons :
            { elementRow : List (Attribute msg)
            , content :
                { accept : ButtonStyle msg
                , dismiss : ButtonStyle msg
                }
            }
        }
    }


{-| Dialog widget type
-}
type alias Dialog msg =
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
        fun : DialogStyle msg -> Dialog msg -> List (Attribute msg)
        fun =
            Dialog.dialog
    in
    fun




{----------------------------------------------------------
- TEXT INPUT
----------------------------------------------------------}


{-| -}
type alias TextInputStyle msg =
    { elementRow : List (Attribute msg)
    , content :
        { chips :
            { elementRow : List (Attribute msg)
            , content : ButtonStyle msg
            }
        , text :
            { elementTextInput : List (Attribute msg)
            }
        }
    }


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


{-| -}
type alias ItemStyle content msg=
    { element : List (Attribute msg)
    , content : content
    }


{-| -}
type alias DividerStyle msg =
    { element : List (Attribute msg)
    }


{-| -}
type alias HeaderStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { divider : DividerStyle msg
        , title : List (Attribute msg)
        }
    }


{-| -}
type alias RowStyle msg =
    { elementRow : List (Attribute msg)
    , content :
        { element : List (Attribute msg)
        , ifFirst : List (Attribute msg)
        , ifLast : List (Attribute msg)
        , ifSingleton : List (Attribute msg)
        , otherwise : List (Attribute msg)
        }
    }


{-| -}
type alias ColumnStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { element : List (Attribute msg)
        , ifFirst : List (Attribute msg)
        , ifLast : List (Attribute msg)
        , ifSingleton : List (Attribute msg)
        , otherwise : List (Attribute msg)
        }
    }


{-| -}
type alias TextItemStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { elementRow : List (Attribute msg)
        , content :
            { text : { elementText : List (Attribute msg) }
            , icon :
                { element : List (Attribute msg)
                , content : IconStyle
                }
            , content : IconStyle
            }
        }
    }

{-| -}
type alias MultiLineItemStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { elementRow : List (Attribute msg)
        , content :
            { description : 
                { elementColumn :  List (Attribute msg)
                , content :
                    { title : {elementText : List (Attribute msg)}
                    , text : {elementText : List (Attribute msg)}
                    }
                }
            , icon : 
                { element : List (Attribute msg)
                , content : IconStyle
                }
            , content : IconStyle
            }
        }
    }

{-| -}
type alias ImageItemStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { elementRow : List (Attribute msg)
        , content :
            { text : { elementText : List (Attribute msg) }
            , image : { element : List (Attribute msg) }
            , content : IconStyle
            }
        }
    }

{-| -}
type alias ExpansionItemStyle msg =
    { item : ItemStyle (TextItemStyle msg) msg
    , expandIcon : Icon msg
    , collapseIcon : Icon msg
    }

{-| -}
type alias TextItem msg =
    { text : String
    , onPress : Maybe msg
    , icon : Icon msg
    , content : Icon msg
    }

{-| -}
type alias MultiLineItem msg =
    { title : String
    , text : String
    , onPress : Maybe msg
    , icon : Icon msg
    , content : Icon msg
    }

{-| -}
type alias ImageItem msg =
    { text : String
    , onPress : Maybe msg
    , image : Element msg
    , content : Icon msg
    }

{-| -}
type alias ExpansionItem msg =
    { icon : Icon msg
    , text : String
    , onToggle : Bool -> msg
    , content : List (Item msg)
    , isExpanded : Bool
    }


{-| Item widget type.

Use `Widget.item` if you want to turn a simple element into an item.

-}
type alias Item msg =
    List (Attribute msg) -> Element msg


{-| Simple element for a list.
-}
item : Element msg -> Item msg
item =
    Item.item


{-| A divider.
-}
divider : ItemStyle (DividerStyle msg) msg -> Item msg
divider =
    Item.divider


{-| A header for a part of a list.
-}
headerItem : ItemStyle (HeaderStyle msg) msg -> String -> Item msg
headerItem =
    Item.headerItem


{-| A clickable item that contains two spots for icons or additional information and a single line of text.
-}
textItem : ItemStyle (TextItemStyle msg) msg
    -> { text : String
    , onPress : Maybe msg
    , icon : Icon msg
    , content : Icon msg
    } -> Item msg
textItem =
    Item.textItem

multiLineItem : ItemStyle (MultiLineItemStyle msg) msg 
    -> { title : String
    , text : String
    , onPress : Maybe msg
    , icon : Icon msg
    , content : Icon msg
    } -> Item msg
multiLineItem =
    Item.multiLineItem

{-| A clickable item that contains a image , a line of text and some additonal information
-}
imageItem : ItemStyle (ImageItemStyle msg) msg
    -> { text : String
    , onPress : Maybe msg
    , image : Element msg
    , content : Icon msg
    } -> Item msg
imageItem =
    Item.imageItem

{-| An expandable Item
-}
expansionItem : ExpansionItemStyle msg 
    -> { icon : Icon msg
    , text : String
    , onToggle : Bool -> msg
    , content : List (Item msg)
    , isExpanded : Bool
    } -> List (Item msg)
expansionItem =
    Item.expansionItem


{-| Replacement of `Element.row`
-}
row : RowStyle msg -> List (Element msg) -> Element msg
row =
    let
        fun : RowStyle msg -> List (Element msg) -> Element msg
        fun =
            List.row
    in
    fun


{-| Replacement of `Element.column`
-}
column : ColumnStyle msg -> List (Element msg) -> Element msg
column =
    let
        fun : ColumnStyle msg -> List (Element msg) -> Element msg
        fun =
            List.column
    in
    fun


{-| Implementation of the Material design list
-}
itemList : ColumnStyle msg -> List (Item msg) -> Element msg
itemList =
    let
        fun : ColumnStyle msg -> List (Item msg) -> Element msg
        fun =
            List.itemList
    in
    fun


{-| A row of buttons
-}
buttonRow :
    { elementRow : RowStyle msg
    , content : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonRow =
    List.buttonRow


{-| A column of buttons
-}
buttonColumn :
    { elementColumn : ColumnStyle msg
    , content : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonColumn =
    List.buttonColumn



{----------------------------------------------------------
- SORT TABLE
----------------------------------------------------------}


{-| Technical Remark:

  - If icons are defined in Svg, they might not display correctly.
    To avoid that, make sure to wrap them in `Element.html >> Element.el []`

-}
type alias SortTableStyle msg =
    { elementTable : List (Attribute msg)
    , content :
        { header : ButtonStyle msg
        , ascIcon : Icon msg
        , descIcon : Icon msg
        , defaultIcon : Icon msg
        }
    }


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


{-| A Table where the rows can be sorted by columns
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


{-| -}
type alias TabStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { tabs :
            { elementRow : List (Attribute msg)
            , content : ButtonStyle msg
            }
        , content : List (Attribute msg)
        }
    }


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


{-| -}
type alias ProgressIndicatorStyle msg =
    { elementFunction : Maybe Float -> Element msg
    }


{-| Progress Indicator widget type

If `maybeProgress` is set to `Nothing`, an indeterminate progress indicator (e.g. spinner) will display.
If `maybeProgress` is set to `Just Float` (where the `Float` is proportion of completeness between 0 and 1 inclusive), a determinate progress indicator will visualize the progress.

-}
type alias ProgressIndicator =
    Maybe Float


{-| Displays a circular progress indicator
-}
circularProgressIndicator :
    ProgressIndicatorStyle msg
    -> Maybe Float
    -> Element msg
circularProgressIndicator =
    ProgressIndicator.circularProgressIndicator
