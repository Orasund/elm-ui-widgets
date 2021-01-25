module Internal.Material.Icon exposing (icon)

import Element exposing (Element)
import Svg exposing (Svg)
import Svg.Attributes
import Color exposing (Color)

icon : {viewBox:String,size:Int,color:Color} -> List (Svg Never) -> Element Never
icon {viewBox,size,color} =
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
