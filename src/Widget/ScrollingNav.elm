module Widget.ScrollingNav exposing
    ( ScrollingNav, init, view, current, toSelect
    , jumpTo, jumpToWithOffset, syncPositions, getPos, setPos
    )

{-| The Scrolling Nav is a navigation bar thats updates while you scroll through
the page. Clicking on a navigation button will scroll directly to that section.


# Basics

@docs ScrollingNav, init, view, current, toSelect


# Operations

@docs jumpTo, jumpToWithOffset, syncPositions, getPos, setPos

-}

import Browser.Dom as Dom
import Element exposing (Element)
import Html.Attributes as Attributes
import IntDict exposing (IntDict)
import Task exposing (Task)
import Widget exposing (Select)


{-| -}
type alias ScrollingNav section =
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
    , toMsg : Result Dom.Error (ScrollingNav section -> ScrollingNav section) -> msg
    }
    -> ( ScrollingNav section, Cmd msg )
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


{-| Syncs the position of of the viewport
-}
getPos : Task x (ScrollingNav selection -> ScrollingNav selection)
getPos =
    Dom.getViewport
        |> Task.map
            (\int model ->
                { model
                    | scrollPos = int.viewport.y |> round
                }
            )


{-| sets the position of the viewport to show a specific section
-}
setPos : Int -> ScrollingNav section -> ScrollingNav section
setPos pos model =
    { model | scrollPos = pos }


{-| Scrolls the screen to the respective section
-}
jumpTo :
    { section : section
    , onChange : Result Dom.Error () -> msg
    }
    -> ScrollingNav section
    -> Cmd msg
jumpTo { section, onChange } { toString } =
    Dom.getElement (section |> toString)
        |> Task.andThen
            (\{ element } ->
                Dom.setViewport 0 element.y
            )
        |> Task.attempt onChange


{-| Scrolls the screen to the respective section with some offset
-}
jumpToWithOffset :
    { offset : Float
    , section : section
    , onChange : Result Dom.Error () -> msg
    }
    -> ScrollingNav section
    -> Cmd msg
jumpToWithOffset { offset, section, onChange } { toString } =
    Dom.getElement (section |> toString)
        |> Task.andThen
            (\{ element } ->
                Dom.setViewport 0 (element.y - offset)
            )
        |> Task.attempt onChange


{-| Updates the positions of all sections.
This functions should be called regularly if the height of elements on your page can change during time.
-}
syncPositions : ScrollingNav section -> Task Dom.Error (ScrollingNav section -> ScrollingNav section)
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


{-| Returns the current section
-}
current : (String -> Maybe section) -> ScrollingNav section -> Maybe section
current fromString { positions, scrollPos } =
    positions
        |> IntDict.before (scrollPos + 1)
        |> Maybe.map Just
        |> Maybe.withDefault (positions |> IntDict.after (scrollPos + 1))
        |> Maybe.map Tuple.second
        |> Maybe.andThen fromString


{-| Returns a select widget containing all section, with the current section selected.
-}
toSelect : (Int -> Maybe msg) -> ScrollingNav section -> Select msg
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


{-| Opinionated way of viewing the section.

This might be useful at first, but you should consider writing your own view function.

```
view :
    (section -> Element msg)
    -> Model section
    -> List (Element msg)
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
```

-}
view :
    (section -> Element msg)
    -> ScrollingNav section
    -> List (Element msg)
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
