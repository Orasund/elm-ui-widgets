module Main exposing (main)

import Button
import UIExplorer


pages =
    UIExplorer.firstPage "Button" Button.page


main =
    UIExplorer.application UIExplorer.defaultConfig pages
