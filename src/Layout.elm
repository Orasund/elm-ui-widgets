module Layout exposing (Layout, Part(..), activate, init, queueMessage, timePassed, view)

import Array
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


type Part
    = LeftSheet
    | RightSheet
    | Search


type alias Layout =
    { snackbar : Snackbar.Model String
    , active : Maybe Part
    }


init : Layout
init =
    { snackbar = Snackbar.init
    , active = Nothing
    }


queueMessage : String -> Layout -> Layout
queueMessage message layout =
    { layout
        | snackbar = layout.snackbar |> Snackbar.insert message
    }


activate : Maybe Part -> Layout -> Layout
activate part layout =
    { layout
        | active = part
    }


timePassed : Int -> Layout -> Layout
timePassed sec layout =
    case layout.active of
        Just LeftSheet ->
            layout

        Just RightSheet ->
            layout

        _ ->
            { layout
                | snackbar = layout.snackbar |> Snackbar.timePassed sec
            }


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
        , search :
            Maybe
                { onChange : String -> msg
                , text : String
                , label : String
                }
        , actions : List { label : String, icon : Element Never, onPress : Maybe msg }
        , onChangedSidebar : Maybe Part -> msg
        , style : Style msg
        }
    -> Html msg
view attributes { search, title, onChangedSidebar, menu, actions, deviceClass, dialog, content, style, layout } =
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
                    { onPress = Just <| onChangedSidebar <| Just LeftSheet
                    , label = style.menuIcon |> Element.map never
                    }
                , menu.items
                    |> Array.fromList
                    |> Array.get menu.selected
                    |> Maybe.map (.label >> Element.text >> Element.el style.title)
                    |> Maybe.withDefault title
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
            , if deviceClass == Phone then
                Element.none

              else
                search
                    |> Maybe.map
                        (\{ onChange, text, label } ->
                            Input.text style.search
                                { onChange = onChange
                                , text = text
                                , placeholder =
                                    Just <|
                                        Input.placeholder [] <|
                                            Element.text label
                                , label = Input.labelHidden label
                                }
                        )
                    |> Maybe.withDefault Element.none
            , [ if deviceClass == Phone then
                    search
                        |> Maybe.map
                            (\{ label } ->
                                [ Style.menuButton style
                                    { onPress = Just <| onChangedSidebar <| Just Search
                                    , icon = style.searchIcon
                                    , label = label
                                    }
                                ]
                            )
                        |> Maybe.withDefault []

                else
                    []
              , primaryActions
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
                        { onPress = Just <| onChangedSidebar <| Just RightSheet
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
            case layout.active of
                Just LeftSheet ->
                    [ [ title
                      ]
                    , menu.items
                        |> List.indexedMap
                            (\i ->
                                if i == menu.selected then
                                    Style.sheetButtonSelected style

                                else
                                    Style.sheetButton style
                            )
                    ]
                        |> List.concat
                        |> Element.column [ Element.width <| Element.fill ]
                        |> Element.el
                            (style.sheet
                                ++ [ Element.height <| Element.fill
                                   , Element.alignLeft
                                   ]
                            )

                Just RightSheet ->
                    moreActions
                        |> List.map (Style.sheetButton style)
                        |> Element.column [ Element.width <| Element.fill ]
                        |> Element.el
                            (style.sheet
                                ++ [ Element.height <| Element.fill
                                   , Element.alignRight
                                   ]
                            )

                Just Search ->
                    case search of
                        Just { onChange, text, label } ->
                            Input.text style.search
                                { onChange = onChange
                                , text = text
                                , placeholder =
                                    Just <|
                                        Input.placeholder [] <|
                                            Element.text label
                                , label = Input.labelHidden label
                                }
                                |> Element.el
                                    [ Element.alignTop
                                    , Element.width <| Element.fill
                                    ]

                        Nothing ->
                            Element.none

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
                , if (layout.active /= Nothing) || (dialog /= Nothing) then
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
