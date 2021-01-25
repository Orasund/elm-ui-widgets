module Internal.Material.Layout exposing (drawerButton, layout, menu, menuTabButton, more_vert, search)

import Color
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Internal.Button exposing (ButtonStyle)
import Internal.Material.Button as Button
import Internal.Material.Icon as Icon
import Internal.Material.Palette exposing (Palette)
import Internal.Material.Snackbar as Snackbar
import Internal.Material.TextInput as TextInput
import Svg
import Svg.Attributes
import Widget.Icon as Icon exposing (Icon)
import Widget.Layout exposing (LayoutStyle)
import Widget.Style.Customize as Customize
import Widget.Style.Material.Color as MaterialColor
import Widget.Style.Material.Typography as Typography


more_vert : Icon
more_vert { size, color } =
    Icon.icon {viewBox = "0 0 48 48"
        , size = size
        , color = color
    }
        [ Svg.path
            [ Svg.Attributes.d "M24 16c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 4c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4zm0 12c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4z"
            ]
            []
        ]


search : Icon
search { size, color } =
    Icon.icon {viewBox = "0 0 48 48"
        , size = size
        , color = color
    }
        [ Svg.path
            [ Svg.Attributes.d "M31 28h-1.59l-.55-.55C30.82 25.18 32 22.23 32 19c0-7.18-5.82-13-13-13S6 11.82 6 19s5.82 13 13 13c3.23 0 6.18-1.18 8.45-3.13l.55.55V31l10 9.98L40.98 38 31 28zm-12 0c-4.97 0-9-4.03-9-9s4.03-9 9-9 9 4.03 9 9-4.03 9-9 9z"
            ]
            []
        ]


menu : Icon
menu { size, color } =
    Icon.icon {viewBox = "0 0 48 48"
        , size = size
        , color = color
    }
        [ Svg.path
            [ Svg.Attributes.d "M6 36h36v-4H6v4zm0-10h36v-4H6v4zm0-14v4h36v-4H6z"
            ]
            []
        ]


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


drawerButton : Palette -> ButtonStyle msg
drawerButton palette =
    { elementButton =
        [ Font.size 14
        , Font.semiBold
        , Font.letterSpacing 0.25
        , Element.height <| Element.px 36
        , Element.width <| Element.fill
        , Element.paddingXY 8 8
        , Border.rounded <| 4
        , palette.surface
            |> MaterialColor.accessibleTextColor
            |> MaterialColor.fromColor
            |> Font.color
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
        [ palette.primary
            |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
            |> MaterialColor.fromColor
            |> Background.color
        , palette.primary
            |> MaterialColor.fromColor
            |> Font.color
        ]
    , otherwise =
        []
    , content =
        { elementRow = Button.baseButton palette |> .content |> .elementRow
        , content =
            { text = { contentText = Button.baseButton palette |> (\b -> b.content.content.text.contentText) }
            , icon =
                { ifActive =
                    { size = 18
                    , color = palette.surface |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = palette.surface |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }


layout : Palette -> LayoutStyle msg
layout palette =
    { container =
        (palette.background |> MaterialColor.textAndBackground)
            ++ [ Font.family
                    [ Font.typeface "Roboto"
                    , Font.sansSerif
                    ]
               , Font.size 16
               , Font.letterSpacing 0.5
               ]
    , snackbar = Snackbar.snackbar palette
    , layout = Element.layout
    , header =
        (palette.primary
            |> MaterialColor.textAndBackground
        )
            ++ [ Element.height <| Element.px 56
               , Element.padding 16
               , Element.width <| Element.minimum 360 <| Element.fill
               ]
    , menuButton =
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
    , sheetButton = drawerButton palette
    , menuTabButton = menuTabButton palette
    , sheet =
        (palette.surface |> MaterialColor.textAndBackground)
            ++ [ Element.width <| Element.maximum 360 <| Element.fill
               , Element.padding 8
               , Element.spacing 8
               ]
    , menuIcon = menu
    , moreVerticalIcon = more_vert
    , spacing = 8
    , title = Typography.h6 ++ [ Element.paddingXY 8 0 ]
    , searchIcon = search
    , search = TextInput.searchInput palette
    , searchFill = TextInput.textInputBase palette
    }
