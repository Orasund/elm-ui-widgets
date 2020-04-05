module Layout exposing (Direction(..), Layout, init, queueMessage, setSidebar, timePassed, view)

import Browser.Dom exposing (Viewport)
import Core.Style as Style exposing (Style)
import Element exposing (Attribute, DeviceClass(..), Element)
import Element.Background as Background
import Element.Events as Events
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes as Attributes
import Widget
import Widget.Snackbar as Snackbar


type Direction
    = Left
    | Right


type alias Layout =
    { snackbar : Snackbar.Model String
    , sheet : Maybe Direction
    }


init : Layout
init =
    { snackbar = Snackbar.init
    , sheet = Nothing
    }


queueMessage : String -> Layout -> Layout
queueMessage message layout =
    { layout
        | snackbar = layout.snackbar |> Snackbar.insert message
    }


setSidebar : Maybe Direction -> Layout -> Layout
setSidebar direction layout =
    { layout
        | sheet = direction
    }


timePassed : Int -> Layout -> Layout
timePassed sec layout =
    case layout.sheet of
        Nothing ->
            { layout
                | snackbar = layout.snackbar |> Snackbar.timePassed sec
            }

        _ ->
            layout


view :
    List (Attribute msg)
    ->
        { deviceClass : DeviceClass
        , dialog : Maybe { onDismiss : Maybe msg, content : Element msg }
        , content : Element msg
        , layout : Layout
        , title : Element msg
        , menu :
            { selected : Int
            , items : List { label : String, icon : Element Never, onPress : Maybe msg }
            }
        , actions : List { label : String, icon : Element Never, onPress : Maybe msg }
        , onChangedSidebar : Maybe Direction -> msg
        , style : Style msg
        }
    -> Html msg
view attributes { title, onChangedSidebar, menu, actions, deviceClass, dialog, content, style, layout } =
    let
        ( primaryActions, moreActions ) =
            ( if (actions |> List.length) > 4 then
                actions |> List.take 2

              else if (actions |> List.length) == 4 then
                actions |> List.take 1

              else if (actions |> List.length) == 3 then
                []

              else
                actions |> List.take 2
            , if (actions |> List.length) > 4 then
                actions |> List.drop 2

              else if (actions |> List.length) == 4 then
                actions |> List.drop 1

              else if (actions |> List.length) == 3 then
                actions

              else
                actions |> List.drop 2
            )

        nav =
            [ (if
                (deviceClass == Phone)
                    || (deviceClass == Tablet)
                    || ((menu.items |> List.length) > 5)
               then
                [ Input.button style.menuButton
                    { onPress = Just <| onChangedSidebar <| Just Left
                    , label = style.menuIcon |> Element.map never
                    }
                , title
                ]

               else
                [ title
                , menu.items
                    |> List.indexedMap
                        (\i ->
                            if i == menu.selected then
                                Style.menuTabButtonSelected style

                            else
                                Style.menuTabButton style
                        )
                    |> Element.row
                        [ Element.width <| Element.shrink
                        ]
                ]
              )
                |> Element.row
                    [ Element.width <| Element.shrink
                    , Element.spacing 8
                    ]
            , [ primaryActions
                    |> List.map
                        (if deviceClass == Phone then
                            Style.menuIconButton style

                         else
                            Style.menuButton style
                        )
              , if moreActions |> List.isEmpty then
                    []

                else
                    [ Style.menuButton style
                        { onPress = Just <| onChangedSidebar <| Just Right
                        , icon = style.moreVerticalIcon
                        , label = ""
                        }
                    ]
              ]
                |> List.concat
                |> Element.row
                    [ Element.width <| Element.shrink
                    , Element.alignRight
                    ]
            ]
                |> Element.row
                    (style.header
                        ++ [ Element.padding 0
                           , Element.centerX
                           , Element.spaceEvenly
                           , Element.alignTop
                           , Element.width <| Element.fill
                           ]
                    )

        snackbar =
            layout.snackbar
                |> Snackbar.current
                |> Maybe.map
                    (Element.text
                        >> List.singleton
                        >> Element.paragraph style.snackbar
                        >> Element.el
                            [ Element.padding 8
                            , Element.alignBottom
                            , Element.alignRight
                            ]
                    )
                |> Maybe.withDefault Element.none
        sheet =
            case layout.sheet of
                Just Left ->
                    menu.items
                        |> List.indexedMap
                            (\i ->
                                if i == menu.selected then
                                    Style.sheetButtonSelected style

                                else
                                    Style.sheetButton style
                            )
                        |> Element.column [ Element.width <| Element.fill ]
                        |> Element.el
                            (style.sheet
                                ++ [ Element.height <| Element.fill
                                   , Element.alignLeft
                                   ]
                            )

                Just Right ->
                    moreActions
                        |> List.map (Style.sheetButton style)
                        |> Element.column [ Element.width <| Element.fill ]
                        |> Element.el
                            (style.sheet
                                ++ [ Element.height <| Element.fill
                                   , Element.alignRight
                                   ]
                            )

                Nothing ->
                    Element.none
    in
    content
        |> style.layout
            (List.concat
                [ attributes
                , [ Element.inFront nav
                  , Element.inFront snackbar
                  ]
                , if (layout.sheet /= Nothing) || (dialog /= Nothing) then
                    Widget.scrim
                        { onDismiss =
                            Just <|
                                case dialog of
                                    Just { onDismiss } ->
                                        onDismiss
                                            |> Maybe.withDefault
                                                (Nothing
                                                    |> onChangedSidebar
                                                )

                                    Nothing ->
                                        Nothing
                                            |> onChangedSidebar
                        , content = Element.none
                        }

                  else
                    []
                , [ Element.inFront sheet
                  , Element.inFront <|
                        case dialog of
                            Just element ->
                                element.content

                            Nothing ->
                                Element.none
                  ]
                ]
            )
