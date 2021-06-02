module Main exposing (main)

import Element
import Pages.Button
import UIExplorer


pages =
    UIExplorer.firstPage "Button" Pages.Button.page


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
