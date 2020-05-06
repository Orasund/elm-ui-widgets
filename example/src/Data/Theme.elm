module Data.Theme exposing (Theme(..),toStyle)

import Data.Style exposing (Style)
import Data.Style.ElmUiFramework
import Data.Style.Template

type  Theme =
    ElmUiFramework
    | Template

toStyle : Theme -> Style msg
toStyle theme =
    case theme of
        ElmUiFramework ->
            Data.Style.ElmUiFramework.style
        Template ->
            Data.Style.Template.style
