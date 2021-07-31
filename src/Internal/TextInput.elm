module Internal.TextInput exposing (TextInput, TextInputStyle, usernameInput,textInput
    , emailInput,searchInput,spellCheckedInput)

import Element exposing (Attribute, Element)
import Element.Input as Input exposing (Placeholder)
import Internal.Button as Button exposing (Button, ButtonStyle)


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


type alias TextInput msg =
    { chips : List (Button msg)
    , text : String
    , placeholder : Maybe (Placeholder msg)
    , label : String
    , onChange : String -> msg
    }

spellCheckedInput : TextInputStyle msg -> TextInput msg -> Element msg
spellCheckedInput =
    internal Input.spellChecked

searchInput : TextInputStyle msg -> TextInput msg -> Element msg
searchInput =
    internal Input.search

emailInput : TextInputStyle msg -> TextInput msg -> Element msg
emailInput =
    internal Input.email

usernameInput : TextInputStyle msg -> TextInput msg -> Element msg
usernameInput =
    internal Input.username

textInput : TextInputStyle msg -> TextInput msg -> Element msg
textInput =
    internal Input.text

internal : (List (Attribute msg)
    -> { onChange : String -> msg
       , text : String
       , placeholder : Maybe (Placeholder msg)
       , label : Label msg
       }
    -> Element msg) -> TextInputStyle msg -> TextInput msg -> Element msg
internal fun style { chips, placeholder, label, text, onChange } =
    Element.row style.elementRow
        [ if chips |> List.isEmpty then
            Element.none

          else
            chips
                |> List.map
                    (Button.button style.content.chips.content)
                |> Element.row style.content.chips.elementRow
        , fun style.content.text.elementTextInput
            { onChange = onChange
            , text = text
            , placeholder = placeholder
            , label = Input.labelHidden label
            }
        ]
