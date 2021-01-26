module Data.Theme exposing (Theme(..), toStyle)

import Data.Style as Style exposing (Style)
import Widget.Material as Material exposing (Palette)


type Theme
    = Material
    | DarkMaterial


toStyle : Theme -> Style msg
toStyle theme =
    case theme of
        Material ->
            Style.style Material.defaultPalette

        DarkMaterial ->
            Style.style Material.darkPalette
