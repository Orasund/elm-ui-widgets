module Internal.TextInput exposing (TextInput, textInput)

import Element exposing (Element)
import Element.Input as Input exposing (Placeholder)
import Internal.Button as Button exposing (Button)
import Widget.Style exposing (TextInputStyle)


type alias TextInput msg =
    { chips : List (Button msg)
    , text : String
    , placeholder : Maybe (Placeholder msg)
    , label : String
    , onChange : String -> msg
    }


textInput : TextInputStyle msg -> TextInput msg -> Element msg
textInput style { chips, placeholder, label, text, onChange } =
    Element.row style.containerRow
        [ if chips |> List.isEmpty then
            Element.none

          else
            chips
                |> List.map
                    (Button.button style.content.chips.content)
                |> Element.row style.content.chips.containerRow
        , Input.text style.content.text.containerTextInput
            { onChange = onChange
            , text = text
            , placeholder = placeholder
            , label = Input.labelHidden label
            }
        ]
