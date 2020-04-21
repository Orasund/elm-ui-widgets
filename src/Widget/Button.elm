module Widget.Button exposing
    ( Button
    , ButtonStyle
    , TextButton
    , view
    , viewIconOnly
    , viewTextOnly
    )

import Element exposing (Attribute, Element)
import Element.Input as Input
import Element.Region as Region


type alias Button msg =
    { text : String
    , icon : Element Never
    , onPress : Maybe msg
    }


type alias TextButton msg =
    { text : String
    , onPress : Maybe msg
    }


type alias ButtonStyle msg =
    { container : List (Attribute msg)
    , disabled : List (Attribute msg)
    , label : List (Attribute msg)
    , active : List (Attribute msg)
    }


viewIconOnly : ButtonStyle msg -> Button msg -> Element msg
viewIconOnly style { onPress, text, icon } =
    Input.button
        (style.container
            ++ (if onPress == Nothing then
                    style.disabled

                else
                    []
               )
            ++ [ Region.description text ]
        )
        { onPress = onPress
        , label =
            icon |> Element.map never
        }


viewTextOnly : ButtonStyle msg -> TextButton msg -> Element msg
viewTextOnly style { onPress, text } =
    view style
        { onPress = onPress
        , text = text
        , icon = Element.none
        }


{-| The first argument can be used to define the spacing between the icon and the text
-}
view : ButtonStyle msg -> Button msg -> Element msg
view style { onPress, text, icon } =
    Input.button
        (style.container
            ++ (if onPress == Nothing then
                    style.disabled

                else
                    []
               )
        )
        { onPress = onPress
        , label =
            Element.row style.label
                [ icon |> Element.map never
                , Element.text text
                ]
        }
