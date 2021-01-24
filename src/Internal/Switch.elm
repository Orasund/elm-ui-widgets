module Internal.Switch exposing (Switch, SwitchStyle, switch)

import Color exposing (Color)
import Element exposing (Attribute, Element)
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)
import Widget.Icon exposing (Icon)


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


type alias Switch msg =
    { description : String
    , onPress : Maybe msg
    , active : Bool
    }


switch : SwitchStyle msg -> Switch msg -> Element msg
switch style { onPress, description, active } =
    Input.button
        (style.elementButton
            ++ [ Region.description description
               , Element.none
                    |> Element.el
                        (style.contentInFront.content.element
                            ++ (if active then
                                    style.contentInFront.content.ifActive

                                else if onPress == Nothing then
                                    style.contentInFront.content.ifDisabled

                                else
                                    style.contentInFront.content.otherwise
                               )
                        )
                    |> Element.el
                        (style.contentInFront.element
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
                    (style.content.element
                        ++ (if active then
                                style.content.ifActive

                            else if onPress == Nothing then
                                style.content.ifDisabled

                            else
                                style.content.otherwise
                           )
                    )
        }
