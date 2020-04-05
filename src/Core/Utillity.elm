module Core.Utillity exposing (responsiveLayout)

import Element exposing (Attribute, Element)
import Html exposing (Html)
import Html.Attributes as Attributes


{-| taken from Orasund/elm-ui-framework
-}
layout : List (Attribute msg) -> Element msg -> Html msg
layout attributes =
    Element.layoutWith
        { options = layoutOptions
        }
        (layoutAttributes ++ attributes)


{-| taken from Orasund/elm-ui-framework
-}
responsiveLayout : List (Attribute msg) -> Element msg -> Html msg
responsiveLayout attributes view =
    Html.div []
        [ Html.node "meta"
            [ Attributes.attribute "name" "viewport"
            , Attributes.attribute "content" "width=device-width, initial-scale=1.0"
            ]
            []
        , layout attributes <|
            view
        ]
