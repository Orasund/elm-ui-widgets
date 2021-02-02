module Internal.Dialog exposing (Dialog, DialogStyle, dialog)

import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Events as Events
import Internal.Button as Button exposing (ButtonStyle, TextButton)
import Internal.Modal as Modal exposing (Modal)


{-| -}
type alias DialogStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { title :
            { contentText : List (Attribute msg)
            }
        , text :
            { contentText : List (Attribute msg)
            }
        , buttons :
            { elementRow : List (Attribute msg)
            , content :
                { accept : ButtonStyle msg
                , dismiss : ButtonStyle msg
                }
            }
        }
    }


type alias Dialog msg =
    { title : Maybe String
    , text : String
    , accept : Maybe (TextButton msg)
    , dismiss : Maybe (TextButton msg)
    }


dialog :
    DialogStyle msg
    -> Dialog msg
    -> Modal msg
dialog style { title, text, accept, dismiss } =
    { onDismiss =
        case ( accept, dismiss ) of
            ( Nothing, Nothing ) ->
                Nothing

            ( Nothing, Just { onPress } ) ->
                onPress

            ( Just _, _ ) ->
                Nothing
    , content =
        Element.column
            ([ Element.centerX
             , Element.centerY
             ]
                ++ style.elementColumn
            )
            [ title
                |> Maybe.map
                    (Element.text
                        >> Element.el style.content.title.contentText
                    )
                |> Maybe.withDefault Element.none
            , text
                |> Element.text
                |> List.singleton
                |> Element.paragraph style.content.text.contentText
            , Element.row
                ([ Element.alignRight
                 , Element.width <| Element.shrink
                 ]
                    ++ style.content.buttons.elementRow
                )
                (case ( accept, dismiss ) of
                    ( Just acceptButton, Nothing ) ->
                        acceptButton
                            |> Button.textButton style.content.buttons.content.accept
                            |> List.singleton

                    ( Just acceptButton, Just dismissButton ) ->
                        [ dismissButton
                            |> Button.textButton style.content.buttons.content.dismiss
                        , acceptButton
                            |> Button.textButton style.content.buttons.content.accept
                        ]

                    _ ->
                        []
                )
            ]
    }
