module Data.Theme exposing (Theme(..), toStyle)

import Data.Style exposing (Style)
import Data.Style.ElmUiFramework
import Data.Style.Material
import Data.Style.SemanticUI
import Data.Style.Template
import Widget.Style.Material


type Theme
    = Template
    | Material
    | DarkMaterial


toStyle : Theme -> Style msg
toStyle theme =
    case theme of
        Template ->
            Data.Style.Template.style

        Material ->
            Data.Style.Material.style Widget.Style.Material.defaultPalette

        DarkMaterial ->
            Data.Style.Material.style Widget.Style.Material.darkPalette
