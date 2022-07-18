module Internal.Checkbox exposing (Checkbox, CheckboxStyle, checkbox)

import Element exposing (Attribute, Element)
import Element.Input as Input
import Element.Region as Region
import Html.Attributes


type alias CheckboxStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , ifSelected : List (Attribute msg)
    , ifDisabledSelected : List (Attribute msg)
    , otherwise : List (Attribute msg)
    }


type alias Checkbox msg =
    { description : String
    , onChange : Maybe (Bool -> msg)
    , checked : Bool
    }


checkbox : CheckboxStyle msg -> Checkbox msg -> Element msg
checkbox style { onChange, description, checked } =
    Input.button
        (Element.htmlAttribute
            (Html.Attributes.attribute "aria-checked" <|
                if checked then
                    "true"

                else
                    "false"
            )
            :: Element.htmlAttribute
                (Html.Attributes.attribute "role" "checkbox")
            :: style.elementButton
            ++ (case ( onChange == Nothing, checked ) of
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
        { onPress = onChange |> Maybe.map (\tomsg -> tomsg <| not checked)
        , label = Element.none
        }
