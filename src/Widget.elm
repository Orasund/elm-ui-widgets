module Widget exposing
    ( ButtonStyle, Button, TextButton, iconButton, textButton, button
    , SwitchStyle, Switch, switch
    , Select, selectButton, select
    , MultiSelect, multiSelect
    , Modal, singleModal, multiModal
    , DialogStyle, Dialog, dialog
    , RowStyle, row, buttonRow
    , ColumnStyle, column, buttonColumn
    , ItemStyle, Item
    , ExpansionItemStyle, ExpansionItem, expansionItem
    , ImageItemStyle, ImageItem, imageItem
    , MultiLineItemStyle, MultiLineItem, multiLineItem
    , HeaderStyle, headerItem
    , DividerStyle, divider
    , selectItem, asItem
    , itemList
    , AppBarStyle, menuBar, tabBar
    , SortTableStyle, SortTable, Column, sortTable, floatColumn, intColumn, stringColumn, unsortableColumn
    , TextInputStyle, TextInput, textInput
    , TabStyle, Tab, tab
    , ProgressIndicatorStyle, ProgressIndicator, circularProgressIndicator
    , FullBleedItemStyle, InsetItem, InsetItemStyle, fullBleedItem, insetItem
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


# Modal

@docs Modal, singleModal, multiModal


# Dialog

![Dialog](https://orasund.github.io/elm-ui-widgets/assets/dialog.png)

[Open in Ellie](https://ellie-app.com/9p5Rdz625TZa1)

@docs DialogStyle, Dialog, dialog


# List

![List](https://orasund.github.io/elm-ui-widgets/assets/list.png)

[Open in Ellie](https://ellie-app.com/9p5RJnDVVCKa1)


## Row

@docs RowStyle, row, buttonRow


## Column

@docs ColumnStyle, column, buttonColumn


## Item

@docs ItemStyle, FullBleedStyle, Item, item
@docs TextItemStyle, TextItem, textItem
@docs ExpansionItemStyle, ExpansionItem, expansionItem
@docs ImageItemStyle, ImageItem, imageItem
@docs MultiLineItemStyle, MultiLineItem, multiLineItem
@docs HeaderStyle, headerItem
@docs DividerStyle, divider
@docs selectItem, asItem
@docs itemList


# App Bar

@docs AppBarStyle, menuBar, tabBar


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
import Element exposing (Attribute, DeviceClass, Element, Length)
import Element.Input exposing (Placeholder)
import Internal.AppBar as AppBar
import Internal.Button as Button
import Internal.Dialog as Dialog
import Internal.Item as Item
import Internal.List as List
import Internal.Modal as Modal
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

    import Widget.Material as Material
    import Material.Icons as MaterialIcons
    import Material.Icons.Types exposing (Coloring(..))
    import Widget.Icon as Icon

    type Msg
        = Like

    iconButton (Material.iconButton Material.defaultPalette)
        { text = "Like"
        , icon = MaterialIcons.favorite |> Icon.elmMaterialIcons Color
        , onPress = Just Like
        }
        |> always "Ignore this line" --> "Ignore this line"

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

    import Widget.Material as Material

    type Msg
        = Like

    textButton (Material.textButton Material.defaultPalette)
        { text = "Like"
        , onPress = Just Like
        }
        |> always "Ignore this line" --> "Ignore this line"

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

    import Widget.Material as Material
    import Material.Icons as MaterialIcons
    import Material.Icons.Types exposing (Coloring(..))
    import Widget.Icon as Icon

    type Msg
        = Submit

    button (Material.containedButton Material.defaultPalette)
        { text = "Submit"
        , icon = MaterialIcons.favorite |> Icon.elmMaterialIcons Color
        , onPress = Just Submit
        }
        |> always "Ignore this line" --> "Ignore this line"

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

    import Widget.Material as Material

    type Msg
        = Activate

    switch (Material.switch Material.defaultPalette)
        { description = "Activate Dark Mode"
        , onPress = Just Activate
        , active = False
        }
        |> always "Ignore this line" --> "Ignore this line"

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

    import Widget.Material as Material
    import Element

    type Msg
        = ChangedSelected Int

    { selected = Just 1
    , options =
        [ 1, 2, 42 ]
            |> List.map
                (\int ->
                    { text = String.fromInt int
                    , icon = always Element.none
                    }
                )
    , onSelect = (\i -> Just <| ChangedSelected i)
    }
        |> Widget.select
        |> Widget.buttonRow
            { elementRow = Material.buttonRow
            , content = Material.toggleButton Material.defaultPalette
            }
        |> always "Ignore this line" --> "Ignore this line"

-}
selectButton :
    ButtonStyle msg
    -> ( Bool, Button msg )
    -> Element msg
selectButton =
    Select.selectButton


{-| Selects one out of multiple options. This can be used for radio buttons or Menus.

    import Widget.Material as Material
    import Element

    type Msg
        = ChangedSelected Int

    { selected = Just 1
    , options =
        [ 1, 2, 42 ]
            |> List.map
                (\int ->
                    { text = String.fromInt int
                    , icon = always Element.none
                    }
                )
    , onSelect = (\i -> Just <| ChangedSelected i)
    }
        |> Widget.select
        |> Widget.buttonRow
            { elementRow = Material.buttonRow
            , content = Material.toggleButton Material.defaultPalette
            }
        |> always "Ignore this line" --> "Ignore this line"

-}
select :
    Select msg
    -> List ( Bool, Button msg )
select =
    Select.select


{-| Selects multible options. This can be used for checkboxes.

    import Widget.Material as Material
    import Set
    import Element

    type Msg
        = ChangedSelected Int

    { selected = [1,2] |> Set.fromList
    , options =
        [ 1, 2, 42 ]
            |> List.map
                (\int ->
                    { text = String.fromInt int
                    , icon = always Element.none
                    }
                )
    , onSelect = (\i -> Just <| ChangedSelected i)
    }
        |> Widget.multiSelect
        |> Widget.buttonRow
            { elementRow = Material.buttonRow
            , content = Material.toggleButton Material.defaultPalette
            }
        |> always "Ignore this line" --> "Ignore this line"

-}
multiSelect :
    MultiSelect msg
    -> List ( Bool, Button msg )
multiSelect =
    Select.multiSelect



{----------------------------------------------------------
- MODAL
----------------------------------------------------------}


type alias Modal msg =
    { onDismiss : Maybe msg
    , content : Element msg
    }


{-| A modal showing a single element.

Material design only allows one element at a time to be viewed as a modal.
To make things easier, this widget only views the first element of the list.
This way you can see the list as a queue of modals.

    import Element

    type Msg
        = Close

    Element.layout
        (singleModal
            [ { onDismiss = Just Close
              , content =
                  Element.text "Click outside this window to close it."
              }
            ]
        )
        |> always "Ignore this line" --> "Ignore this line"

Technical Remark:

  - To stop the screen from scrolling, set the height of the layout to the height of the screen.

-}
singleModal : List { onDismiss : Maybe msg, content : Element msg } -> List (Attribute msg)
singleModal =
    Modal.singleModal


{-| Same implementation as `singleModal` but also displays the "queued" modals.

    import Element

    type Msg
        = Close

    Element.layout
        (multiModal
            [ { onDismiss = Just Close
              , content =
                  Element.text "Click outside this window to close it."
              }
            ]
        )
        |> always "Ignore this line" --> "Ignore this line"

-}
multiModal : List { onDismiss : Maybe msg, content : Element msg } -> List (Attribute msg)
multiModal =
    Modal.multiModal



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


{-| A Dialog Window.

    import Widget.Material as Material
    import Element

    type Msg
        = Submit
        | Close

    Element.layout
        (dialog (Material.alertDialog Material.defaultPalette)
            { title = Just "Accept"
            , text = "Are you sure?"
            , accept =
                { text = "Accept"
                , onPress = Just Submit
                }
                |> Just
            , dismiss =
                { text = "Cancel"
                , onPress = Just Close
                }
                |> Just
            }
            |> List.singleton
            |> singleModal
        )
        |> always "Ignore this line" --> "Ignore this line"

-}
dialog :
    DialogStyle msg
    ->
        { title : Maybe String
        , text : String
        , accept : Maybe (TextButton msg)
        , dismiss : Maybe (TextButton msg)
        }
    -> Modal msg
dialog =
    let
        fun : DialogStyle msg -> Dialog msg -> Modal msg
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

    import Element
    import Widget.Material as Material

    type Msg =
        ToggleTextInputChip String
        | SetTextInput String

    {text = "Hello World"}
        |> (\model ->
                { chips =
                    [ "Cat", "Fish", "Dog"]
                        |> List.map
                            (\string ->
                                { icon = always Element.none
                                , text = string
                                , onPress =
                                    string
                                        |> ToggleTextInputChip
                                        |> Just
                                }
                            )
                , text = model.text
                , placeholder = Nothing
                , label = "Chips"
                , onChange = SetTextInput
                }
            )
        |> Widget.textInput (Material.textInput Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

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
type alias ItemStyle content msg =
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
type alias FullBleedItemStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { elementRow : List (Attribute msg)
        , content :
            { text : { elementText : List (Attribute msg) }
            , icon : IconStyle
            }
        }
    }


{-| -}
type alias InsetItemStyle msg =
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
                { elementColumn : List (Attribute msg)
                , content :
                    { title : { elementText : List (Attribute msg) }
                    , text : { elementText : List (Attribute msg) }
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
    { item : ItemStyle (InsetItemStyle msg) msg
    , expandIcon : Icon msg
    , collapseIcon : Icon msg
    }


{-| -}
type alias InsetItem msg =
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

Use `Widget.asItem` if you want to turn a simple element into an item.

-}
type alias Item msg =
    List (Attribute msg) -> Element msg


{-| A text item spanning the full width.

    import Element
    import Widget.Material as Material

    [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        }
    , Widget.divider (Material.fullBleedDivider Material.defaultPalette )
    , Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        }
    ]
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

-}
fullBleedItem :
    ItemStyle (FullBleedItemStyle msg) msg
    ->
        { text : String
        , onPress : Maybe msg
        , icon : Icon msg
        }
    -> Item msg
fullBleedItem =
    let
        fun : ItemStyle (FullBleedItemStyle msg) msg -> Button msg -> Item msg
        fun =
            Item.fullBleedItem
    in
    fun


{-| Turns a Element into an item. Only use if you want to take care of the styling yourself.

    import Element
    import Widget.Material as Material

    Element.text "Just a text"
        |> Widget.asItem
        |> List.singleton
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

-}
asItem : Element msg -> Item msg
asItem =
    Item.asItem


{-| A divider.

    import Element
    import Widget.Material as Material

    [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        }
    , Widget.divider (Material.insetDivider Material.defaultPalette )
    , Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        }
    ]
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

-}
divider : ItemStyle (DividerStyle msg) msg -> Item msg
divider =
    Item.divider


{-| A header for a part of a list.

    import Element
    import Widget.Material as Material

    [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        }
    , "Header"
        |> Widget.headerItem (Material.insetHeader Material.defaultPalette )
    , Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        }
    ]
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

