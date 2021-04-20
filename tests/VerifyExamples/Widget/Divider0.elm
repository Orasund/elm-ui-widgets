module VerifyExamples.Widget.Divider0 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Test
import Expect

import Widget exposing (..)
import Widget.Material as Material
import Element







spec0 : Test.Test
spec0 =
    Test.test "#divider: \n\n    [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)\n        { onPress = Nothing\n        , icon = always Element.none\n        , text = \"Item\"\n        }\n    , Widget.divider (Material.insetDivider Material.defaultPalette )\n    , Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)\n        { onPress = Nothing\n        , icon = always Element.none\n        , text = \"Item\"\n        }\n    ]\n        |> Widget.itemList (Material.cardColumn Material.defaultPalette)\n        |> always \"Ignore this line\"\n    --> \"Ignore this line\"" <|
        \() ->
            Expect.equal
                (
                [ Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
                    { onPress = Nothing
                    , icon = always Element.none
                    , text = "Item"
                    }
                , Widget.divider (Material.insetDivider Material.defaultPalette )
                , Widget.fullBleedItem (Material.fullBleedItem Material.defaultPalette)
                    { onPress = Nothing
                    , icon = always Element.none
                    , text = "Item"
                    }
                ]
                    |> Widget.itemList (Material.cardColumn Material.defaultPalette)
                    |> always "Ignore this line"
                )
                (
                "Ignore this line"
                )