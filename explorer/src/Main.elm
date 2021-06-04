module Main exposing (main)

import Element
import Page.Button
import Page.PasswordInput
import UIExplorer


pages =
    UIExplorer.firstPage "Button" Page.Button.page
        |> UIExplorer.nextPage "Password Input" Page.PasswordInput.page


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
