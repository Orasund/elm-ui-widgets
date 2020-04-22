module Widget exposing
    ( select, multiSelect, collapsable, carousel, modal, tab, dialog
    , Dialog, Select, selectButton, textInput
    )

{-| This module contains functions for displaying data.

@docs select, multiSelect, collapsable, carousel, modal, tab, dialog

-}

import Array exposing (Array)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Events as Events
import Element.Input as Input exposing (Placeholder)
import Set exposing (Set)
import Widget.Button as Button exposing (Button, ButtonStyle, TextButton)


type alias Select msg =
    { selected : Maybe Int
    , options :
        List
            { text : String
            , icon : Element Never
            }
    , onSelect : Int -> Maybe msg
    }


type alias Dialog msg =
    { title : Maybe String
    , body : Element msg
    , accept : Maybe (TextButton msg)
    , dismiss : Maybe (TextButton msg)
    }


{-| A simple button
-}
selectButton :
    ButtonStyle msg
    -> ( Bool, Button msg )
    -> Element msg
selectButton style ( selected, b ) =
    b
        |> Button.view
            { style
                | container =
                    style.container
                        ++ (if selected then
                                style.active

                            else
                                []
                           )
            }


{-| Selects one out of multiple options. This can be used for radio buttons or Menus.
-}
select :
    Select msg
    -> List ( Bool, Button msg )
select { selected, options, onSelect } =
    options
        |> List.indexedMap
            (\i a ->
                ( selected == Just i
                , { onPress = i |> onSelect
                  , text = a.text
                  , icon = a.icon
                  }
                )
            )


{-| Selects multible options. This can be used for checkboxes.
-}
multiSelect :
    { selected : Set Int
    , options :
        List
            { text : String
            , icon : Element Never
            }
    , onSelect : Int -> Maybe msg
    }
    -> List ( Bool, Button msg )
multiSelect { selected, options, onSelect } =
    options
        |> List.indexedMap
            (\i a ->
                ( selected |> Set.member i
                , { onPress = i |> onSelect
                  , text = a.text
                  , icon = a.icon
                  }
                )
            )


{-| -}
textInput :
    { chip : ButtonStyle msg
    , containerRow : List (Attribute msg)
    , chipsRow : List (Attribute msg)
    , input : List (Attribute msg)
    }
    ->
        { chips : List (Button msg)
        , text : String
        , placeholder : Maybe (Placeholder msg)
        , label : String
        , onChange : String -> msg
        }
    -> Element msg
textInput style { chips, placeholder, label, text, onChange } =
    Element.row style.containerRow
        [ chips
            |> List.map (Button.view style.chip)
            |> Element.row style.chipsRow
        , Input.text style.input
            { onChange = onChange
            , text = text
            , placeholder = placeholder
            , label = Input.labelHidden label
            }
        ]


{-| Some collapsable content.
-}
collapsable :
    { containerColumn : List (Attribute msg)
    , button : List (Attribute msg)
    }
    ->
        { onToggle : Bool -> msg
        , isCollapsed : Bool
        , label : Element msg
        , content : Element msg
        }
    -> Element msg
collapsable style { onToggle, isCollapsed, label, content } =
    Element.column style.containerColumn <|
        [ Input.button style.button
            { onPress = Just <| onToggle <| not isCollapsed
            , label = label
            }
        ]
            ++ (if isCollapsed then
                    []

                else
                    [ content ]
               )


{-| Displayes a list of contents in a tab
-}
tab :
    { button : ButtonStyle msg
    , optionRow : List (Attribute msg)
    , containerColumn : List (Attribute msg)
    }
    -> Select msg
    -> (Maybe Int -> Element msg)
    -> Element msg
tab style options content =
    [ options
        |> select
        |> List.map (selectButton style.button)
        |> Element.row style.optionRow
    , options.selected
        |> content
    ]
        |> Element.column style.containerColumn


dialog :
    { containerColumn : List (Attribute msg)
    , title : List (Attribute msg)
    , buttonRow : List (Attribute msg)
    , accept : ButtonStyle msg
    , dismiss : ButtonStyle msg
    }
    -> Dialog msg
    -> { onDismiss : Maybe msg, content : Element msg }
dialog style { title, body, accept, dismiss } =
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
            (style.containerColumn
                ++ [ Element.centerX
                   , Element.centerY
                   ]
            )
            [ title
                |> Maybe.map
                    (Element.text
                        >> Element.el style.title
                    )
                |> Maybe.withDefault Element.none
            , body
            , Element.row
                (style.buttonRow
                    ++ [ Element.alignRight
                       , Element.width <| Element.shrink
                       ]
                )
                (case ( accept, dismiss ) of
                    ( Just acceptButton, Nothing ) ->
                        acceptButton
                            |> Button.viewTextOnly style.accept
                            |> List.singleton

                    ( Just acceptButton, Just dismissButton ) ->
                        [ dismissButton
                            |> Button.viewTextOnly style.dismiss
                        , acceptButton
                            |> Button.viewTextOnly style.accept
                        ]

                    _ ->
                        []
                )
            ]
    }


{-| A modal.

NOTE: to stop the screen from scrolling, just set the height of the layout to the height of the screen.

-}
modal : { onDismiss : Maybe msg, content : Element msg } -> List (Attribute msg)
modal { onDismiss, content } =
    [ Element.el
        ([ Element.width <| Element.fill
         , Element.height <| Element.fill
         , Background.color <| Element.rgba255 0 0 0 0.5
         ]
            ++ (onDismiss
                    |> Maybe.map (Events.onClick >> List.singleton)
                    |> Maybe.withDefault []
               )
        )
        content
        |> Element.inFront
    , Element.clip
    ]


{-| A Carousel circles through a non empty list of contents.

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
