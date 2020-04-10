module Widget.ScrollingNav exposing
    ( Model, init, view, viewSections, current
    , jumpTo, syncPositions
    , getPos, jumpToWithOffset, setPos
    )

{-| The Scrolling Nav is a navigation bar thats updates while you scroll through
the page. Clicking on a navigation button will scroll directly to that section.


# Basics

@docs Model, Msg, init, update, subscriptions, view, viewSections, current


# Operations

@docs jumpTo, syncPositions

-}

import Browser.Dom as Dom
import Element exposing (Attribute, Element)
import Framework.Grid as Grid
import Html.Attributes as Attributes
import IntDict exposing (IntDict)
import Task exposing (Task)


{-| -}
type alias Model section =
    { labels : section -> String
    , positions : IntDict String
    , arrangement : List section
    , scrollPos : Int
    }


{-| The intial state include the labels and the arrangement of the sections
-}
init :
    { labels : section -> String
    , arrangement : List section
    , toMsg : Result Dom.Error (Model section -> Model section) -> msg
    }
    -> ( Model section, Cmd msg )
init { labels, arrangement, toMsg } =
    { labels = labels
    , positions = IntDict.empty
    , arrangement = arrangement
    , scrollPos = 0
    }
        |> (\a ->
                ( a
                , syncPositions a
                    |> Task.attempt toMsg
                )
           )


getPos : Task x (Model selection -> Model selection)
getPos =
    Dom.getViewport
        |> Task.map
            (\int model ->
                { model
                    | scrollPos = int.viewport.y |> round
                }
            )


setPos : Int -> Model section -> Model section
setPos pos model =
    { model | scrollPos = pos }


{-| scrolls the screen to the respective section
-}
jumpTo :
    { section : section
    , onChange : Result Dom.Error () -> msg
    }
    -> Model section
    -> Cmd msg
jumpTo { section, onChange } { labels } =
    Dom.getElement (section |> labels)
        |> Task.andThen
            (\{ element } ->
                Dom.setViewport 0 element.y
            )
        |> Task.attempt onChange


{-| scrolls the screen to the respective section with some offset
-}
jumpToWithOffset :
    { offset : Float
    , section : section
    , onChange : Result Dom.Error () -> msg
    }
    -> Model section
    -> Cmd msg
jumpToWithOffset { offset, section, onChange } { labels } =
    Dom.getElement (section |> labels)
        |> Task.andThen
            (\{ element } ->
                Dom.setViewport 0 (element.y - offset)
            )
        |> Task.attempt onChange


{-| -}
syncPositions : Model section -> Task Dom.Error (Model section -> Model section)
syncPositions { labels, arrangement } =
    arrangement
        |> List.map
            (\label ->
                Dom.getElement (labels label)
                    |> Task.map
                        (\x ->
                            ( x.element.y |> round
                            , label
                            )
                        )
            )
        |> Task.sequence
        |> Task.map
            (\list m ->
                list
                    |> List.foldl
                        (\( pos, label ) model ->
                            { model
                                | positions =
                                    model.positions
                                        |> IntDict.insert pos
                                            (label |> model.labels)
                            }
                        )
                        m
            )


{-| -}
current : (String -> Maybe section) -> Model section -> Maybe section
current fromString { positions, scrollPos } =
    positions
        |> IntDict.before (scrollPos + 1)
        |> Maybe.map Just
        |> Maybe.withDefault (positions |> IntDict.after (scrollPos + 1))
        |> Maybe.map Tuple.second
        |> Maybe.andThen fromString


{-| -}
viewSections :
    { label : String -> Element msg
    , fromString : String -> Maybe section
    , onSelect : section -> msg
    , attributes : Bool -> List (Attribute msg)
    }
    -> Model section
    ->
        { selected : Maybe section
        , options : List section
        , label : section -> Element msg
        , onChange : section -> msg
        , attributes : Bool -> List (Attribute msg)
        }
viewSections { label, fromString, onSelect, attributes } ({ arrangement, labels } as model) =
    { selected = model |> current fromString
    , options = arrangement
    , label = \elem -> label (elem |> labels)
    , onChange = onSelect
    , attributes = attributes
    }


{-| -}
view :
    (section -> Element msg)
    -> Model section
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
