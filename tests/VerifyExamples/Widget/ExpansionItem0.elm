module VerifyExamples.Widget.ExpansionItem0 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Test
import Expect

import Widget exposing (..)
import Widget.Material as Material
import Element

type Msg =
    Toggle Bool





spec0 : Test.Test
spec0 =
    Test.test "#expansionItem: \n\n    let\n        isExpanded : Bool\n        isExpanded =\n            True\n    in\n    (   ( Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)\n            { onPress = Nothing\n            , icon = always Element.none\n            , text = \"Item with Icon\"\n            }\n        )\n        :: Widget.expansionItem (Material.expansionItem Material.defaultPalette )\n            { onToggle = Toggle\n            , isExpanded = isExpanded\n            , icon = always Element.none\n            , text = \"Expandable Item\"\n            , content =\n                [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)\n                { onPress = Nothing\n                , icon = always Element.none\n                , text = \"Item with Icon\"\n                }\n                ]\n            }\n    )\n        |> Widget.itemList (Material.cardColumn Material.defaultPalette)\n        |> always \"Ignore this line\"\n    --> \"Ignore this line\"" <|
        \() ->
            Expect.equal
                (
                let
                    isExpanded : Bool
                    isExpanded =
                        True
                in
                (   ( Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
                        { onPress = Nothing
                        , icon = always Element.none
                        , text = "Item with Icon"
                        }
                    )
                    :: Widget.expansionItem (Material.expansionItem Material.defaultPalette )
                        { onToggle = Toggle
                        , isExpanded = isExpanded
                        , icon = always Element.none
                        , text = "Expandable Item"
                        , content =
                            [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
                            { onPress = Nothing
                            , icon = always Element.none
                            , text = "Item with Icon"
                            }
                            ]
                        }
                )
                    |> Widget.itemList (Material.cardColumn Material.defaultPalette)
                    |> always "Ignore this line"
                )
                (
                "Ignore this line"
                )