module Internal.Material.Chip exposing (chip)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Internal.Button exposing (ButtonStyle)
import Internal.Material.Button as Button
import Internal.Material.Palette as Palette exposing (Palette)
import Widget.Material.Color as MaterialColor


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
            [ palette
                |> Palette.lightGray
                |> MaterialColor.withShade palette.on.surface MaterialColor.buttonPressedOpacity
                |> MaterialColor.fromColor
                |> Background.color
            ]
        , Element.focused <|
            [ palette
                |> Palette.lightGray
                |> MaterialColor.withShade palette.on.surface MaterialColor.buttonFocusOpacity
                |> MaterialColor.fromColor
                |> Background.color
            ]
        , Element.mouseOver <|
            [ palette
                |> Palette.lightGray
                |> MaterialColor.withShade palette.on.surface MaterialColor.buttonHoverOpacity
                |> MaterialColor.fromColor
                |> Background.color
            ]
        ]
    , ifDisabled =
        (Button.baseButton palette |> .ifDisabled)
            ++ (palette
                    |> Palette.lightGray
                    |> MaterialColor.withShade palette.on.surface MaterialColor.buttonDisabledOpacity
                    |> MaterialColor.textAndBackground
               )
            ++ [ Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette
            |> Palette.lightGray
            |> MaterialColor.withShade palette.on.surface MaterialColor.buttonSelectedOpacity
            |> MaterialColor.fromColor
            |> Background.color
        , palette
            |> Palette.lightGray
            |> MaterialColor.accessibleTextColor
            |> MaterialColor.fromColor
            |> Font.color
        , Border.shadow <| MaterialColor.shadow 4
        ]
    , otherwise =
        [ palette
            |> Palette.lightGray
            |> MaterialColor.fromColor
            |> Background.color
        , palette
            |> Palette.lightGray
            |> MaterialColor.accessibleTextColor
            |> MaterialColor.fromColor
            |> Font.color
        ]
    , content =
        { elementRow =
            [ Element.spacing 8
            , Element.paddingEach
                { top = 0
                , right = 0
                , bottom = 0
                , left = 8
                }
            , Element.centerY
            ]
        , content =
            { text =
                { contentText =
                    []
                }
            , icon =
                { ifActive =
                    { size = 18
                    , color =
                        palette
                            |> Palette.lightGray
                            |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 18
                    , color =
                        palette
                            |> Palette.lightGray
                            |> MaterialColor.accessibleTextColor
                    }
                , otherwise =
                    { size = 18
                    , color =
                        palette
                            |> Palette.lightGray
                            |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }
