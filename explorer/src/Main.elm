module Main exposing (main)

import Button
import Element
import UIExplorer


pages =
    UIExplorer.firstPage "Button" Button.page


main =
    let
        config =
            UIExplorer.defaultConfig
    in
    UIExplorer.application
        { config
            | sidebarTitle = Element.text "Elm UI Widgets"
        }
        pages
