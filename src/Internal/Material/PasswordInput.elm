module Internal.Material.PasswordInput exposing (passwordInput, passwordInputBase)

import Element
import Element.Border as Border
import Internal.Material.Chip as Chip
import Internal.Material.Palette exposing (Palette)
import Internal.PasswordInput exposing (PasswordInputStyle)
import Widget.Customize as Customize
import Widget.Material.Color as MaterialColor


passwordInput : Palette -> PasswordInputStyle msg
passwordInput palette =
    { elementRow =
        (palette.surface
            |> MaterialColor.textAndBackground
        )
            ++ [ Element.spacing 8
               , Element.paddingXY 8 0
               , Border.width 1
               , Border.rounded 4
               , palette.on.surface
                    |> MaterialColor.scaleOpacity 0.14
                    |> MaterialColor.fromColor
                    |> Border.color
               , Element.focused
                    [ Border.shadow <| MaterialColor.shadow 4
                    , palette.primary
                        |> MaterialColor.fromColor
                        |> Border.color
                    ]
               , Element.mouseOver [ Border.shadow <| MaterialColor.shadow 2 ]
               , Element.width <| Element.px <| 280
               ]
    , content =
        { password =
            { elementPasswordInput =
                (palette.surface
                    |> MaterialColor.textAndBackground
                )
                    ++ [ Border.width 0
                       , Element.mouseOver []
                       , Element.focused []
                       , Element.centerY
                       ]
            }
        }
    }


passwordInputBase : Palette -> PasswordInputStyle msg
passwordInputBase palette =
    { elementRow =
        palette.surface
            |> MaterialColor.textAndBackground
    , content =
        { password =
            { elementPasswordInput =
                (palette.surface
                    |> MaterialColor.textAndBackground
                )
                    ++ [ Border.width 0
                       , Element.mouseOver []
                       , Element.focused []
                       ]
            }
        }
    }
