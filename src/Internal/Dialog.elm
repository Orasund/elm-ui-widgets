module Internal.Dialog exposing (Dialog, dialog, modal)

import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Events as Events
import Internal.Button as Button exposing (TextButton)
import Widget.Style exposing (DialogStyle)


type alias Dialog msg =
    { title : Maybe String
    , text : String
    , accept : Maybe (TextButton msg)
    , dismiss : Maybe (TextButton msg)
    }


modal : { onDismiss : Maybe msg, content : Element msg } -> List (Attribute msg)
modal { onDismiss, content } =
    [ Element.none
        |> Element.el
            ([ Element.width <| Element.fill
             , Element.height <| Element.fill
             , Background.color <| Element.rgba255 0 0 0 0.5
             ]
                ++ (onDismiss
                        |> Maybe.map (Events.onClick >> List.singleton)
                        |> Maybe.withDefault []
                   )
            )
        |> Element.inFront
    , content |> Element.inFront
    , Element.clip
    ]


dialog :
    DialogStyle msg
    -> Dialog msg
    -> List (Attribute msg)
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
                ++ style.containerColumn
            )
            [ title
                |> Maybe.map
                    (Element.text
                        >> Element.el style.title
                    )
                |> Maybe.withDefault Element.none
            , text
                |> Element.text
                |> List.singleton
                |> Element.paragraph style.text
            , Element.row
                ([ Element.alignRight
                 , Element.width <| Element.shrink
                 ]
                    ++ style.buttonRow
                )
                (case ( accept, dismiss ) of
                    ( Just acceptButton, Nothing ) ->
                        acceptButton
                            |> Button.textButton style.acceptButton
                            |> List.singleton

                    ( Just acceptButton, Just dismissButton ) ->
                        [ dismissButton
                            |> Button.textButton style.dismissButton
                        , acceptButton
                            |> Button.textButton style.acceptButton
                        ]

                    _ ->
                        []
                )
            ]
    }
        |> modal
