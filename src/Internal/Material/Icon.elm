module Internal.Material.Icon exposing (expand_less, expand_more, icon)

import Color exposing (Color)
import Element exposing (Element)
import Svg exposing (Svg)
import Svg.Attributes
import Widget.Icon exposing (Icon)


icon : { viewBox : String, size : Int, color : Color } -> List (Svg msg) -> Element msg
icon { viewBox, size, color } =
    Svg.svg
        [ Svg.Attributes.height <| String.fromInt size
        , Svg.Attributes.stroke <| Color.toCssString <| color
        , Svg.Attributes.fill <| Color.toCssString <| color

        --, Svg.Attributes.strokeLinecap "round"
        --, Svg.Attributes.strokeLinejoin "round"
        --, Svg.Attributes.strokeWidth "2"
        , Svg.Attributes.viewBox viewBox
        , Svg.Attributes.width <| String.fromInt size
        ]
        >> Element.html
        >> Element.el []


expand_less : Icon msg
expand_less { size, color } =
    icon
        { viewBox = "0 0 48 48"
        , size = size
        , color = color
        }
        [ Svg.path
            [ Svg.Attributes.d "M24 16L12 28l2.83 2.83L24 21.66l9.17 9.17L36 28z"
            ]
            []
        ]


expand_more : Icon msg
expand_more { size, color } =
    icon
        { viewBox = "0 0 48 48"
        , size = size
        , color = color
        }
        [ Svg.path
            [ Svg.Attributes.d "M33.17 17.17L24 26.34l-9.17-9.17L12 20l12 12 12-12z"
            ]
            []
        ]
