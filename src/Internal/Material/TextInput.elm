module Internal.Material.TextInput exposing (searchInput, textInput, textInputBase)

import Element
import Element.Border as Border
import Internal.Material.Chip as Chip
import Internal.Material.Palette exposing (Palette)
import Internal.TextInput exposing (TextInputStyle)
import Widget.Style.Customize as Customize
import Widget.Style.Material.Color as MaterialColor


textInput : Palette -> TextInputStyle msg
textInput palette =
    { elementRow =
        (palette.surface
            |> MaterialColor.textAndBackground
        )
            ++ [ Element.spacing 8
               , Element.paddingXY 8 0
               , Border.width 1
               , Border.rounded 4
               , palette.on.surface
                    |> MaterialColor.scaleOpacity 0.14
                    |> MaterialColor.fromColor
                    |> Border.color
               , Element.focused
                    [ Border.shadow <| MaterialColor.shadow 4
                    , palette.primary
                        |> MaterialColor.fromColor
                        |> Border.color
                    ]
               , Element.mouseOver [ Border.shadow <| MaterialColor.shadow 2 ]
               ]
    , content =
        { chips =
            { elementRow = [ Element.spacing 8 ]
            , content = Chip.chip palette
            }
        , text =
            { elementTextInput =
                (palette.surface
                    |> MaterialColor.textAndBackground
                )
                    ++ [ Border.width 0
                       , Element.mouseOver []
                       , Element.focused []
                       , Element.centerY
                       ]
            }
        }
    }


searchInput : Palette -> TextInputStyle msg
searchInput palette =
    textInputBase palette
        |> Customize.mapElementRow
            (always
                [ Element.alignRight
                , Element.paddingXY 8 8
                , Border.rounded 4
                ]
            )
        |> Customize.mapContent
            (\record ->
                { record
                    | text =
                        record.text
                            |> Customize.elementTextInput
                                [ Border.width 0
                                , Element.paddingXY 8 8
                                , Element.height <| Element.px 32
                                , Element.width <| Element.maximum 360 <| Element.fill
                                ]
                }
            )


textInputBase : Palette -> TextInputStyle msg
textInputBase palette =
    { elementRow =
        palette.surface
            |> MaterialColor.textAndBackground
    , content =
        { chips =
            { elementRow = [ Element.spacing 8 ]
            , content = Chip.chip palette
            }
        , text =
            { elementTextInput =
                (palette.surface
                    |> MaterialColor.textAndBackground
                )
                    ++ [ Border.width 0
                       , Element.mouseOver []
                       , Element.focused []
                       ]
            }
        }
    }
