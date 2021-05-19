module Main exposing (main)

import Button
import UiExplorer


pages =
    UiExplorer.firstPage "Button" Button.page


main =
    UiExplorer.application UiExplorer.defaultConfig pages
