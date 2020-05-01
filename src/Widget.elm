module Widget exposing
    ( Button, TextButton, iconButton, textButton, button
    , Select, MultiSelect, selectButton, select, multiSelect
    , Dialog, modal, dialog
    , TextInputStyle, textInput, collapsable, carousel, tab
    )

{-| This module contains functions for displaying data.


# Buttons

@docs Button, TextButton, iconButton, textButton, button


# Select

@docs Select, MultiSelect, selectButton, select, multiSelect


# Dialog

@docs Dialog, modal, dialog


# Other Widgets

@docs TextInputStyle, textInput, collapsable, carousel, tab

-}

import Array exposing (Array)
import Element exposing (Attribute, Element)
import Element.Input as Input exposing (Placeholder)
import Internal.Button as Button
import Internal.Dialog as Dialog
import Internal.Select as Select
import Set exposing (Set)
import Widget.Style exposing (ButtonStyle, DialogStyle)



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
- OTHER STATELESS WIDGETS
----------------------------------------------------------}


{-| -}
type alias TextInputStyle msg =
    { chip : ButtonStyle msg
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
textInput style { chips, placeholder, label, text, onChange } =
    Element.row style.containerRow
        [ chips
            |> List.map (Button.button style.chip)
            |> Element.row style.chipsRow
        , Input.text style.input
            { onChange = onChange
            , text = text
            , placeholder = placeholder
            , label = Input.labelHidden label
            }
        ]


{-| Some collapsable content.
-}
collapsable :
    { containerColumn : List (Attribute msg)
    , button : List (Attribute msg)
    }
    ->
        { onToggle : Bool -> msg
        , isCollapsed : Bool
        , label : Element msg
        , content : Element msg
        }
    -> Element msg
collapsable style { onToggle, isCollapsed, label, content } =
    Element.column style.containerColumn <|
        [ Input.button style.button
            { onPress = Just <| onToggle <| not isCollapsed
            , label = label
            }
        ]
            ++ (if isCollapsed then
                    []

                else
                    [ content ]
               )


{-| Displayes a list of contents in a tab
-}
tab :
    { button : ButtonStyle msg
    , optionRow : List (Attribute msg)
    , containerColumn : List (Attribute msg)
    }
    -> Select msg
    -> (Maybe Int -> Element msg)
    -> Element msg
tab style options content =
    [ options
        |> select
        |> List.map (selectButton style.button)
        |> Element.row style.optionRow
    , options.selected
        |> content
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