-}
headerItem : ItemStyle (HeaderStyle msg) msg -> String -> Item msg
headerItem =
    Item.headerItem


{-| A clickable item that contains two spots for icons or additional information and a single line of text.

    import Element
    import Widget.Material as Material

    [ Widget.insetItem (Material.insetItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        , content =
            \{ size, color } ->
                Element.none
        }
    , Widget.divider (Material.insetDivider Material.defaultPalette )
    , Widget.insetItem (Material.insetItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        , content =
            \{ size, color } ->
                Element.none
        }
    ]
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

-}
insetItem :
    ItemStyle (InsetItemStyle msg) msg
    ->
        { text : String
        , onPress : Maybe msg
        , icon : Icon msg
        , content : Icon msg
        }
    -> Item msg
insetItem =
    let
        fun : ItemStyle (InsetItemStyle msg) msg -> InsetItem msg -> Item msg
        fun =
            Item.insetItem
    in
    fun


{-| A item contining a text running over multiple lines.

    import Element
    import Widget.Material as Material

    [ Widget.multiLineItem (Material.multiLineItem Material.defaultPalette)
        { title = "Title"
        , onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        , content =
            \{ size, color } ->
                Element.none
        }
    ]
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

-}
multiLineItem :
    ItemStyle (MultiLineItemStyle msg) msg
    ->
        { title : String
        , text : String
        , onPress : Maybe msg
        , icon : Icon msg
        , content : Icon msg
        }
    -> Item msg
