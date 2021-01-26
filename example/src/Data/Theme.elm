module Data.Theme exposing (Theme(..), toStyle)

import Data.Style as Style exposing (Style)
import Widget.Style.Material exposing (Palette)


type Theme
    = Material
    | DarkMaterial


toStyle : Theme -> Style msg
toStyle theme =
    case theme of
        Material ->
            Style.style Widget.Style.Material.defaultPalette

        DarkMaterial ->
            Style.style Widget.Style.Material.darkPalette
