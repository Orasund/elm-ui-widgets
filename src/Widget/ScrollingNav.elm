module Widget.ScrollingNav exposing
    ( Model, Msg, init, update, subscriptions, view, viewSections
    , jumpTo, syncPositions
    )

{-| The Scrolling Nav is a navigation bar thats updates while you scroll through
the page. Clicking on a navigation button will scroll directly to that section.


# Basics

@docs Model, Msg, init, update, subscriptions, view, viewSections


# Operations

@docs jumpTo, syncPositions

-}

import Browser.Dom as Dom
import Element exposing (Attribute, Element)
import Framework.Grid as Grid
import Html.Attributes as Attributes
import IntDict exposing (IntDict)
import Task
import Time


{-| -}
type alias Model elem =
    { labels : elem -> String
    , positions : IntDict String
    , arrangement : List elem
    , scrollPos : Int
    }


{-| -}
type Msg elem
    = GotHeaderPos elem (Result Dom.Error Int)
    | ChangedViewport (Result Dom.Error ())
    | SyncPosition Int
    | JumpTo elem
    | TimePassed


{-| -}
init :
    { labels : elem -> String
    , arrangement : List elem
    }
    -> ( Model elem, Cmd (Msg elem) )
init { labels, arrangement } =
    { labels = labels
    , positions = IntDict.empty
    , arrangement = arrangement
    , scrollPos = 0
    }
        |> (\a ->
                ( a
                , syncPositions a
                )
           )


{-| -}
update : Msg elem -> Model elem -> ( Model elem, Cmd (Msg elem) )
update msg model =
    case msg of
        GotHeaderPos label result ->
            ( case result of
                Ok pos ->
                    { model
                        | positions =
                            model.positions
                                |> IntDict.insert pos
                                    (label |> model.labels)
                    }

                Err _ ->
                    model
            , Cmd.none
            )

        ChangedViewport _ ->
            ( model, Cmd.none )

        SyncPosition pos ->
            ( { model
                | scrollPos = pos
              }
            , Cmd.none
            )

        TimePassed ->
            ( model
            , Dom.getViewport
                |> Task.map (.viewport >> .y >> round)
                |> Task.perform SyncPosition
            )

        JumpTo elem ->
            ( model
            , model
                |> jumpTo elem
            )


{-| -}
subscriptions : Sub (Msg msg)
subscriptions =
    Time.every 1000 (always TimePassed)


{-| -}
jumpTo : elem -> Model elem -> Cmd (Msg msg)
jumpTo section { labels } =
    Dom.getElement (section |> labels)
        |> Task.andThen
            (\{ element } ->
                Dom.setViewport 0 element.y
            )
        |> Task.attempt ChangedViewport


{-| -}
syncPositions : Model elem -> Cmd (Msg elem)
syncPositions { labels, arrangement } =
    arrangement
        |> List.map
            (\label ->
                Dom.getElement (labels label)
                    |> Task.map
                        (.element
                            >> .y
                            >> round
                        )
                    |> Task.attempt
                        (GotHeaderPos label)
            )
        |> Cmd.batch


{-| -}
viewSections :
    { label : String -> Element msg
    , fromString : String -> Maybe elem
    , msgMapper : Msg elem -> msg
    , attributes : Bool -> List (Attribute msg)
    }
    -> Model elem
    ->
        { selected : Maybe elem
        , options : List elem
        , label : elem -> Element msg
        , onChange : elem -> msg
        , attributes : Bool -> List (Attribute msg)
        }
viewSections { label, fromString, msgMapper, attributes } { arrangement, scrollPos, labels, positions } =
    let
        current =
            positions
                |> IntDict.before (scrollPos + 1)
                |> Maybe.map Just
                |> Maybe.withDefault (positions |> IntDict.after (scrollPos + 1))
                |> Maybe.map Tuple.second
                |> Maybe.andThen fromString
    in
    { selected = current
    , options = arrangement
    , label = \elem -> label (elem |> labels)
    , onChange = JumpTo >> msgMapper
    , attributes = attributes
    }


{-| -}
view :
    (elem -> Element msg)
    -> Model elem
    -> Element msg
view asElement { labels, arrangement } =
    arrangement
        |> List.map
            (\header ->
                Element.el
                    [ header
                        |> labels
                        |> Attributes.id
                        |> Element.htmlAttribute
                    , Element.width <| Element.fill
                    ]
                <|
                    asElement <|
                        header
            )
        |> Element.column Grid.simple
