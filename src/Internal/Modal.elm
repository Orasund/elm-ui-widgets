module Internal.Modal exposing (Modal, multiModal, singleModal)

import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Events as Events


type alias Modal msg =
    { onDismiss : Maybe msg
    , content : Element msg
    }


background : Maybe msg -> List (Attribute msg)
background onDismiss =
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
    , Element.clip
    ]


singleModal : List (Modal msg) -> List (Attribute msg)
singleModal =
    List.head
        >> Maybe.map
            (\{ onDismiss, content } ->
                background onDismiss ++ [ content |> Element.inFront ]
            )
        >> Maybe.withDefault []


multiModal : List (Modal msg) -> List (Attribute msg)
multiModal list =
    case list of
        head :: tail ->
            (tail
                |> List.reverse
                |> List.map (\{ content } -> content |> Element.inFront)
            )
                ++ background head.onDismiss
                ++ [ head.content |> Element.inFront ]

        _ ->
            []
