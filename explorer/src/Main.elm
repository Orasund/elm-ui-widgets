module Main exposing (main)

import Element
import Json.Decode as Decode exposing (Decoder)
import Page.AppBar
import Page.Button
import Page.Dialog
import Page.Icon
import Page.Item
import Page.Modal
import Page.MultiSelect
import Page.PasswordInput
import Page.ProgressIndicator
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
        |> UIExplorer.nextPage "Multi Select" Page.MultiSelect.page
        |> UIExplorer.nextPage "Switch" Page.Switch.page
        |> UIExplorer.nextPage "Tab" Page.Tab.page
        |> UIExplorer.nextPage "Password Input" Page.PasswordInput.page
        |> UIExplorer.nextPage "Text Input" Page.TextInput.page
        |> UIExplorer.nextPage "Sort Table" Page.SortTable.page
        |> UIExplorer.nextPage "Snackbar" Page.Snackbar.page
        |> UIExplorer.nextPage "Item" Page.Item.page
        |> UIExplorer.nextPage "ProgressIndicator" Page.ProgressIndicator.page
        |> UIExplorer.nextPage "Modal" Page.Modal.page
        |> UIExplorer.nextPage "App Bar" Page.AppBar.page
        |> UIExplorer.nextPage "Icon" Page.Icon.page
        |> UIExplorer.nextPage "Dialog" Page.Dialog.page


type alias Flags =
    { settings : UIExplorer.Settings
    , config : UIExplorer.Config
    }


decodeFlags : Decoder Flags
decodeFlags =
    Decode.map2 Flags
        UIExplorer.decodeSettings
        (UIExplorer.decodeConfig
            { relativeUrlPath = []
            }
        )


config : UIExplorer.ApplicationConfig msg Flags
config =
    { flagsDecoder = decodeFlags
    , layoutOptions = []
    , layoutAttributes = []
    , sidebarTitle = Element.text "Elm UI Widgets"
    }


main =
    UIExplorer.application config pages