multiLineItem =
    let
        fun : ItemStyle (MultiLineItemStyle msg) msg -> MultiLineItem msg -> Item msg
        fun =
            Item.multiLineItem
    in
    fun


{-| A clickable item that contains a image , a line of text and some additonal information

    import Element
    import Widget.Material as Material
    import Widget.Material.Color as MaterialColor
    import Element.Font as Font

    [ Widget.imageItem (Material.imageItem Material.defaultPalette)
        { onPress = Nothing
        , image =
            Element.image [ Element.width <| Element.px <| 40, Element.height <| Element.px <| 40 ]
                { src = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Elm_logo.svg/1024px-Elm_logo.svg.png"
                , description = "Elm logo"
                }
        , text = "Item with Image"
        , content =
            \{ size, color } ->
                "1."
                    |> Element.text
                    |> Element.el
                        [ Font.color <| MaterialColor.fromColor color
                        , Font.size size
                        ]
        }
    ]
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

-}
imageItem :
    ItemStyle (ImageItemStyle msg) msg
    ->
        { text : String
        , onPress : Maybe msg
        , image : Element msg
        , content : Icon msg
        }
    -> Item msg
imageItem =
    let
        fun : ItemStyle (ImageItemStyle msg) msg -> ImageItem msg -> Item msg
        fun =
            Item.imageItem
    in
    fun


