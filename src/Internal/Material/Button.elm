module Internal.Material.Button exposing (baseButton, containedButton, iconButton, outlinedButton, textButton, toggleButton)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attributes
import Internal.Button exposing (ButtonStyle)
import Internal.Material.Palette exposing (Palette)
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


baseButton : Palette -> ButtonStyle msg
baseButton _ =
    { elementButton =
        Typography.button
            ++ [ Element.height <| Element.px 36
               , Element.paddingXY 8 8
               , Border.rounded <| 4
               ]
    , ifDisabled =
        [ Element.htmlAttribute <| Attributes.style "cursor" "not-allowed"
        ]
    , ifActive = []
    , otherwise = []
    , content =
        { elementRow =
            [ Element.spacing <| 8
            , Element.width <| Element.minimum 32 <| Element.shrink
            , Element.centerY
            ]
        , content =
            { text = { contentText = [ Element.centerX ] }
            , icon =
                { ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , ifActive =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                }
            }
        }
    }


{-| A contained button representing the most important action of a group.
-}
containedButton : Palette -> ButtonStyle msg
containedButton palette =
    { elementButton =
        (baseButton palette |> .elementButton)
            ++ [ Border.shadow <| MaterialColor.shadow 2
               , Element.mouseDown <|
                    [ palette.primary
                        |> MaterialColor.withShade palette.on.primary MaterialColor.buttonPressedOpacity
                        |> MaterialColor.fromColor
                        |> Background.color
                    , Border.shadow <| MaterialColor.shadow 12
                    ]
               , Element.focused <|
                    [ palette.primary
                        |> MaterialColor.withShade palette.on.primary MaterialColor.buttonFocusOpacity
                        |> MaterialColor.fromColor
                        |> Background.color
                    , Border.shadow <| MaterialColor.shadow 6
                    ]
               , Element.mouseOver <|
                    [ palette.primary
                        |> MaterialColor.withShade palette.on.primary MaterialColor.buttonHoverOpacity
                        |> MaterialColor.fromColor
                        |> Background.color
                    , Border.shadow <| MaterialColor.shadow 6
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
                    |> MaterialColor.scaleOpacity MaterialColor.buttonDisabledOpacity
                    |> MaterialColor.fromColor
                    |> Background.color
               , Font.color <| MaterialColor.fromColor <| MaterialColor.gray
               , Border.shadow <| MaterialColor.shadow 0
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.primary
            |> MaterialColor.withShade palette.on.primary MaterialColor.buttonHoverOpacity
            |> MaterialColor.fromColor
            |> Background.color
        , palette.primary
            |> MaterialColor.accessibleTextColor
            |> MaterialColor.fromColor
            |> Font.color
        ]
    , otherwise =
        [ palette.primary
            |> MaterialColor.fromColor
            |> Background.color
        , palette.primary
            |> MaterialColor.accessibleTextColor
            |> MaterialColor.fromColor
            |> Font.color
        ]
    , content =
        { elementRow =
            (baseButton palette |> .content |> .elementRow)
                ++ [ Element.paddingXY 8 0 ]
        , content =
            { text = { contentText = baseButton palette |> (\b -> b.content.content.text.contentText) }
            , icon =
                { ifActive =
                    { size = 18
                    , color =
                        palette.primary
                            |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 18
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 18
                    , color =
                        palette.primary
                            |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }


{-| A outlined button representing an important action within a group.
-}
outlinedButton : Palette -> ButtonStyle msg
outlinedButton palette =
    { elementButton =
        (baseButton palette |> .elementButton)
            ++ [ Border.width <| 1
               , Font.color <| MaterialColor.fromColor <| palette.primary
               , palette.on.surface
                    |> MaterialColor.scaleOpacity 0.14
                    |> MaterialColor.withShade palette.primary MaterialColor.buttonHoverOpacity
                    |> MaterialColor.fromColor
                    |> Border.color
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
        (baseButton palette |> .ifDisabled)
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
        ]
    , otherwise =
        []
    , content =
        { elementRow =
            (baseButton palette
                |> .content
                |> .elementRow
            )
                ++ [ Element.paddingXY 8 0 ]
        , content =
            { text =
                { contentText =
                    baseButton palette
                        |> .content
                        |> .content
                        |> .text
                        |> .contentText
                }
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


{-| A text button representing a simple action within a group.
-}
textButton : Palette -> ButtonStyle msg
textButton palette =
    { elementButton =
        (baseButton palette |> .elementButton)
            ++ [ Font.color <| MaterialColor.fromColor <| palette.primary
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
        (baseButton palette |> .ifDisabled)
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
        ]
    , otherwise =
        []
    , content =
        { elementRow = baseButton palette |> (\b -> b.content.elementRow)
        , content =
            { text = { contentText = baseButton palette |> (\b -> b.content.content.text.contentText) }
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


{-| A ToggleButton. Only use as a group in combination with `buttonRow`.

Toggle buttons should only be used with the `iconButton` widget, else use chips instead.

Technical Remark:

  - Border color was not defined in the [specification](https://material.io/components/buttons#toggle-button)
  - There are two different versions, one where the selected color is gray and another where the color is primary.
    I noticed the gray version was used more often, so i went with that one.

-}
toggleButton : Palette -> ButtonStyle msg
toggleButton palette =
    { elementButton =
        Typography.button
            ++ [ Element.width <| Element.px 48
               , Element.height <| Element.px 48
               , Element.padding 4
               , Border.width <| 1
               , Element.mouseDown <|
                    [ palette.surface
                        |> MaterialColor.withShade palette.on.surface MaterialColor.buttonPressedOpacity
                        |> MaterialColor.fromColor
                        |> Background.color
                    , palette.on.surface
                        |> MaterialColor.scaleOpacity 0.14
                        |> MaterialColor.withShade palette.on.surface MaterialColor.buttonPressedOpacity
                        |> MaterialColor.fromColor
                        |> Border.color
                    ]
               , Element.focused []
               , Element.mouseOver <|
                    [ palette.surface
                        |> MaterialColor.withShade palette.on.surface MaterialColor.buttonHoverOpacity
                        |> MaterialColor.fromColor
                        |> Background.color
                    , palette.on.surface
                        |> MaterialColor.scaleOpacity 0.14
                        |> MaterialColor.withShade palette.on.surface MaterialColor.buttonHoverOpacity
                        |> MaterialColor.fromColor
                        |> Border.color
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ palette.surface
                    |> MaterialColor.fromColor
                    |> Background.color
               , palette.on.surface
                    |> MaterialColor.scaleOpacity 0.14
                    |> MaterialColor.fromColor
                    |> Border.color
               , MaterialColor.gray
                    |> MaterialColor.fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               ]
    , ifActive =
        [ palette.surface
            |> MaterialColor.withShade palette.on.surface MaterialColor.buttonSelectedOpacity
            |> MaterialColor.fromColor
            |> Background.color
        , palette.surface
            |> MaterialColor.accessibleTextColor
            |> MaterialColor.fromColor
            |> Font.color
        , palette.on.surface
            |> MaterialColor.scaleOpacity 0.14
            |> MaterialColor.withShade palette.on.surface MaterialColor.buttonSelectedOpacity
            |> MaterialColor.fromColor
            |> Border.color
        , Element.mouseOver []
        ]
    , otherwise =
        [ palette.surface
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
        ]
    , content =
        { elementRow =
            [ Element.spacing <| 8
            , Element.height Element.fill
            , Element.width Element.fill
            , Border.rounded 24
            , Element.padding 8
            , Element.focused <|
                (palette.surface
                    |> MaterialColor.withShade palette.on.surface MaterialColor.buttonFocusOpacity
                    |> MaterialColor.textAndBackground
                )
            ]
        , content =
            { text = { contentText = [ Element.centerX ] }
            , icon =
                { ifActive =
                    { size = 24
                    , color =
                        palette.surface
                            |> MaterialColor.accessibleTextColor
                    }
                , ifDisabled =
                    { size = 24
                    , color = MaterialColor.gray
                    }
                , otherwise =
                    { size = 24
                    , color =
                        palette.surface
                            |> MaterialColor.accessibleTextColor
                    }
                }
            }
        }
    }


{-| An single selectable icon.

Technical Remark:

  - Could not find any specification details

-}
iconButton : Palette -> ButtonStyle msg
iconButton palette =
    { elementButton =
        (baseButton palette |> .elementButton)
            ++ [ Element.height <| Element.px 48
               , Element.width <| Element.minimum 48 <| Element.shrink
               , Border.rounded 24
               , Element.mouseDown
                    [ palette.surface
                        |> MaterialColor.scaleOpacity MaterialColor.buttonPressedOpacity
                        |> MaterialColor.fromColor
                        |> Background.color
                    ]
               , Element.focused
                    [ palette.surface
                        |> MaterialColor.scaleOpacity MaterialColor.buttonFocusOpacity
                        |> MaterialColor.fromColor
                        |> Background.color
                    ]
               , Element.mouseOver
                    [ palette.surface
                        |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
                        |> MaterialColor.fromColor
                        |> Background.color
                    ]
               ]
    , ifDisabled =
        (baseButton palette |> .ifDisabled)
            ++ [ MaterialColor.gray
                    |> MaterialColor.fromColor
                    |> Font.color
               , Element.mouseDown []
               , Element.mouseOver []
               , Element.focused []
               ]
    , ifActive =
        [ palette.surface
            |> MaterialColor.scaleOpacity MaterialColor.buttonHoverOpacity
            |> MaterialColor.fromColor
            |> Background.color
        ]
    , otherwise =
        []
    , content =
        { elementRow =
            [ Element.spacing 8
            , Element.width <| Element.shrink
            , Element.centerY
            , Element.centerX
            ]
        , content =
            { text = { contentText = [ Element.centerX ] }
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
