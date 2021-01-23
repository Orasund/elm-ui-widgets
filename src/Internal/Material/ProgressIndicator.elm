module Internal.Material.ProgressIndicator exposing (determinateCircularIcon, indeterminateCircularIcon, progressIndicator)

import Color
import Element exposing (Attribute, Element)
import Internal.Material.Palette exposing (Palette)
import Svg
import Svg.Attributes
import Widget.Style
    exposing
        ( ProgressIndicatorStyle
        )


indeterminateCircularIcon : Color.Color -> List (Attribute msg) -> Element msg
indeterminateCircularIcon color attribs =
    -- Based on example at https://codepen.io/FezVrasta/pen/oXrgdR
    Svg.svg
        [ Svg.Attributes.height "48px"
        , Svg.Attributes.width "48px"
        , Svg.Attributes.viewBox "0 0 66 66"
        , Svg.Attributes.xmlSpace "http://www.w3.org/2000/svg"
        ]
        [ Svg.g []
            [ Svg.animateTransform
                [ Svg.Attributes.attributeName "transform"
                , Svg.Attributes.type_ "rotate"
                , Svg.Attributes.values "0 33 33;270 33 33"
                , Svg.Attributes.begin "0s"
                , Svg.Attributes.dur "1.4s"
                , Svg.Attributes.fill "freeze"
                , Svg.Attributes.repeatCount "indefinite"
                ]
                []
            , Svg.circle
                [ Svg.Attributes.fill "none"
                , Svg.Attributes.stroke (Color.toCssString color)
                , Svg.Attributes.strokeWidth "5"
                , Svg.Attributes.strokeLinecap "square"
                , Svg.Attributes.cx "33"
                , Svg.Attributes.cy "33"
                , Svg.Attributes.r "30"
                , Svg.Attributes.strokeDasharray "187"
                , Svg.Attributes.strokeDashoffset "610"
                ]
                [ Svg.animateTransform
                    [ Svg.Attributes.attributeName "transform"
                    , Svg.Attributes.type_ "rotate"
                    , Svg.Attributes.values "0 33 33;135 33 33;450 33 33"
                    , Svg.Attributes.begin "0s"
                    , Svg.Attributes.dur "1.4s"
                    , Svg.Attributes.fill "freeze"
                    , Svg.Attributes.repeatCount "indefinite"
                    ]
                    []
                , Svg.animate
                    [ Svg.Attributes.attributeName "stroke-dashoffset"
                    , Svg.Attributes.values "187;46.75;187"
                    , Svg.Attributes.begin "0s"
                    , Svg.Attributes.dur "1.4s"
                    , Svg.Attributes.fill "freeze"
                    , Svg.Attributes.repeatCount "indefinite"
                    ]
                    []
                ]
            ]
        ]
        |> Element.html
        |> Element.el attribs


determinateCircularIcon : Color.Color -> List (Attribute msg) -> Float -> Element msg
determinateCircularIcon color attribs progress =
    -- With help from https://css-tricks.com/building-progress-ring-quickly/
    let
        strokeDashoffset =
            let
                clampedProgress =
                    clamp 0 1 progress
            in
            -- 188 is circumference of circle in pixels
            188
                - (188 * clampedProgress)
                |> round
    in
    Svg.svg
        [ Svg.Attributes.height "48px"
        , Svg.Attributes.width "48px"
        , Svg.Attributes.viewBox "0 0 66 66"
        , Svg.Attributes.xmlSpace "http://www.w3.org/2000/svg"
        ]
        [ Svg.g []
            [ Svg.circle
                [ Svg.Attributes.fill "none"
                , Svg.Attributes.stroke (Color.toCssString color)
                , Svg.Attributes.strokeWidth "5"
                , Svg.Attributes.strokeLinecap "butt"
                , Svg.Attributes.cx "33"
                , Svg.Attributes.cy "33"
                , Svg.Attributes.r "30"
                , Svg.Attributes.strokeDasharray "188 188"
                , Svg.Attributes.strokeDashoffset (String.fromInt strokeDashoffset)
                , Svg.Attributes.transform "rotate(-90 33 33)"
                ]
                []
            ]
        ]
        |> Element.html
        |> Element.el attribs


{-| A circular progress indicator
-}
progressIndicator : Palette -> ProgressIndicatorStyle msg
progressIndicator palette =
    { elementFunction =
        \maybeProgress ->
            case maybeProgress of
                Nothing ->
                    indeterminateCircularIcon palette.primary []

                Just progress ->
                    determinateCircularIcon palette.primary [] progress
    }
