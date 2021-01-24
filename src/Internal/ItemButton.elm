module Internal.ItemButton exposing (ItemButton, iconButton)

import Element exposing (Element)
import Element.Input as Input
import Element.Region as Region
import Widget.Icon exposing (Icon)


type alias ItemButton msg =
    { text : String
    , onPress : Maybe msg
    , icon : Icon
    , content : Element msg
    }


iconButton style { onPress, text, icon } =
    Debug.todo "implement iconButton"