{-| An expandable Item

    import Element
    import Widget.Material as Material
    import Widget.Material.Color as MaterialColor
    import Element.Font as Font

    type Msg =
        Toggle Bool

    let
        isExpanded : Bool
        isExpanded =
            True
    in
    (   [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
            { onPress = Nothing
            , icon = always Element.none
            , text = "Item with Icon"
            }
        ]
        ++ Widget.expansionItem (Material.expansionItem Material.defaultPalette )
            { onToggle = Toggle
            , isExpanded = isExpanded
            , icon = always Element.none
            , text = "Expandable Item"
            , content =
                [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
                { onPress = Nothing
                , icon = always Element.none
                , text = "Item with Icon"
                }
                ]
            }
    )
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

-}
expansionItem :
    ExpansionItemStyle msg
    ->
        { icon : Icon msg
        , text : String
        , onToggle : Bool -> msg
        , content : List (Item msg)
        , isExpanded : Bool
        }
    -> List (Item msg)
expansionItem =
    let
        fun : ExpansionItemStyle msg -> ExpansionItem msg -> List (Item msg)
        fun =
            Item.expansionItem
    in
    fun


{-| Displays a selection of Buttons as a item list. This is intended to be used as a menu.

    import Element
    import Widget.Material as Material
    import Widget.Material.Color as MaterialColor
    import Element.Font as Font

    type Msg =
        Select Int

    (   { selected = Just 1
        , options =
            [ "Option 1", "Option 2" ]
                |> List.map
                    (\text ->
                        { text = text
                        , icon = always Element.none
                        }
                    )
        , onSelect = (\int ->
            int
            |> Select
            |> Just
            )
        }
            |> Widget.selectItem (Material.selectItem Material.defaultPalette)
    )
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

-}
selectItem : ItemStyle (ButtonStyle msg) msg -> Select msg -> List (Item msg)
selectItem =
    Item.selectItem


