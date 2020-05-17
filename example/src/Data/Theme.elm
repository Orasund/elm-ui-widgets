module Data.Theme exposing (Theme(..), toStyle)

import Data.Style exposing (Style)
import Data.Style.ElmUiFramework
import Data.Style.Material
import Data.Style.Template


type Theme
    = ElmUiFramework
    | Template
    | Material


toStyle : Theme -> Style msg
toStyle theme =
    case theme of
        ElmUiFramework ->
            Data.Style.ElmUiFramework.style

        Template ->
            Data.Style.Template.style

        Material ->
            Data.Style.Material.style Data.Style.Material.defaultPalette
