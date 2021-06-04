module Internal.Material.Item exposing
    ( expansionItem
    , fullBleedDivider
    , fullBleedHeader
    , fullBleedItem
    , imageItem
    , insetDivider
    , insetHeader
    , insetItem
    , middleDivider
    , multiLineItem
    , selectItem
    )

import Color
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attributes
import Internal.Button exposing (ButtonStyle)
import Internal.Item exposing (DividerStyle, ExpansionItemStyle, FullBleedItemStyle, HeaderStyle, ImageItemStyle, InsetItemStyle, ItemStyle, MultiLineItemStyle)
import Internal.Material.Button as Button
import Internal.Material.Icon as Icon
import Internal.Material.Palette as Palette exposing (Palette)
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


fullBleedDivider : Palette -> ItemStyle (DividerStyle msg) msg
fullBleedDivider palette =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.px 1
        , Element.padding 0
        , Border.width 0
        ]
    , content =
        { element =
            [ Element.width <| Element.fill
            , Element.height <| Element.px 1
            , Palette.lightGray palette
                |> MaterialColor.fromColor
                |> Background.color
            ]
        }
    }


insetDivider : Palette -> ItemStyle (DividerStyle msg) msg
insetDivider palette =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.px 1
        , Border.width 0
        , Element.paddingEach
            { bottom = 0
            , left = 72
            , right = 0
            , top = 0
            }
        ]
    , content =
        { element =
            [ Element.width <| Element.fill
            , Element.height <| Element.px 1
            , Palette.lightGray palette
                |> MaterialColor.fromColor
                |> Background.color
            ]
        }
    }


middleDivider : Palette -> ItemStyle (DividerStyle msg) msg
middleDivider palette =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.px 1
        , Border.width 0
        , Element.paddingEach
            { bottom = 0
            , left = 16
            , right = 16
            , top = 0
            }
        ]
    , content =
        { element =
            [ Element.width <| Element.fill
            , Element.height <| Element.px 1
            , Palette.lightGray palette
                |> MaterialColor.fromColor
                |> Background.color
            ]
        }
    }


insetHeader : Palette -> ItemStyle (HeaderStyle msg) msg
insetHeader palette =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.shrink
        , Border.width 0
        , Element.paddingEach
            { bottom = 0
            , left = 72
            , right = 0
            , top = 0
            }
        ]
    , content =
        { elementColumn =
            [ Element.width <| Element.fill
            , Element.spacing <| 12
            ]
        , content =
            { divider =
                insetDivider palette
                    |> .content
            , title =
                Typography.caption
                    ++ [ Palette.textGray palette
                            |> MaterialColor.fromColor
                            |> Font.color
                       ]
            }
        }
    }


fullBleedHeader : Palette -> ItemStyle (HeaderStyle msg) msg
fullBleedHeader palette =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.shrink
        , Element.padding 0
        , Border.widthEach
            { bottom = 0
            , left = 0
            , right = 0
            , top = 1
            }
        , Palette.lightGray palette
            |> MaterialColor.fromColor
            |> Border.color
        ]
    , content =
        { elementColumn =
            [ Element.width <| Element.fill
            , Element.spacing <| 8
            ]
        , content =
            { divider = { element = [] }
            , title =
                Typography.subtitle2
                    ++ [ Palette.gray palette
                            |> MaterialColor.fromColor
                            |> Font.color
                       , Element.paddingXY 16 8
                       ]
            }
        }
    }


fullBleedItem : Palette -> ItemStyle (FullBleedItemStyle msg) msg
fullBleedItem palette =
    let
        i =
            insetItem palette
    in
    { element = i.element
    , content =
        { elementButton = i.content.elementButton
        , ifDisabled = i.content.ifDisabled
        , otherwise = i.content.otherwise
        , content =
            { elementRow = i.content.content.elementRow
            , content =
                { text = i.content.content.content.text
                , icon = i.content.content.content.content
                }
            }
        }
    }


