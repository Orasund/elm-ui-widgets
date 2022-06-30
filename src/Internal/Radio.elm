module Internal.Radio exposing (Radio, RadioStyle, radio)

import Element exposing (Attribute, Element)
import Element.Input as Input
import Element.Region as Region


type alias RadioStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , ifSelected : List (Attribute msg)
    , ifDisabledSelected : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { element : List (Attribute msg)
        , ifDisabled : List (Attribute msg)
        , ifSelected : List (Attribute msg)
        , ifDisabledSelected : List (Attribute msg)
        , otherwise : List (Attribute msg)
        }
    }


type alias Radio msg =
    { description : String
    , onPress : Maybe msg
    , selected : Bool
    }


radio : RadioStyle msg -> Radio msg -> Element msg
radio style { onPress, description, selected } =
    Input.button
        (style.elementButton
            ++ (case ( onPress == Nothing, selected ) of
                    ( True, True ) ->
                        style.ifDisabledSelected

                    ( True, False ) ->
                        style.ifDisabled

                    ( False, True ) ->
                        style.ifSelected

                    ( False, False ) ->
                        style.otherwise
               )
            ++ [ Region.description description
               ]
        )
        { onPress = onPress
        , label =
            Element.none
                |> Element.el
                    (style.content.element
                        ++ (case ( onPress == Nothing, selected ) of
                                ( True, True ) ->
                                    style.content.ifDisabledSelected

                                ( True, False ) ->
                                    style.content.ifDisabled

                                ( False, True ) ->
                                    style.content.ifSelected

                                ( False, False ) ->
                                    style.content.otherwise
                           )
                    )
        }
