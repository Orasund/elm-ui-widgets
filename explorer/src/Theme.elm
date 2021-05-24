module Theme exposing (..)

import Widget.Material exposing (Palette)


type Theme
    = MaterialDefault
    | MaterialDark


allThemeOptions : List Theme
allThemeOptions =
    [ MaterialDefault
    , MaterialDark
    ]


themeOptionToString : Theme -> String
themeOptionToString theme =
    case theme of
        MaterialDefault ->
            "Material"

        MaterialDark ->
            "Material dark"


themeValue : Theme -> Palette
themeValue theme =
    case theme of
        MaterialDefault ->
            Widget.Material.defaultPalette

        MaterialDark ->
            Widget.Material.darkPalette
