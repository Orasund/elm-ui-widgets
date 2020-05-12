module View.Test exposing (expansionPanel, iconButton, multiSelect, select, tab)

import Array
import Data.Style exposing (Style)
import Data.Theme as Theme exposing (Theme)
import Element exposing (Element)
import Element.Background as Background
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Heroicons.Solid as Heroicons
import Html.Attributes as Attributes
import Icons
import Layout exposing (Part(..))
import Set exposing (Set)
import Widget


iconButton : msg -> Style msg -> List (Element msg)
iconButton idle style =
    [ Element.row Grid.spacedEvenly
        [ "Button"
            |> Element.text
        , Widget.button style.button
            { text = "Button"
            , icon = Icons.triangle |> Element.html |> Element.el []
            , onPress = Just idle
            }
        ]
    , Element.row Grid.spacedEvenly
        [ "Text button"
            |> Element.text
        , Widget.textButton style.button
            { text = "Button"
            , onPress = Just idle
            }
        ]
    , Element.row Grid.spacedEvenly
        [ "Icon button"
            |> Element.text
        , Widget.iconButton style.button
            { text = "Button"
            , icon = Icons.triangle |> Element.html |> Element.el []
            , onPress = Just idle
            }
        ]
    , Element.row Grid.spacedEvenly
        [ "Disabled button"
            |> Element.text
        , Widget.button style.button
            { text = "Button"
            , icon = Icons.triangle |> Element.html |> Element.el []
            , onPress = Nothing
            }
        ]
    , Element.row Grid.spacedEvenly
        [ "Inactive Select button"
            |> Element.text
        , Widget.selectButton style.button
            ( False
            , { text = "Button"
              , icon = Icons.triangle |> Element.html |> Element.el []
              , onPress = Just idle
              }
            )
        ]
    , Element.row Grid.spacedEvenly
        [ "Active Select button"
            |> Element.text
        , Widget.selectButton style.button
            ( True
            , { text = "Button"
              , icon = Icons.triangle |> Element.html |> Element.el []
              , onPress = Just idle
              }
            )
        ]
    ]


select : msg -> Style msg -> List (Element msg)
select idle style =
    [ Element.row Grid.spacedEvenly
        [ "First selected"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Just 0
          , options =
                [ 1, 2, 42 ]
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always idle >> Just
          }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    , Element.row Grid.spacedEvenly
        [ "Nothing selected"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Nothing
          , options =
                [ 1, 2, 42 ]
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always idle >> Just
          }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    , Element.row Grid.spacedEvenly
        [ "Invalid selection"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Just -1
          , options =
                [ 1, 2, 42 ]
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always idle >> Just
          }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    , Element.row Grid.spacedEvenly
        [ "Disabled selection"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Just 0
          , options =
                [ 1, 2, 42 ]
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always Nothing
          }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    , Element.row Grid.spacedEvenly
        [ "Empty Options"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Nothing
          , options =
                []
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always idle >> Just
          }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    ]


multiSelect : msg -> Style msg -> List (Element msg)
multiSelect idle style =
    [ Element.row Grid.spacedEvenly
        [ "Some selected"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Set.fromList [ 0, 1 ]
          , options =
                [ 1, 2, 42 ]
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always idle >> Just
          }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    , Element.row Grid.spacedEvenly
        [ "Nothing selected"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Set.empty
          , options =
                [ 1, 2, 42 ]
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always idle >> Just
          }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    , Element.row Grid.spacedEvenly
        [ "Invalid selection"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Set.singleton -1
          , options =
                [ 1, 2, 42 ]
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always idle >> Just
          }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    , Element.row Grid.spacedEvenly
        [ "Disabled selection"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Set.singleton 0
          , options =
                [ 1, 2, 42 ]
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always Nothing
          }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    , Element.row Grid.spacedEvenly
        [ "Empty Options"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { selected = Set.empty
          , options =
                []
                    |> List.map
                        (\int ->
                            { text = String.fromInt int
                            , icon = Element.none
                            }
                        )
          , onSelect = always idle >> Just
          }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.row
                , button = style.button
                }
        ]
    ]


expansionPanel : msg -> Style msg -> List (Element msg)
expansionPanel idle style =
    [ Element.row Grid.spacedEvenly
        [ "Collapsed"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { onToggle = always idle
          , isExpanded = False
          , icon = Icons.triangle |> Element.html |> Element.el []
          , text = "Button"
          , content = Element.text <| "Hidden Message"
          }
            |> Widget.expansionPanel style.expansionPanel
        ]
    , Element.row Grid.spacedEvenly
        [ "Expanded"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , { onToggle = always idle
          , isExpanded = True
          , icon = Icons.triangle |> Element.html |> Element.el []
          , text = "Button"
          , content = Element.text <| "Hidden Message"
          }
            |> Widget.expansionPanel style.expansionPanel
        ]
    ]


tab : msg -> Style msg -> List (Element msg)
tab idle style =
    [ Element.row Grid.spacedEvenly
        [ "Nothing selected"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , Widget.tab style.tab
            { tabs =
                { selected = Nothing
                , options =
                    [ 1, 2, 3 ]
                        |> List.map
                            (\int ->
                                { text = int |> String.fromInt
                                , icon = Element.none
                                }
                            )
                , onSelect = always idle >> Just
                }
            , content =
                \selected ->
                    (case selected of
                        Nothing ->
                            "Please select a tab"

                        _ ->
                            ""
                    )
                        |> Element.text
            }
        ]
    , Element.row Grid.spacedEvenly
        [ "Tab selected"
            |> Element.text
            |> Element.el [ Element.width <| Element.fill ]
        , Widget.tab style.tab
            { tabs =
                { selected = Just 0
                , options =
                    [ 1, 2, 3 ]
                        |> List.map
                            (\int ->
                                { text = int |> String.fromInt
                                , icon = Element.none
                                }
                            )
                , onSelect = always idle >> Just
                }
            , content =
                \selected ->
                    (case selected of
                        Just 0 ->
                            "First Tab selected"

                        _ ->
                            "Please select a tab"
                    )
                        |> Element.text
            }
        ]
    ]
