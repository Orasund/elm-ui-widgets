module Main exposing (main)

import Element
import Page.Button
import Page.Item
import Page.PasswordInput
import Page.Select
import Page.Snackbar
import Page.SortTable
import Page.Switch
import Page.Tab
import Page.TextInput
import UIExplorer


pages =
    UIExplorer.firstPage "Button" Page.Button.page
        |> UIExplorer.nextPage "Select" Page.Select.page
        |> UIExplorer.nextPage "Switch" Page.Switch.page
        |> UIExplorer.nextPage "Tab" Page.Tab.page
        |> UIExplorer.nextPage "Password Input" Page.PasswordInput.page
        |> UIExplorer.nextPage "Text Input" Page.TextInput.page
        |> UIExplorer.nextPage "Sort Table" Page.SortTable.page
        |> UIExplorer.nextPage "Snackbar" Page.Snackbar.page
        |> UIExplorer.nextPage "Item" Page.Item.page


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
