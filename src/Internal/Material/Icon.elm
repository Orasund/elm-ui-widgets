module Internal.Material.Icon exposing (expand_less, expand_more, icon, menu, more_vert, search)

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


menu : Icon msg
menu { size, color } =
    icon
        { viewBox = "0 0 48 48"
        , size = size
        , color = color
        }
        [ Svg.path
            [ Svg.Attributes.d "M6 36h36v-4H6v4zm0-10h36v-4H6v4zm0-14v4h36v-4H6z"
            ]
            []
        ]


more_vert : Icon msg
more_vert { size, color } =
    icon
        { viewBox = "0 0 48 48"
        , size = size
        , color = color
        }
        [ Svg.path
            [ Svg.Attributes.d "M24 16c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 4c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4zm0 12c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4z"
            ]
            []
        ]


search : Icon msg
search { size, color } =
    icon
        { viewBox = "0 0 48 48"
        , size = size
        , color = color
        }
        [ Svg.path
            [ Svg.Attributes.d "M31 28h-1.59l-.55-.55C30.82 25.18 32 22.23 32 19c0-7.18-5.82-13-13-13S6 11.82 6 19s5.82 13 13 13c3.23 0 6.18-1.18 8.45-3.13l.55.55V31l10 9.98L40.98 38 31 28zm-12 0c-4.97 0-9-4.03-9-9s4.03-9 9-9 9 4.03 9 9-4.03 9-9 9z"
            ]
            []
        ]


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