{-| Replacement of `Element.row`

    import Element
    import Widget.Material as Material

    [ Element.text "Text 1"
    , Element.text "Text 2"
    ]
        |> Widget.row Material.row
        |> always "Ignore this line" --> "Ignore this line"

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

    import Element
    import Widget.Material as Material

    [ Element.text "Text 1"
    , Element.text "Text 2"
    ]
        |> Widget.column Material.column
        |> always "Ignore this line" --> "Ignore this line"

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

    import Element
    import Widget.Material as Material

    [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        }
    , "Header"
        |> Widget.headerItem (Material.insetHeader Material.defaultPalette )
    , Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
        { onPress = Nothing
        , icon = always Element.none
        , text = "Item"
        }
    ]
        |> Widget.itemList (Material.cardColumn Material.defaultPalette)
        |> always "Ignore this line" --> "Ignore this line"

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

    import Element
    import Widget.Material as Material

    type Msg =
        Select Int

    selected : Maybe Int
    selected =
        Just 0

    Widget.select
        { selected = selected
        , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = always Element.none
                        }
                    )
        , onSelect = (\i -> Just (Select i ))
        }
        |> Widget.buttonRow
            { elementRow = Material.row
            , content = Material.toggleButton Material.defaultPalette
            }
        |> always "Ignore this line" --> "Ignore this line"

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

    import Element
    import Widget.Material as Material

    type Msg =
        Select Int

    selected : Maybe Int
    selected =
        Just 0

    Widget.select
        { selected = selected
        , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = always Element.none
                        }
                    )
        , onSelect = (\i -> Just (Select i ))
        }
        |> Widget.buttonColumn
            { elementColumn = Material.column
            , content = Material.toggleButton Material.defaultPalette
            }
        |> always "Ignore this line" --> "Ignore this line"

