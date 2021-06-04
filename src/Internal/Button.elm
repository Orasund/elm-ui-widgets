module Internal.Button exposing (Button, ButtonStyle, TextButton, button, iconButton, textButton)

import Element exposing (Attribute, Element)
import Element.Input as Input
import Element.Region as Region
import Widget.Icon exposing (Icon, IconStyle)


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


type alias Button msg =
    { text : String
    , onPress : Maybe msg
    , icon : Icon msg
    }


type alias TextButton msg =
    { text : String
    , onPress : Maybe msg
    }


iconButton : ButtonStyle msg -> Button msg -> Element msg
iconButton style { onPress, text, icon } =
    Input.button
        (style.elementButton
            ++ (if onPress == Nothing then
                    style.ifDisabled

                else
                    style.otherwise
               )
            ++ [ Region.description text ]
        )
        { onPress = onPress
        , label =
            icon
                (if onPress == Nothing then
                    style.content.content.icon.ifDisabled

                 else
                    style.content.content.icon.otherwise
                )
                |> Element.el style.content.elementRow
        }


textButton : ButtonStyle msg -> TextButton msg -> Element msg
textButton style { onPress, text } =
    button style
        { onPress = onPress
        , text = text
        , icon = always Element.none
        }


button :
    ButtonStyle msg
    -> Button msg
    -> Element msg
button style { onPress, text, icon } =
    Input.button
        (style.elementButton
            ++ (if onPress == Nothing then
                    style.ifDisabled

                else
                    style.otherwise
               )
            ++ [ Region.description text ]
        )
        { onPress = onPress
        , label =
            Element.row style.content.elementRow
                [ icon
                    (if onPress == Nothing then
                        style.content.content.icon.ifDisabled

                     else
                        style.content.content.icon.otherwise
                    )
                , Element.text text
                    |> Element.el style.content.content.text.contentText
                ]
        }
