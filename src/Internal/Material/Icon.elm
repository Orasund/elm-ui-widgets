module Internal.Material.Icon exposing (icon)

import Element exposing (Element)
import Svg exposing (Svg)
import Svg.Attributes


icon : String -> Int -> List (Svg Never) -> Element Never
icon string size =
    Svg.svg
        [ Svg.Attributes.height <| String.fromInt size
        , Svg.Attributes.stroke "currentColor"
        , Svg.Attributes.fill "currentColor"

        --, Svg.Attributes.strokeLinecap "round"
        --, Svg.Attributes.strokeLinejoin "round"
        --, Svg.Attributes.strokeWidth "2"
        , Svg.Attributes.viewBox string
        , Svg.Attributes.width <| String.fromInt size
        ]
        >> Element.html
        >> Element.el []
