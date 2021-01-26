module Internal.Material.Snackbar exposing (snackbar)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Internal.Material.Button as Button
import Internal.Material.Palette exposing (Palette)
import Widget.Customize as Customize
import Widget.Material.Color as MaterialColor
import Widget.Snackbar exposing (SnackbarStyle)


snackbar : Palette -> SnackbarStyle msg
snackbar palette =
    { elementRow =
        [ MaterialColor.dark
            |> MaterialColor.fromColor
            |> Background.color
        , MaterialColor.dark
            |> MaterialColor.accessibleTextColor
            |> MaterialColor.fromColor
            |> Font.color
        , Border.rounded 4
        , Element.width <| Element.maximum 344 <| Element.fill
        , Element.paddingXY 8 6
        , Element.spacing 8
        , Border.shadow <| MaterialColor.shadow 2
        ]
    , content =
        { text =
            { elementText =
                [ Element.centerX
                , Element.paddingXY 10 8
                ]
            }
        , button =
            Button.textButton palette
                |> Customize.elementButton
                    [ MaterialColor.dark
                        |> MaterialColor.accessibleWithTextColor palette.primary
                        |> MaterialColor.fromColor
                        |> Font.color
                    ]
        }
    }
