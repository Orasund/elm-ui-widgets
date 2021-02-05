module IconBug exposing (main)

import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Svg
import Svg.Attributes


main : Html msg
main =
    Element.layout [] <|
        row []
            [ el
                [ width (shrink |> minimum 100)
                , explain Debug.todo
                ]
                (el
                    [ width (px 200)
                    , height (px 200)
                    ]
                    none
                )
            ]



{--Element.layout [] <|
        row [ width shrink
            ]
            [ Element.el
                [ height <| px 48
                , width (shrink |> minimum 32)
                , explain Debug.todo
                ]
                (row
                            [ width (shrink)
                            ]
                            [ Element.el [centerX] <| text "test test test Test Test"]
                        )
            ]--}
