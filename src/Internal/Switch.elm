module Internal.Switch exposing (Switch, switch)

import Element exposing (Element)
import Element.Input as Input
import Element.Region as Region
import Widget.Style exposing (SwitchStyle)


type alias Switch msg =
    { description : String
    , onPress : Maybe msg
    , active : Bool
    }


switch : SwitchStyle msg -> Switch msg -> Element msg
switch style { onPress, description, active } =
    Input.button
        (style.containerButton
            ++ [ Region.description description
               , Element.none
                    |> Element.el
                        (style.contentInFront.content.container
                            ++ (if active then
                                    style.contentInFront.content.ifActive

                                else if onPress == Nothing then
                                    style.contentInFront.content.ifDisabled

                                else
                                    style.contentInFront.content.otherwise
                               )
                        )
                    |> Element.el
                        (style.contentInFront.container
                            ++ (if active then
                                    style.contentInFront.ifActive

                                else if onPress == Nothing then
                                    style.contentInFront.ifDisabled

                                else
                                    style.contentInFront.otherwise
                               )
                        )
                    |> Element.inFront
               ]
        )
        { onPress = onPress
        , label =
            Element.none
                |> Element.el
                    (style.content.container
                        ++ (if active then
                                style.content.ifActive

                            else if onPress == Nothing then
                                style.content.ifDisabled

                            else
                                style.content.otherwise
                           )
                    )
        }
