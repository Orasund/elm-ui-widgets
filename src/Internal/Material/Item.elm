module Internal.Material.Item exposing
    ( expansionItem
    , fullBleedDivider
    , fullBleedHeader
    , insetDivider
    , insetHeader
    , middleDivider
    , textItem
    )

import Color
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attributes
import Internal.Item exposing (DividerStyle, ExpansionItemStyle, HeaderStyle, ItemStyle, TextItemStyle)
import Internal.Material.Icon as Icon
import Internal.Material.Palette exposing (Palette)
import Svg
import Svg.Attributes
import Widget.Icon exposing (Icon)
import Widget.Style.Material.Color as MaterialColor
import Widget.Style.Material.Typography as Typography


fullBleedDivider : Palette -> ItemStyle (DividerStyle msg)
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


insetDivider : Palette -> ItemStyle (DividerStyle msg)
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


middleDivider : Palette -> ItemStyle (DividerStyle msg)
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


insetHeader : Palette -> ItemStyle (HeaderStyle msg)
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


fullBleedHeader : Palette -> ItemStyle (HeaderStyle msg)
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


textItem : Palette -> ItemStyle (TextItemStyle msg)
textItem _ =
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


expand_less : Icon
expand_less { size, color } =
    Icon.icon {viewBox = "0 0 48 48"
        , size = size
        , color = color
    }
        [ Svg.path
            [ Svg.Attributes.d "M24 16L12 28l2.83 2.83L24 21.66l9.17 9.17L36 28z"

            ]
            []
        ]


expand_more : Icon
expand_more { size, color } =
    Icon.icon {viewBox = "0 0 48 48"
        , size = size
        , color = color
    }
        [ Svg.path
            [ Svg.Attributes.d "M33.17 17.17L24 26.34l-9.17-9.17L12 20l12 12 12-12z"

            ]
            []
        ]


expansionItem : Palette -> ExpansionItemStyle msg
expansionItem palette =
    { item = textItem palette
    , expandIcon = expand_more
    , collapseIcon = expand_less
    }
