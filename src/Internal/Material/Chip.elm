module Internal.Material.Chip exposing (chip)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Internal.Material.Button as Button
import Internal.Material.Palette exposing (Palette)
import Widget.Style
    exposing
        ( ButtonStyle
        )
import Widget.Style.Material.Color as MaterialColor


chip : Palette -> ButtonStyle msg
chip palette =
    { elementButton =
        [ Element.height <| Element.px 32
        , Element.paddingEach
            { top = 0
            , right = 12
            , bottom = 0
            , left = 4
            }
        , Border.rounded <| 16
        , Element.mouseDown <|
            [ palette.on.surface
                |> MaterialColor.scaleOpacity 0.12
                |> MaterialColor.withShade palette.on.surface MaterialColor.buttonPressedOpacity
                |> MaterialColor.fromColor
                |> Background.color
            ]
        , Element.focused <|
            [ palette.on.surface
                |> MaterialColor.scaleOpacity 0.12
                |> MaterialColor.withShade palette.on.surface MaterialColor.buttonFocusOpacity
                |> MaterialColor.fromColor
                |> Background.color
            ]
        , Element.mouseOver <|
            [ palette.on.surface
                |> MaterialColor.scaleOpacity 0.12
                |> MaterialColor.withShade palette.on.surface MaterialColor.buttonHoverOpacity
                |> MaterialColor.fromColor
                |> Background.color
            ]
        ]
    , ifDisabled =
        (Button.baseButton palette |> .ifDisabled)
            ++ (palette.on.surface
                    |> MaterialColor.scaleOpacity 0.12
                    |> MaterialColor.withShade palette.on.surface MaterialColor.buttonDisabledOpacity
                    |> MaterialColor.textAndBackground
               )
            ++ [ Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.on.surface
            |> MaterialColor.scaleOpacity 0.12
            |> MaterialColor.withShade palette.on.surface MaterialColor.buttonSelectedOpacity
            |> MaterialColor.fromColor
            |> Background.color
        , palette.on.surface
            |> MaterialColor.scaleOpacity 0.12
            |> MaterialColor.accessibleTextColor
            |> MaterialColor.fromColor
            |> Font.color
        , Border.shadow <| MaterialColor.shadow 4
        ]
    , otherwise =
        [ palette.on.surface
            |> MaterialColor.scaleOpacity 0.12
            |> MaterialColor.fromColor
            |> Background.color
        , palette.on.surface
            |> MaterialColor.scaleOpacity 0.12
            |> MaterialColor.accessibleTextColor
            |> MaterialColor.fromColor
            |> Font.color
        ]
    , content =
        { elementRow = [ Element.spacing 0, Element.centerY ]
        , content =
            { text =
                { contentText =
                    [ Element.paddingEach
                        { top = 0
                        , right = 0
                        , bottom = 0
                        , left = 8
                        }
                    ]
                }
            , icon =
                { ifActive =
                    { size = 18
                    , color =
                        palette.on.surface
                            |> MaterialColor.scaleOpacity 0.12
                            |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 18
                    , color =
                        palette.on.surface
                            |> MaterialColor.scaleOpacity 0.12
                            |> MaterialColor.accessibleTextColor
                    }
                , otherwise =
                    { size = 18
                    , color =
                        palette.on.surface
                            |> MaterialColor.scaleOpacity 0.12
                            |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }
