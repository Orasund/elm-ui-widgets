module Internal.PasswordInput exposing
    ( PasswordInput
    , PasswordInputStyle
    , currentPasswordInput
    , newPasswordInput
    )

import Element exposing (Attribute, Element)
import Element.Input as Input exposing (Label, Placeholder)


{-| -}
type alias PasswordInputStyle msg =
    { elementRow : List (Attribute msg)
    , content :
        { password :
            { elementPasswordInput : List (Attribute msg)
            }
        }
    }


type alias PasswordInput msg =
    { text : String
    , placeholder : Maybe (Placeholder msg)
    , label : String
    , onChange : String -> msg
    , show : Bool
    }


password :
    (List (Attribute msg)
     ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Placeholder msg)
        , label : Label msg
        , show : Bool
        }
     -> Element msg
    )
    -> PasswordInputStyle msg
    -> PasswordInput msg
    -> Element msg
password input style { placeholder, label, text, onChange, show } =
    Element.row style.elementRow
        [ input style.content.password.elementPasswordInput
            { onChange = onChange
            , text = text
            , placeholder = placeholder
            , label = Input.labelHidden label
            , show = show
            }
        ]


currentPasswordInput : PasswordInputStyle msg -> PasswordInput msg -> Element msg
currentPasswordInput =
    password Input.currentPassword


newPasswordInput : PasswordInputStyle msg -> PasswordInput msg -> Element msg
newPasswordInput =
    password Input.newPassword
