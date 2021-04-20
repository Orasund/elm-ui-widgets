module VerifyExamples.Widget.MultiModal0 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Test
import Expect

import Widget exposing (..)
import Element

type Msg
    = Close





spec0 : Test.Test
spec0 =
    Test.test "#multiModal: \n\n    Element.layout\n        (multiModal\n            [ { onDismiss = Just Close\n              , content =\n                  Element.text \"Click outside this window to close it.\"\n              }\n            ]\n        )\n        |> always \"Ignore this line\"\n    --> \"Ignore this line\"" <|
        \() ->
            Expect.equal
                (
                Element.layout
                    (multiModal
                        [ { onDismiss = Just Close
                          , content =
                              Element.text "Click outside this window to close it."
                          }
                        ]
                    )
                    |> always "Ignore this line"
                )
                (
                "Ignore this line"
                )