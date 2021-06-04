module Main exposing (main)

import Element
import Page.Button
import Page.PasswordInput
import Page.Select
import Page.Switch
import UIExplorer


pages =
    UIExplorer.firstPage "Button" Page.Button.page
        |> UIExplorer.nextPage "Select" Page.Select.page
        |> UIExplorer.nextPage "Switch" Page.Switch.page
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
