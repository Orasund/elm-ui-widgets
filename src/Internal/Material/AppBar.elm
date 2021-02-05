module Internal.Material.AppBar exposing (menuBar, tabBar)

import Element exposing (Attribute)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Internal.AppBar exposing (AppBarStyle)
import Internal.Button exposing (ButtonStyle)
import Internal.Material.Button as Button
import Internal.Material.Icon as Icon
import Internal.Material.Palette exposing (Palette)
import Internal.Material.TextInput as TextInput
import Widget.Customize as Customize
import Widget.Icon as Icon exposing (Icon)
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


menuTabButton : Palette -> ButtonStyle msg
menuTabButton palette =
    { elementButton =
        Typography.button
            ++ [ Element.height <| Element.px 56
               , Element.fill
                    |> Element.maximum 360
                    |> Element.minimum 90
                    |> Element.width
               , Element.paddingXY 12 16
               , palette.primary
                    |> MaterialColor.accessibleTextColor
                    |> MaterialColor.fromColor
                    |> Font.color
               , Element.alignBottom
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
        [ Border.widthEach
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
                    , color = palette.primary |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = palette.primary |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }


menuBar :
    Palette
    ->
        AppBarStyle
            { menuIcon : Icon msg
            , title : List (Attribute msg)
            }
            msg
menuBar =
    internalBar
        { menuIcon = Icon.menu
        , title = Typography.h6 ++ [ Element.paddingXY 8 0 ]
        }


tabBar :
    Palette
    ->
        AppBarStyle
            { menuTabButton : ButtonStyle msg
            , title : List (Attribute msg)
            }
            msg
tabBar palette =
    internalBar
        { menuTabButton = menuTabButton palette
        , title = Typography.h6 ++ [ Element.paddingXY 8 0 ]
        }
        palette


internalBar : content -> Palette -> AppBarStyle content msg
internalBar content palette =
    { elementRow =
        (palette.primary
            |> MaterialColor.textAndBackground
        )
            ++ [ Element.padding 0
               , Element.spacing 8
               , Element.height <| Element.px 56
               , Element.width <| Element.minimum 360 <| Element.fill
               ]
    , content =
        { menu =
            { elementRow =
                [ Element.width <| Element.shrink
                , Element.spacing 8
                ]
            , content = content
            }
        , search = TextInput.searchInput palette
        , actions =
            { elementRow =
                [ Element.alignRight
                , Element.width Element.shrink
                ]
            , content =
                { button =
                    Button.iconButton palette
                        |> Customize.mapContent
                            (Customize.mapContent
                                (\record ->
                                    { record
                                        | icon =
                                            { ifActive =
                                                { size = record.icon.ifActive.size
                                                , color =
                                                    palette.primary
                                                        |> MaterialColor.accessibleTextColor
                                                }
                                            , ifDisabled =
                                                record.icon.ifDisabled
                                            , otherwise =
                                                { size = record.icon.otherwise.size
                                                , color =
                                                    palette.primary
                                                        |> MaterialColor.accessibleTextColor
                                                }
                                            }
                                    }
                                )
                            )
                , searchIcon = Icon.search
                , moreVerticalIcon = Icon.more_vert
                }
            }
        }
    }
