module Data.Theme exposing (Theme(..), toStyle)

import Data.Style exposing (Style)
import Data.Style.Material
import Widget.Style.Material


type Theme
    = Material
    | DarkMaterial


toStyle : Theme -> Style msg
toStyle theme =
    case theme of
        Material ->
            Data.Style.Material.style Widget.Style.Material.defaultPalette

        DarkMaterial ->
            Data.Style.Material.style Widget.Style.Material.darkPalette
