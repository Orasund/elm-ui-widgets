module Widget.Snackbar exposing
    ( SnackbarStyle, Snackbar, Message, init, current, timePassed, view
    , insert, insertFor, dismiss
    )

{-| ![Snackbar](https://orasund.github.io/elm-ui-widgets/assets/snackbar.png)

A [snackbar](https://material.io/components/snackbars/) shows notification, one at a time.

[Open in Ellie](https://ellie-app.com/9pz7FqhVW83a1)


# Basics

@docs SnackbarStyle, Snackbar, Message, init, current, timePassed, view


# Operations

@docs insert, insertFor, dismiss

-}

import Element exposing (Attribute, Element)
import Internal.Button as Button exposing (ButtonStyle, TextButton)
import Queue exposing (Queue)


{-| -}
type alias SnackbarStyle msg =
    { elementRow : List (Attribute msg)
    , content :
        { text :
            { elementText : List (Attribute msg)
            }
        , button : ButtonStyle msg
        }
    }


{-| A message with maybe some action button
-}
type alias Message msg =
    { text : String
    , button : Maybe (TextButton msg)
    }


{-| A snackbar has a queue of Notifications, each with the amount of ms the message should be displayed
-}
type alias Snackbar a =
    { queue : Queue ( a, Int )
    , current : Maybe ( a, Int )
    }


{-| Inital state
-}
init : Snackbar a
init =
    { queue = Queue.empty
    , current = Nothing
    }


{-| Insert a message that will last for 10 seconds.
-}
insert : a -> Snackbar a -> Snackbar a
insert =
    insertFor 10000


{-| Insert a message for a specific amount of milli seconds.
-}
insertFor : Int -> a -> Snackbar a -> Snackbar a
insertFor removeIn a model =
    case model.current of
        Nothing ->
            { model | current = Just ( a, removeIn ) }

        Just _ ->
            { model | queue = model.queue |> Queue.enqueue ( a, removeIn ) }


{-| Dismiss the current message.
-}
dismiss : Snackbar a -> Snackbar a
dismiss model =
    { model | current = Nothing }


{-| Updates the model. This functions should be called regularly.
The first argument is the milli seconds that passed since the last time the function was called.
-}
timePassed : Int -> Snackbar a -> Snackbar a
timePassed ms model =
    case model.current of
        Nothing ->
            let
                ( c, queue ) =
                    model.queue |> Queue.dequeue
            in
            { model
                | current = c
                , queue = queue
            }

        Just ( _, removeIn ) ->
            if removeIn <= ms then
                model |> dismiss

            else
                { model | current = model.current |> Maybe.map (Tuple.mapSecond ((+) -ms)) }


{-| Returns the current element.
-}
current : Snackbar a -> Maybe a
current model =
    model.current |> Maybe.map Tuple.first


{-| Views the current Message. (only one at a time)
-}
view :
    SnackbarStyle msg
    -> (a -> Message msg)
    -> Snackbar a
    -> Maybe (Element msg)
view style toMessage model =
    model
        |> current
        |> Maybe.map
            (toMessage
                >> (\{ text, button } ->
                        [ text
                            |> Element.text
                            |> List.singleton
                            |> Element.paragraph style.content.text.elementText
                        , button
                            |> Maybe.map
                                (Button.textButton style.content.button)
                            |> Maybe.withDefault Element.none
                        ]
                            |> Element.row style.elementRow
                   )
            )
