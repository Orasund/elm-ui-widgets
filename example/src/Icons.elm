module Icons exposing
    ( book
    , chevronDown
    , chevronLeft
    , chevronRight
    , chevronUp
    , circle
    , github
    , menu
    , moreVertical
    , penTool
    , repeat
    , search
    , slash
    , square
    , triangle
    )

import Html exposing (Html)
import Svg exposing (Svg, svg)
import Svg.Attributes as Attributes


svgFeatherIcon : String -> List (Svg msg) -> Html msg
svgFeatherIcon className =
    svg
        [ Attributes.class <| "feather feather-" ++ className
        , Attributes.fill "none"
        , Attributes.height "16"
        , Attributes.stroke "currentColor"
        , Attributes.strokeLinecap "round"
        , Attributes.strokeLinejoin "round"
        , Attributes.strokeWidth "2"
        , Attributes.viewBox "0 0 24 24"
        , Attributes.width "16"
        ]


chevronDown : Html msg
chevronDown =
    svgFeatherIcon "chevron-down"
        [ Svg.polyline [ Attributes.points "6 9 12 15 18 9" ] []
        ]


chevronRight : Html msg
chevronRight =
    svgFeatherIcon "chevron-right"
        [ Svg.polyline [ Attributes.points "9 18 15 12 9 6" ] []
        ]


chevronLeft : Html msg
chevronLeft =
    svgFeatherIcon "chevron-left"
        [ Svg.polyline [ Attributes.points "15 18 9 12 15 6" ] []
        ]


chevronUp : Html msg
chevronUp =
    svgFeatherIcon "chevron-up"
        [ Svg.polyline [ Attributes.points "18 15 12 9 6 15" ] []
        ]


repeat : Html msg
repeat =
    svgFeatherIcon "repeat"
        [ Svg.polyline [ Attributes.points "17 1 21 5 17 9" ] []
        , Svg.path [ Attributes.d "M3 11V9a4 4 0 0 1 4-4h14" ] []
        , Svg.polyline [ Attributes.points "7 23 3 19 7 15" ] []
        , Svg.path [ Attributes.d "M21 13v2a4 4 0 0 1-4 4H3" ] []
        ]


penTool : Html msg
penTool =
    svgFeatherIcon "pen-tool"
        [ Svg.path [ Attributes.d "M12 19l7-7 3 3-7 7-3-3z" ] []
        , Svg.path [ Attributes.d "M18 13l-1.5-7.5L2 2l3.5 14.5L13 18l5-5z" ] []
        , Svg.path [ Attributes.d "M2 2l7.586 7.586" ] []
        , Svg.circle
            [ Attributes.cx "11"
            , Attributes.cy "11"
            , Attributes.r "2"
            ]
            []
        ]


book : Html msg
book =
    svgFeatherIcon "book"
        [ Svg.path [ Attributes.d "M4 19.5A2.5 2.5 0 0 1 6.5 17H20" ] []
        , Svg.path [ Attributes.d "M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" ] []
        ]


github : Html msg
github =
    svgFeatherIcon "github"
        [ Svg.path [ Attributes.d "M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22" ] []
        ]


menu : Html msg
menu =
    svgFeatherIcon "menu"
        [ Svg.line
            [ Attributes.x1 "3"
            , Attributes.y1 "12"
            , Attributes.x2 "21"
            , Attributes.y2 "12"
            ]
            []
        , Svg.line
            [ Attributes.x1 "3"
            , Attributes.y1 "6"
            , Attributes.x2 "21"
            , Attributes.y2 "6"
            ]
            []
        , Svg.line
            [ Attributes.x1 "3"
            , Attributes.y1 "18"
            , Attributes.x2 "21"
            , Attributes.y2 "18"
            ]
            []
        ]


moreVertical : Html msg
moreVertical =
    svgFeatherIcon "more-vertical"
        [ Svg.circle [ Attributes.cx "12", Attributes.cy "12", Attributes.r "1" ] []
        , Svg.circle [ Attributes.cx "12", Attributes.cy "5", Attributes.r "1" ] []
        , Svg.circle [ Attributes.cx "12", Attributes.cy "19", Attributes.r "1" ] []
        ]


circle : Html msg
circle =
    svgFeatherIcon "circle"
        [ Svg.circle [ Attributes.cx "12", Attributes.cy "12", Attributes.r "10" ] []
        ]


slash : Html msg
slash =
    svgFeatherIcon "slash"
        [ Svg.circle
            [ Attributes.cx "12"
            , Attributes.cy "12"
            , Attributes.r "10"
            ]
            []
        , Svg.line
            [ Attributes.x1 "4.93"
            , Attributes.y1 "4.93"
            , Attributes.x2 "19.07"
            , Attributes.y2 "19.07"
            ]
            []
        ]


triangle : Html msg
triangle =
    svgFeatherIcon "triangle"
        [ Svg.path [ Attributes.d "M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" ] []
        ]


square : Html msg
square =
    svgFeatherIcon "square"
        [ Svg.rect
            [ Attributes.x "3"
            , Attributes.y "3"
            , Attributes.width "18"
            , Attributes.height "18"
            , Attributes.rx "2"
            , Attributes.ry "2"
            ]
            []
        ]


search : Html msg
search =
    svgFeatherIcon "search"
        [ Svg.circle
            [ Attributes.cx "11"
            , Attributes.cy "11"
            , Attributes.r "8"
            ]
            []
        , Svg.line
            [ Attributes.x1 "21"
            , Attributes.y1 "21"
            , Attributes.x2 "16.65"
            , Attributes.y2 "16.65"
            ]
            []
        ]
