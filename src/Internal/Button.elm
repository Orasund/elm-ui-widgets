module Internal.Button exposing
    ( Button
    , TextButton
    , button
    , iconButton
    , textButton
    )

import Element exposing (Element)
import Element.Input as Input
import Element.Region as Region
import Widget.Style exposing (ButtonStyle)


type alias Button msg =
    { text : String
    , icon : Element Never
    , onPress : Maybe msg
    }


type alias TextButton msg =
    { text : String
    , onPress : Maybe msg
    }


iconButton : ButtonStyle msg -> Button msg -> Element msg
iconButton style { onPress, text, icon } =
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


textButton : ButtonStyle msg -> TextButton msg -> Element msg
textButton style { onPress, text } =
    button style
        { onPress = onPress
        , text = text
        , icon = Element.none
        }


button :
    ButtonStyle msg
    -> Button msg
    -> Element msg
button style { onPress, text, icon } =
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
