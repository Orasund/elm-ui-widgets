module Internal.Material.Switch exposing (switch)

import Color
import Element
import Element.Background as Background
import Element.Border as Border
import Html.Attributes as Attributes
import Internal.Material.Palette exposing (Palette)
import Internal.Switch exposing (SwitchStyle)
import Widget.Style.Material.Color as MaterialColor


switch : Palette -> SwitchStyle msg
switch palette =
    { elementButton =
        [ Element.height <| Element.px 38
        , Element.width <| Element.px 58
        , Element.mouseDown []
        , Element.focused []
        , Element.mouseOver []
        ]
    , content =
        { element =
            [ Element.height <| Element.px 14
            , Element.width <| Element.px 34
            , Border.rounded <| 10
            ]
        , ifDisabled =
            [ Element.htmlAttribute <| Attributes.style "cursor" "not-allowed"
            , palette.surface
                |> MaterialColor.withShade MaterialColor.gray (0.5 * MaterialColor.buttonDisabledOpacity)
                |> MaterialColor.fromColor
                |> Background.color
            ]
        , ifActive =
            [ palette.primary
                |> MaterialColor.scaleOpacity 0.5
                |> MaterialColor.fromColor
                |> Background.color
            ]
        , otherwise =
            [ MaterialColor.gray
                |> MaterialColor.scaleOpacity 0.5
                |> MaterialColor.fromColor
                |> Background.color
            ]
        }
    , contentInFront =
        { element =
            [ Element.height <| Element.px 38
            , Element.width <| Element.px 38
            , Border.rounded <| 19
            ]
        , ifDisabled =
            [ Element.htmlAttribute <| Attributes.style "cursor" "not-allowed" ]
        , ifActive =
            [ Element.mouseDown
                [ palette.primary
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.focused
                [ palette.primary
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.mouseOver
                [ palette.primary
                    |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.alignRight
            ]
        , otherwise =
            [ Element.mouseDown
                [ Color.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.focused
                [ Color.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.mouseOver
                [ Color.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.alignLeft
            ]
        , content =
            { element =
                [ Element.height <| Element.px 20
                , Element.width <| Element.px 20
                , Element.centerY
                , Element.centerX
                , Border.rounded <| 10
                , Border.shadow <| MaterialColor.shadow 2
                , palette.surface
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , ifDisabled =
                [ palette.surface
                    |> MaterialColor.withShade Color.gray MaterialColor.buttonDisabledOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                , Element.mouseDown []
                , Element.mouseOver []
                , Element.focused []
                ]
            , ifActive =
                [ palette.primary
                    |> MaterialColor.withShade palette.on.primary MaterialColor.buttonHoverOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , otherwise =
                [ palette.surface
                    |> MaterialColor.withShade palette.on.surface MaterialColor.buttonHoverOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            }
        }
    }
