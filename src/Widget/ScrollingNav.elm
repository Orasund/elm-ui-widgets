module Widget.ScrollingNav exposing
    ( Model, init, view, current
    , jumpTo, syncPositions
    , getPos, jumpToWithOffset, setPos, toSelect
    )

{-| The Scrolling Nav is a navigation bar thats updates while you scroll through
the page. Clicking on a navigation button will scroll directly to that section.


# Basics

@docs Model, Msg, init, update, subscriptions, view, viewSections, current


# Operations

@docs jumpTo, syncPositions

-}

import Browser.Dom as Dom
import Element exposing (Element)
import Framework.Grid as Grid
import Html.Attributes as Attributes
import IntDict exposing (IntDict)
import Task exposing (Task)
import Widget exposing (Select)


{-| -}
type alias Model section =
    { toString : section -> String
    , fromString : String -> Maybe section
    , positions : IntDict String
    , arrangement : List section
    , scrollPos : Int
    }


{-| The intial state include the labels and the arrangement of the sections
-}
init :
    { toString : section -> String
    , fromString : String -> Maybe section
    , arrangement : List section
    , toMsg : Result Dom.Error (Model section -> Model section) -> msg
    }
    -> ( Model section, Cmd msg )
init { toString, fromString, arrangement, toMsg } =
    { toString = toString
    , fromString = fromString
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
jumpTo { section, onChange } { toString } =
    Dom.getElement (section |> toString)
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
jumpToWithOffset { offset, section, onChange } { toString } =
    Dom.getElement (section |> toString)
        |> Task.andThen
            (\{ element } ->
                Dom.setViewport 0 (element.y - offset)
            )
        |> Task.attempt onChange


{-| -}
syncPositions : Model section -> Task Dom.Error (Model section -> Model section)
syncPositions { toString, arrangement } =
    arrangement
        |> List.map
            (\label ->
                Dom.getElement (toString label)
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
                                            (label |> model.toString)
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


toSelect : (Int -> Maybe msg) -> Model section -> Select msg
toSelect onSelect ({ arrangement, toString, fromString } as model) =
    { selected =
        arrangement
            |> List.indexedMap (\i s -> ( i, s ))
            |> List.filterMap
                (\( i, s ) ->
                    if Just s == current fromString model then
                        Just i

                    else
                        Nothing
                )
            |> List.head
    , options =
        arrangement
            |> List.map
                (\s ->
                    { text = toString s
                    , icon = Element.none
                    }
                )
    , onSelect = onSelect
    }


{-| -}
view :
    (section -> Element msg)
    -> Model section
    -> Element msg
view asElement { toString, arrangement } =
    arrangement
        |> List.map
            (\header ->
                Element.el
                    [ header
                        |> toString
                        |> Attributes.id
                        |> Element.htmlAttribute
                    , Element.width <| Element.fill
                    ]
                <|
                    asElement <|
                        header
            )
        |> Element.column Grid.simple
