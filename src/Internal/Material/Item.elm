module Internal.Material.Item exposing
    ( expansionItem
    , fullBleedDivider
    , fullBleedHeader
    , fullBleedItem
    , imageItem
    , insetDivider
    , insetHeader
    , middleDivider
    , multiLineItem
    , selectItem
    , insetItem
    )

import Color
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attributes
import Internal.Button exposing (ButtonStyle)
import Internal.Item exposing (DividerStyle, ExpansionItemStyle, FullBleedItemStyle, HeaderStyle, ImageItemStyle, ItemStyle, MultiLineItemStyle, InsetItemStyle)
import Internal.Material.Button as Button
import Internal.Material.Icon as Icon
import Internal.Material.Palette exposing (Palette)
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


fullBleedDivider : Palette -> ItemStyle (DividerStyle msg) msg
fullBleedDivider _ =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.px 1
        , Element.padding 0
        , Border.widthEach
            { bottom = 0
            , left = 1
            , right = 1
            , top = 0
            }
        ]
    , content =
        { element =
            [ Element.width <| Element.fill
            , Element.height <| Element.px 1
            , Color.gray
                |> MaterialColor.fromColor
                |> Background.color
            ]
        }
    }


insetDivider : Palette -> ItemStyle (DividerStyle msg) msg
insetDivider _ =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.px 1
        , Border.widthEach
            { bottom = 0
            , left = 1
            , right = 1
            , top = 0
            }
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
            , Color.gray
                |> MaterialColor.fromColor
                |> Background.color
            ]
        }
    }


middleDivider : Palette -> ItemStyle (DividerStyle msg) msg
middleDivider _ =
    { element =
        [ Element.width <| Element.fill
        , Element.height <| Element.px 1
        , Border.widthEach
            { bottom = 0
            , left = 1
            , right = 1
            , top = 0
            }
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
            , Color.gray
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
        , Border.widthEach
            { bottom = 0
            , left = 1
            , right = 1
            , top = 0
            }
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
                Typography.body2
                    ++ [ MaterialColor.gray
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
            , left = 1
            , right = 1
            , top = 0
            }
        ]
    , content =
        { elementColumn =
            [ Element.width <| Element.fill
            , Element.spacing <| 8
            ]
        , content =
            { divider =
                insetDivider palette
                    |> .content
            , title =
                Typography.caption
                    ++ [ MaterialColor.gray
                            |> MaterialColor.fromColor
                            |> Font.color
                       , Element.paddingXY 16 0
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
insetItem _ =
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
                [ MaterialColor.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.focused <|
                [ MaterialColor.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.mouseOver <|
                [ MaterialColor.gray
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
                        , color = MaterialColor.gray
                        }
                    }
                , content =
                    { size = 24
                    , color = MaterialColor.gray
                    }
                }
            }
        }
    }


multiLineItem : Palette -> ItemStyle (MultiLineItemStyle msg) msg
multiLineItem _ =
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
                [ MaterialColor.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.focused <|
                [ MaterialColor.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.mouseOver <|
                [ MaterialColor.gray
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
                                    ++ [ MaterialColor.gray
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
                        , color = MaterialColor.gray
                        }
                    }
                , content =
                    { size = 24
                    , color = MaterialColor.gray
                    }
                }
            }
        }
    }


imageItem : Palette -> ItemStyle (ImageItemStyle msg) msg
imageItem _ =
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
                [ MaterialColor.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.focused <|
                [ MaterialColor.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
                ]
            , Element.mouseOver <|
                [ MaterialColor.gray
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
                    , color = MaterialColor.gray
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
    }