-}
buttonColumn :
    { elementColumn : ColumnStyle msg
    , content : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonColumn =
    List.buttonColumn



--------------------------------------------------------------------------------
-- APP BAR
--------------------------------------------------------------------------------


{-| -}
type alias AppBarStyle content msg =
    { elementRow : List (Attribute msg)
    , content :
        { menu :
            { elementRow : List (Attribute msg)
            , content : content
            }
        , search : TextInputStyle msg
        , actions :
            { elementRow : List (Attribute msg)
            , content :
                { button : ButtonStyle msg
                , searchIcon : Icon msg
                , moreVerticalIcon : Icon msg
                }
            }
        }
    }


{-| A app bar with a menu button on the left side.

This should be the default way to display the app bar. Specially for Phone users.

    import Element exposing (DeviceClass(..))
    import Widget.Material as Material

    type Msg =
        Select Int

    selected : Int
    selected = 0

    Widget.menuBar style.tabBar
        { title =
            "Title"
                |> Element.text
                |> Element.el Typography.h6
        , deviceClass = Phone
        , openRightSheet = Nothing
        , openTopSheet = Nothing
        , primaryActions =
            [   { icon =
                    Material.Icons.change_history
                        |> Icon.elmMaterialIcons Color
                , text = "Action"
                , onPress = Nothing
                }
            ]
        , search = Nothing
        }

-}
menuBar :
    AppBarStyle
        { menuIcon : Icon msg
        , title : List (Attribute msg)
        }
        msg
    ->
        { title : Element msg
        , deviceClass : DeviceClass
        , openLeftSheet : Maybe msg
        , openRightSheet : Maybe msg
        , openTopSheet : Maybe msg
        , primaryActions : List (Button msg)
        , search : Maybe (TextInput msg)
        }
    -> Element msg
menuBar =
    AppBar.menuBar


{-| A app bar with tabs instead of a menu.

This is should be used for big screens.

It should be avoided for smaller screens or if you have more then 4 tabs

    import Element exposing (DeviceClass(..))
    import Widget.Material as Material

    type Msg =
        Select Int

    selected : Int
    selected = 0

    Widget.tabBar style.tabBar
        { title =
            "Title"
                |> Element.text
                |> Element.el Typography.h6
        , menu =
            { selected = Just selected
            , options =
                [ "Home", "About" ]
                    |> List.map
                        (\string ->
                            { text = string
                            , icon = always Element.none
                            }
                        )
            , onSelect = \int -> int |> Select |> Just
            }
        , deviceClass = Phone
        , openRightSheet = Nothing
        , openTopSheet = Nothing
        , primaryActions =
            [   { icon =
                    Material.Icons.change_history
                        |> Icon.elmMaterialIcons Color
                , text = "Action"
                , onPress = Nothing
                }
            ]
        , search = Nothing
        }

-}
tabBar :
    AppBarStyle
        { menuTabButton : ButtonStyle msg
        , title : List (Attribute msg)
        }
        msg
    ->
        { title : Element msg
        , menu : Select msg
        , deviceClass : DeviceClass
        , openRightSheet : Maybe msg
        , openTopSheet : Maybe msg
        , primaryActions : List (Button msg)
        , search : Maybe (TextInput msg)
        }
    -> Element msg
tabBar =
    AppBar.tabBar



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


{-| A table where the rows can be sorted by columns

    import Widget.Material as Material
    import Element

    type Msg =
        ChangedSorting String

    sortBy : String
    sortBy =
        "Id"

    asc : Bool
    asc =
        True

    Widget.sortTable (Material.sortTable Material.defaultPalette)
        { content =
            [ { id = 1, name = "Antonio", rating = 2.456, hash = Nothing }
            , { id = 2, name = "Ana", rating = 1.34, hash = Just "45jf" }
            , { id = 3, name = "Alfred", rating = 4.22, hash = Just "6fs1" }
            , { id = 4, name = "Thomas", rating = 3, hash = Just "k52f" }
            ]
        , columns =
            [ Widget.intColumn
                { title = "Id"
                , value = .id
                , toString = \int -> "#" ++ String.fromInt int
                , width = Element.fill
                }
            , Widget.stringColumn
                { title = "Name"
                , value = .name
                , toString = identity
                , width = Element.fill
                }
            , Widget.floatColumn
                { title = "Rating"
                , value = .rating
                , toString = String.fromFloat
                , width = Element.fill
                }
            , Widget.unsortableColumn
                { title = "Hash"
                , toString = (\{hash} -> hash |> Maybe.withDefault "None")
                , width = Element.fill
                }
            ]
        , asc = asc
        , sortBy = sortBy
        , onChange = ChangedSorting
        }
        |> always "Ignore this line" --> "Ignore this line"

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

    import Element
    import Widget.Material as Material

    type Msg =
        ChangedTab Int

    selected : Maybe Int
    selected =
        Just 0

    Widget.tab (Material.tab Material.defaultPalette)
        { tabs =
            { selected = selected
            , options =
                [ 1, 2, 3 ]
                    |> List.map
                        (\int ->
                            { text = "Tab " ++ (int |> String.fromInt)
                            , icon = always Element.none
                            }
                        )
            , onSelect =
                (\s ->
                    if s >= 0 && s <= 2 then
                        Just (ChangedTab s)
                    else
                        Nothing
                )
            }
        , content =
            (\s ->
                case s of
                    Just 0 ->
                        "This is Tab 1" |> Element.text
                    Just 1 ->
                        "This is the second tab" |> Element.text
                    Just 2 ->
                        "The thrid and last tab" |> Element.text
                    _ ->
                        "Please select a tab" |> Element.text
            )
        }
        |> always "Ignore this line" --> "Ignore this line"

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

    import Widget.Material as Material

    Just 0.75
    |> Widget.circularProgressIndicator (Material.progressIndicator Material.defaultPalette)
    |> always "Ignore this line" --> "Ignore this line"

-}
circularProgressIndicator :
    ProgressIndicatorStyle msg
    -> Maybe Float
    -> Element msg
circularProgressIndicator =
    ProgressIndicator.circularProgressIndicator
