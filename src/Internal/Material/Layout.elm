module Internal.Material.Layout exposing (layout)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Internal.Button exposing (ButtonStyle)
import Internal.Material.AppBar as AppBar
import Internal.Material.Button as Button
import Internal.Material.Icon as Icon
import Internal.Material.Item as Item
import Internal.Material.Palette exposing (Palette)
import Internal.Material.Sheet as Sheet
import Internal.Material.Snackbar as Snackbar
import Internal.Material.TextInput as TextInput
import Svg
import Svg.Attributes
import Widget.Customize as Customize
import Widget.Icon as Icon exposing (Icon)
import Widget.Layout exposing (LayoutStyle)
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


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
    , menuBar = AppBar.menuBar palette
    , tabBar = AppBar.tabBar palette
    , snackbar = Snackbar.snackbar palette
    , sheetButton = Item.selectItem palette
    , sheet = Sheet.sideSheet palette
    , spacing = 8
    , title = Typography.h6 ++ [ Element.paddingXY 8 0 ]
    , searchFill =
        TextInput.textInputBase palette
            |> Customize.elementRow [ Element.height <| Element.px 56 ]
    , insetItem = Item.insetItem palette
    }