insetItem : Palette -> ItemStyle (InsetItemStyle msg) msg
insetItem palette =
    { element = [ Element.padding 0 ]
    , content =
        { elementButton =
            [ Element.width Element.fill
            , Element.padding 16
            ]
        , ifDisabled =
            [ Element.mouseDown []
            , Element.mouseOver []
            , Element.focused []
            , Element.htmlAttribute <| Attributes.style "cursor" "default"
            ]
        , otherwise =
            [ Element.mouseDown <|
                [ Palette.gray palette
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.focused <|
                [ Palette.gray palette
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.mouseOver <|
                [ Palette.gray palette
                    |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            ]
        , content =
            { elementRow = [ Element.spacing 16, Element.width Element.fill ]
            , content =
                { text = { elementText = [ Element.width Element.fill ] }
                , icon =
                    { element =
                        [ Element.width <| Element.px 40
                        , Element.height <| Element.px 24
                        ]
                    , content =
                        { size = 24
                        , color = Palette.gray palette
                        }
                    }
                , content =
                    { size = 24
                    , color = Palette.gray palette
                    }
                }
            }
        }
    }


multiLineItem : Palette -> ItemStyle (MultiLineItemStyle msg) msg
multiLineItem palette =
    { element = [ Element.padding 0 ]
    , content =
        { elementButton =
            [ Element.width Element.fill
            , Element.padding 16
            ]
        , ifDisabled =
            [ Element.mouseDown []
            , Element.mouseOver []
            , Element.focused []
            , Element.htmlAttribute <| Attributes.style "cursor" "default"
            ]
        , otherwise =
            [ Element.mouseDown <|
                [ Palette.gray palette
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.focused <|
                [ Palette.gray palette
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.mouseOver <|
                [ Palette.gray palette
                    |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            ]
        , content =
            { elementRow = [ Element.spacing 16, Element.width Element.fill ]
            , content =
                { description =
                    { elementColumn =
                        [ Element.width Element.fill
                        , Element.spacing 4
                        ]
                    , content =
                        { title = { elementText = Typography.body1 }
                        , text =
                            { elementText =
                                Typography.body2
                                    ++ [ Palette.gray palette
                                            |> MaterialColor.fromColor
                                            |> Font.color
                                       ]
                            }
                        }
                    }
                , icon =
                    { element =
                        [ Element.width <| Element.px 40
                        , Element.height <| Element.px 24
                        ]
                    , content =
                        { size = 24
                        , color = Palette.textGray palette
                        }
                    }
                , content =
                    { size = 24
                    , color = Palette.textGray palette
                    }
                }
            }
        }
    }


imageItem : Palette -> ItemStyle (ImageItemStyle msg) msg
imageItem palette =
    { element = [ Element.padding 0 ]
    , content =
        { elementButton =
            [ Element.width Element.fill
            , Element.paddingXY 16 8
            ]
        , ifDisabled =
            [ Element.mouseDown []
            , Element.mouseOver []
            , Element.focused []
            , Element.htmlAttribute <| Attributes.style "cursor" "default"
            ]
        , otherwise =
            [ Element.mouseDown <|
                [ Palette.gray palette
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.focused <|
                [ Palette.gray palette
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.mouseOver <|
                [ Palette.gray palette
                    |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            ]
        , content =
            { elementRow = [ Element.spacing 16, Element.width Element.fill ]
            , content =
                { text =
                    { elementText =
                        [ Element.width Element.fill
                        ]
                    }
                , image =
                    { element =
                        [ Element.width <| Element.px 40
                        , Element.height <| Element.px 40
                        ]
                    }
                , content =
                    { size = 24
                    , color = Palette.gray palette
                    }
                }
            }
        }
    }


expansionItem : Palette -> ExpansionItemStyle msg
expansionItem palette =
    { item = insetItem palette
    , expandIcon = Icon.expand_more
    , collapseIcon = Icon.expand_less
    }


selectItem : Palette -> ItemStyle (ButtonStyle msg) msg
selectItem palette =
    { element = [ Element.paddingXY 8 4 ]
    , content =
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
                ++ [ Palette.gray palette
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
            { elementRow =
                [ Element.spacing <| 8
                , Element.width <| Element.minimum 32 <| Element.shrink
                , Element.centerY
                ]
            , content =
                { text =
                    { contentText = [ Element.centerX ]
                    }
                , icon =
                    { ifActive =
                        { size = 18
                        , color = palette.surface |> MaterialColor.accessibleTextColor
                        }
                    , ifDisabled =
                        { size = 18
                        , color = Palette.gray palette
                        }
                    , otherwise =
                        { size = 18
                        , color = palette.surface |> MaterialColor.accessibleTextColor
                        }
                    }
                }
            }
        }
    }
