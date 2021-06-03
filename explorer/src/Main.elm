module Main exposing (main)

import Element
import Pages.Button
import Pages.PasswordInput
import UIExplorer


pages =
    UIExplorer.firstPage "Button" Pages.Button.page
        |> UIExplorer.nextPage "Password Input" Pages.PasswordInput.page


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
