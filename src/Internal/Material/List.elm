module Internal.Material.List exposing
    ( buttonRow
    , cardColumn
    , column
    , fullBleedDivider
    , fullBleedTitle
    , insetDivider
    , insetTitle
    , middleDividers
    , row
    )

import Color
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Internal.Material.Palette exposing (Palette)
import Widget.Style
    exposing
        ( ColumnStyle
        , DividerStyle
        , ItemStyle
        , RowStyle
        , TitleStyle
        )
import Widget.Style.Material.Color as MaterialColor
import Widget.Style.Material.Typography as Typography


row : RowStyle msg
row =
    { elementRow =
        [ Element.paddingXY 0 8
        , Element.spacing 8
        ]
    , content =
        { element = []
        , ifSingleton = []
        , ifFirst = []
        , ifLast = []
        , otherwise = []
        }
    }


column : ColumnStyle msg
column =
    { elementColumn =
        [ Element.paddingXY 0 8
        , Element.spacing 8
        ]
    , content =
        { element = []
        , ifSingleton = []
        , ifFirst = []
        , ifLast = []
        , otherwise = []
        }
    }


fullBleedDivider : ItemStyle (DividerStyle msg)
fullBleedDivider =
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


middleDividers : Palette -> ItemStyle (DividerStyle msg)
middleDividers _ =
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


insetTitle : Palette -> ItemStyle (TitleStyle msg)
insetTitle palette =
    { element =
        [ Element.width <| Element.fill
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


fullBleedTitle : Palette -> ItemStyle (TitleStyle msg)
fullBleedTitle palette =
    { element =
        [ Element.width <| Element.fill
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


buttonRow : RowStyle msg
buttonRow =
    { elementRow = []
    , content =
        { element = []
        , ifSingleton =
            [ Border.rounded 2
            ]
        , ifFirst =
            [ Border.roundEach
                { topLeft = 2
                , topRight = 0
                , bottomLeft = 2
                , bottomRight = 0
                }
            ]
        , ifLast =
            [ Border.roundEach
                { topLeft = 0
                , topRight = 2
                , bottomLeft = 0
                , bottomRight = 2
                }
            ]
        , otherwise =
            [ Border.rounded 0
            ]
        }
    }


cardColumn : Palette -> ColumnStyle msg
cardColumn palette =
    { elementColumn =
        [ Element.width <| Element.fill
        , Element.mouseOver <|
            [ Border.shadow <| MaterialColor.shadow 4 ]
        , Element.alignTop
        , Border.rounded 4
        ]
    , content =
        { element =
            [ Element.padding 16
            , palette.surface
                |> MaterialColor.fromColor
                |> Background.color
            , palette.surface
                |> MaterialColor.accessibleTextColor
                |> MaterialColor.fromColor
                |> Font.color
            , palette.on.surface
                |> MaterialColor.scaleOpacity 0.14
                |> MaterialColor.fromColor
                |> Border.color
            , Element.width <| Element.minimum 344 <| Element.fill
            ]
        , ifSingleton =
            [ Border.rounded 4
            ]
        , ifFirst =
            [ Border.roundEach
                { topLeft = 4
                , topRight = 4
                , bottomLeft = 0
                , bottomRight = 0
                }
            , Border.widthEach
                { top = 1
                , left = 1
                , right = 1
                , bottom = 0
                }
            ]
        , ifLast =
            [ Border.roundEach
                { topLeft = 0
                , topRight = 0
                , bottomLeft = 4
                , bottomRight = 4
                }
            , Border.widthEach
                { top = 0
                , left = 1
                , right = 1
                , bottom = 1
                }
            ]
        , otherwise =
            [ Border.rounded 0
            , Border.widthEach
                { top = 0
                , left = 1
                , right = 1
                , bottom = 0
                }
            ]
        }
    }
