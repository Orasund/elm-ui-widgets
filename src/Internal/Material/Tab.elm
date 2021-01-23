module Internal.Material.Tab exposing (tab, tabButton)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Internal.Material.Button as Button
import Internal.Material.Palette exposing (Palette)
import Widget.Style
    exposing
        ( ButtonStyle
        , TabStyle
        )
import Widget.Style.Material.Color as MaterialColor
import Widget.Style.Material.Typography as Typography


tabButton : Palette -> ButtonStyle msg
tabButton palette =
    { elementButton =
        Typography.button
            ++ [ Element.height <| Element.px 48
               , Element.fill
                    |> Element.maximum 360
                    |> Element.minimum 90
                    |> Element.width
               , Element.paddingXY 12 16
               , Font.color <| MaterialColor.fromColor <| palette.primary
               , Element.mouseDown
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
               ]
    , ifDisabled =
        (Button.baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
                    |> MaterialColor.fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ Element.height <| Element.px 48
        , Border.widthEach
            { bottom = 2
            , left = 0
            , right = 0
            , top = 0
            }
        ]
    , otherwise =
        []
    , content =
        { elementRow =
            [ Element.spacing <| 8
            , Element.centerY
            , Element.centerX
            ]
        , content =
            { text = { contentText = [] }
            , icon =
                { ifActive =
                    { size = 18
                    , color = palette.primary
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = palette.primary
                    }
                }
            }
        }
    }


tab : Palette -> TabStyle msg
tab palette =
    { elementColumn = [ Element.spacing 8, Element.width <| Element.fill ]
    , content =
        { tabs =
            { elementRow =
                [ Element.spaceEvenly
                , Border.shadow <| MaterialColor.shadow 4
                , Element.spacing 8
                , Element.width <| Element.fill
                ]
            , content = tabButton palette
            }
        , content = [ Element.width <| Element.fill ]
        }
    }
