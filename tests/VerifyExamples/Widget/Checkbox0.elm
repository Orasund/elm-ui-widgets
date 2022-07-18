module VerifyExamples.Widget.Checkbox0 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Test
import Expect

import Widget exposing (..)
import Widget.Material as Material

type Msg
    = Check Bool





spec0 : Test.Test
spec0 =
    Test.test "#checkbox: \n\n    checkbox (Material.checkbox Material.defaultPalette)\n        { description = \"Dark Mode\"\n        , onChange = Just Check\n        , checked = False\n        }\n        |> always \"Ignore this line\"\n    --> \"Ignore this line\"" <|
        \() ->
            Expect.equal
                (
                checkbox (Material.checkbox Material.defaultPalette)
                    { description = "Dark Mode"
                    , onChange = Just Check
                    , checked = False
                    }
                    |> always "Ignore this line"
                )
                (
                "Ignore this line"
                )