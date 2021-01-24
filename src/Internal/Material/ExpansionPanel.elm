module Internal.Material.ExpansionPanel exposing
    ( expand_less
    , expand_more
    , expansionPanel
    , expansionPanelItem
    )

import Color
import Element
import Element.Background as Background
import Internal.ExpansionPanel exposing (ExpansionPanelStyle)
import Internal.List exposing (ItemStyle)
import Internal.Material.Icon as Icon
import Internal.Material.Palette exposing (Palette)
import Svg
import Svg.Attributes
import Widget.Icon as Icon exposing (Icon)
import Widget.Style.Customize as Customize
import Widget.Style.Material.Color as MaterialColor


expand_less : Icon
expand_less { size, color } =
    Icon.icon "0 0 48 48"
        size
        [ Svg.path
            [ Svg.Attributes.d "M24 16L12 28l2.83 2.83L24 21.66l9.17 9.17L36 28z"
            , Svg.Attributes.stroke (Color.toCssString color)
            ]
            []
        ]


expand_more : Icon
expand_more { size, color } =
    Icon.icon "0 0 48 48"
        size
        [ Svg.path
            [ Svg.Attributes.d "M33.17 17.17L24 26.34l-9.17-9.17L12 20l12 12 12-12z"
            , Svg.Attributes.stroke (Color.toCssString color)
            ]
            []
        ]


expansionPanel : Palette -> ExpansionPanelStyle msg
expansionPanel palette =
    expansionPanelItem palette
        |> .content
        |> Customize.mapContent
            (\record ->
                { record
                    | panel =
                        record.panel
                            |> Customize.elementRow
                                [ Element.height <| Element.px 48
                                , Element.padding 14
                                ]
                    , content =
                        record.content
                            |> Customize.element
                                [ Element.paddingEach
                                    { top = 0
                                    , right = 14
                                    , bottom = 14
                                    , left = 14
                                    }
                                ]
                }
            )


expansionPanelItem : Palette -> ItemStyle (ExpansionPanelStyle msg)
expansionPanelItem palette =
    { element = []
    , content =
        { elementColumn =
            [ Background.color <| MaterialColor.fromColor <| palette.surface
            , Element.spacing 14
            , Element.width <| Element.fill
            ]
        , content =
            { panel =
                { elementRow =
                    [ Element.spaceEvenly
                    , Element.width <| Element.fill
                    ]
                , content =
                    { label =
                        { elementRow = [ Element.spacing 32 ]
                        , content =
                            { icon =
                                { size = 16
                                , color = MaterialColor.gray
                                }
                            , text = { elementText = [] }
                            }
                        }
                    , expandIcon = expand_more
                    , collapseIcon = expand_less
                    , icon =
                        { size = 24
                        , color = MaterialColor.gray
                        }
                    }
                }
            , content =
                { element = [ Element.width <| Element.fill ]
                }
            }
        }
    }
