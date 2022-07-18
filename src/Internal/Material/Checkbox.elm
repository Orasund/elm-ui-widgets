module Internal.Material.Checkbox exposing (checkbox)

import Color
import Element exposing (Attribute, Decoration)
import Element.Background as Background
import Element.Border as Border
import Internal.Checkbox exposing (CheckboxStyle)
import Internal.Material.Palette as Palette exposing (Palette)
import Svg exposing (Svg, g, line, polygon, polyline, rect, svg, text, use)
import Svg.Attributes as A exposing (baseProfile, clipRule, cx, cy, d, enableBackground, fill, fillOpacity, fillRule, id, overflow, points, r, x1, x2, xlinkHref, y1, y2)
import Widget.Material.Color as MaterialColor


checkbox : Palette -> CheckboxStyle msg
checkbox palette =
    let
        rounded : Bool -> Float -> Color.Color -> List Decoration
        rounded bg opacity color =
            let
                scaledColor =
                    MaterialColor.fromColor <|
                        MaterialColor.scaleOpacity opacity color
            in
            Border.shadow
                { offset = ( 0, 0 )
                , size = 10
                , blur = 0
                , color = scaledColor
                }
                :: (if bg then
                        [ Background.color scaledColor ]

                    else
                        []
                   )

        check visible =
            Element.inFront
                (Element.el
                    [ Border.color <| MaterialColor.fromColor palette.on.primary
                    , Element.transparent (not visible)
                    , Element.height (Element.px 7)
                    , Element.width (Element.px 11)
                    , Element.rotate (degrees -45)
                    , Element.centerX
                    , Element.centerY
                    , Element.moveUp 2
                    , Border.widthEach
                        { top = 0
                        , left = 2
                        , bottom = 2
                        , right = 0
                        }
                    ]
                    Element.none
                )
    in
    { elementButton =
        [ Element.width <| Element.px 16
        , Element.height <| Element.px 16
        , Border.rounded 2
        , Border.width 2
        , Element.focused <| rounded True MaterialColor.buttonHoverOpacity palette.on.surface
        ]
    , ifDisabled =
        [ Border.color <|
            MaterialColor.fromColor <|
                MaterialColor.scaleOpacity MaterialColor.buttonDisabledOpacity palette.on.surface
        , check False
        ]
    , ifSelected =
        [ Border.color <| MaterialColor.fromColor palette.primary
        , Background.color <| MaterialColor.fromColor palette.primary
        , Element.mouseDown <| rounded False MaterialColor.buttonPressedOpacity palette.primary
        , Element.focused <| rounded False MaterialColor.buttonFocusOpacity palette.primary
        , Element.mouseOver <| rounded False MaterialColor.buttonHoverOpacity palette.primary
        , check True
        ]
    , ifDisabledSelected =
        [ Border.color <|
            MaterialColor.fromColor <|
                MaterialColor.scaleOpacity MaterialColor.buttonDisabledOpacity palette.on.surface
        , Background.color <|
            MaterialColor.fromColor <|
                MaterialColor.scaleOpacity MaterialColor.buttonDisabledOpacity palette.on.surface
        , Element.mouseDown <| rounded False MaterialColor.buttonPressedOpacity palette.on.surface
        , Element.focused <| rounded False MaterialColor.buttonFocusOpacity palette.on.surface
        , Element.mouseOver <| rounded False MaterialColor.buttonHoverOpacity palette.on.surface
        , check True
        ]
    , otherwise =
        [ Border.color <|
            MaterialColor.fromColor <|
                Palette.gray palette
        , Element.mouseDown <| rounded True MaterialColor.buttonPressedOpacity palette.on.surface
        , Element.focused <| rounded True MaterialColor.buttonFocusOpacity palette.on.surface
        , Element.mouseOver <| rounded True MaterialColor.buttonHoverOpacity palette.on.surface
        , check False
        ]
    }
