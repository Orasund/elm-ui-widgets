module Internal.Material.Dialog exposing (alertDialog)

import Element
import Element.Background as Background
import Element.Border as Border
import Internal.Dialog exposing (DialogStyle)
import Internal.Material.Button as Button
import Internal.Material.Palette exposing (Palette)
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


alertDialog : Palette -> DialogStyle msg
alertDialog palette =
    { elementColumn =
        [ Border.rounded 4
        , Element.fill
            |> Element.maximum 560
            |> Element.minimum 280
            |> Element.width
        , Element.height <| Element.minimum 182 <| Element.shrink
        , Background.color <| MaterialColor.fromColor <| palette.surface
        ]
    , content =
        { title =
            { contentText = Typography.h6 ++ [ Element.paddingXY 24 20 ]
            }
        , text =
            { contentText = [ Element.paddingXY 24 0 ]
            }
        , buttons =
            { elementRow =
                [ Element.paddingXY 8 8
                , Element.spacing 8
                , Element.alignRight
                , Element.alignBottom
                ]
            , content =
                { accept = Button.containedButton palette
                , dismiss = Button.textButton palette
                }
            }
        }
    }
