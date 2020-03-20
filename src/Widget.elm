module Widget exposing
    ( select, multiSelect, collapsable, carousel, dialog
    , tab
    )

{-| This module contains functions for displaying data.

@docs select, multiSelect, collapsable, carousel, dialog

-}

import Array exposing (Array)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Events as Events
import Element.Input as Input
import Set exposing (Set)


{-| Selects one out of multiple options. This can be used for radio buttons or Menus.
-}
select :
    { selected : Maybe a
    , options : List a
    , label : a -> Element msg
    , onChange : a -> msg
    , attributes : Bool -> List (Attribute msg)
    }
    -> List (Element msg)
select { selected, options, label, onChange, attributes } =
    options
        |> List.map
            (\a ->
                Input.button (attributes (selected == Just a))
                    { onPress = a |> onChange |> Just
                    , label = label a
                    }
            )


{-| Selects multible options. This can be used for checkboxes.
-}
multiSelect :
    { selected : Set comparable
    , options : List comparable
    , label : comparable -> Element msg
    , onChange : comparable -> msg
    , attributes : Bool -> List (Attribute msg)
    }
    -> List (Element msg)
multiSelect { selected, options, label, onChange, attributes } =
    options
        |> List.map
            (\a ->
                Input.button (attributes (selected |> Set.member a))
                    { onPress = a |> onChange |> Just
                    , label =
                        label a
                    }
            )


{-| Some collapsable content.

```
    Widget.collapsable
        {onToggle = ToggleCollapsable
        ,isCollapsed = model.isCollapsed
        ,label = Element.row Grid.compact
            [ Element.html <|
                if model.isCollapsed then
                    Heroicons.cheveronRight  [ Attributes.width 20]
                else
                    Heroicons.cheveronDown [ Attributes.width 20]
            , Element.el Heading.h4 <|Element.text <| "Title"
            ]
        ,content = Element.text <| "Hello World"
        }
```

-}
collapsable :
    { onToggle : Bool -> msg
    , isCollapsed : Bool
    , label : Element msg
    , content : Element msg
    }
    -> Element msg
collapsable { onToggle, isCollapsed, label, content } =
    Element.column [] <|
        [ Input.button []
            { onPress = Just <| onToggle <| not isCollapsed
            , label = label
            }
        ]
            ++ (if isCollapsed then
                    []

                else
                    [ content ]
               )


tab :
    List (Attribute msg)
    ->
        { selected : a
        , options : List a
        , onChange : a -> msg
        , label : a -> Element msg
        , content : a -> Element msg
        , attributes : Bool -> List (Attribute msg)
        }
    -> Element msg
tab atts { selected, options, onChange, label, content, attributes } =
    [ select
        { selected = Just selected
        , options = options
        , label = label
        , onChange = onChange
        , attributes = attributes
        }
        |> Element.row atts
    , content selected
    ]
        |> Element.column []


{-| A dialog element displaying important information.

```
    Framework.Layout
        [ Element.inFront <|
            if model.displayDialog then
                Widget.dialog
                    { onDismiss = Just <| ToggleDialog False
                    , content =
                        [ "This is a dialog window"
                            |> Element.text
                        , Input.button []
                            {onPress = Just <| ToggleDialog False
                            , label = Element.text "Ok"
                            }
                        ]
                        |> Element.column []
                    }
            else Element.none
        ] <|
            Element.text "some Content"
```

-}
dialog :
    { onDismiss : Maybe msg
    , content : Element msg
    }
    -> Element msg
dialog { onDismiss, content } =
    content
        |> Element.el
            [ Element.centerX
            , Element.centerY
            ]
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


{-| A Carousel circles through a non empty list of contents.

```
    Widget.carousel
        {content = ("Blue",["Yellow", "Green" , "Red" ]|> Array.fromList)
        ,current = model.carousel
        , label = \c ->
            [ Input.button [Element.centerY]
                { onPress = Just <|
                     SetCarousel <|
                        (\x -> if x < 0 then 0 else x) <|
                            model.carousel - 1
                , label = "<" |> Element.text
                }
            , c |> Element.text
            , Input.button [Element.centerY]
                { onPress = Just <|
                    SetCarousel <|
                        (\x -> if x > 3 then 3 else x) <|
                        model.carousel + 1
                , label = ">" |> Element.text
                }
            ]
            |> Element.row [Element.centerX, Element.width<| Element.shrink]
        }
```

-}
carousel :
    { content : ( a, Array a )
    , current : Int
    , label : a -> Element msg
    }
    -> Element msg
carousel { content, current, label } =
    let
        ( head, tail ) =
            content
    in
    (if current <= 0 then
        head

     else if current > Array.length tail then
        tail
            |> Array.get (Array.length tail - 1)
            |> Maybe.withDefault head

     else
        tail
            |> Array.get (current - 1)
            |> Maybe.withDefault head
    )
        |> label
