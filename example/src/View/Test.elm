module View.Test exposing (button, dialog, expansionPanel, list, modal, multiSelect, select, sortTable, tab, textInput)

import Data.Style exposing (Style)
import Element exposing (Element)
import Icons
import Set
import Widget
import Widget.Layout exposing (Part(..))


button : msg -> Style msg -> List ( String, Element msg )
button idle style =
    [ ( "Button"
      , Widget.button style.button
            { text = "Button"
            , icon = Icons.triangle |> Element.html |> Element.el []
            , onPress = Just idle
            }
      )
    , ( "Text button"
      , Widget.textButton style.button
            { text = "Button"
            , onPress = Just idle
            }
      )
    , ( "Icon button"
      , Widget.iconButton style.button
            { text = "Button"
            , icon = Icons.triangle |> Element.html |> Element.el []
            , onPress = Just idle
            }
      )
    , ( "Disabled button"
      , Widget.button style.button
            { text = "Button"
            , icon = Icons.triangle |> Element.html |> Element.el []
            , onPress = Nothing
            }
      )
    , ( "Inactive Select button"
      , Widget.selectButton style.button
            ( False
            , { text = "Button"
              , icon = Icons.triangle |> Element.html |> Element.el []
              , onPress = Just idle
              }
            )
      )
    , ( "Active Select button"
      , Widget.selectButton style.button
            ( True
            , { text = "Button"
              , icon = Icons.triangle |> Element.html |> Element.el []
              , onPress = Just idle
              }
            )
      )
    ]


select : msg -> Style msg -> List ( String, Element msg )
select idle style =
    [ ( "First selected"
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
      )
    , ( "Nothing selected"
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
      )
    , ( "Invalid selection"
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
      )
    , ( "Disabled selection"
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
      )
    , ( "Empty Options"
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
      )
    ]


multiSelect : msg -> Style msg -> List ( String, Element msg )
multiSelect idle style =
    [ ( "Some selected"
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
      )
    , ( "Nothing selected"
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
      )
    , ( "Invalid selection"
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
      )
    , ( "Disabled selection"
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
      )
    , ( "Empty Options"
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
      )
    ]


expansionPanel : msg -> Style msg -> List ( String, Element msg )
expansionPanel idle style =
    [ ( "Collapsed"
      , { onToggle = always idle
        , isExpanded = False
        , icon = Icons.triangle |> Element.html |> Element.el []
        , text = "Button"
        , content = Element.text <| "Hidden Message"
        }
            |> Widget.expansionPanel style.expansionPanel
      )
    , ( "Expanded"
      , { onToggle = always idle
        , isExpanded = True
        , icon = Icons.triangle |> Element.html |> Element.el []
        , text = "Button"
        , content = Element.text <| "Hidden Message"
        }
            |> Widget.expansionPanel style.expansionPanel
      )
    ]


tab : msg -> Style msg -> List ( String, Element msg )
tab idle style =
    [ ( "Nothing selected"
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
      )
    , ( "Tab selected"
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
      )
    ]


sortTable : msg -> Style msg -> List ( String, Element msg )
sortTable idle style =
    [ ( "Int column"
      , Widget.sortTable style.sortTable
            { content =
                [ { id = 1, name = "Antonio", rating = 2.456, hash = Nothing }
                , { id = 2, name = "Ana", rating = 1.34, hash = Just "45jf" }
                ]
            , columns =
                [ Widget.intColumn
                    { title = "Id"
                    , value = .id
                    , toString = \int -> "#" ++ String.fromInt int
                    , width = Element.fill
                    }
                , Widget.stringColumn
                    { title = "Name"
                    , value = .name
                    , toString = identity
                    , width = Element.fill
                    }
                ]
            , asc = True
            , sortBy = "Id"
            , onChange = always idle
            }
      )
    , ( "Name column"
      , Widget.sortTable style.sortTable
            { content =
                [ { id = 1, name = "Antonio", rating = 2.456, hash = Nothing }
                , { id = 2, name = "Ana", rating = 1.34, hash = Just "45jf" }
                ]
            , columns =
                [ Widget.stringColumn
                    { title = "Name"
                    , value = .name
                    , toString = identity
                    , width = Element.fill
                    }
                , Widget.floatColumn
                    { title = "Rating"
                    , value = .rating
                    , toString = String.fromFloat
                    , width = Element.fill
                    }
                ]
            , asc = True
            , sortBy = "Name"
            , onChange = always idle
            }
      )
    , ( "Float column"
      , Widget.sortTable style.sortTable
            { content =
                [ { id = 1, name = "Antonio", rating = 2.456, hash = Nothing }
                , { id = 2, name = "Ana", rating = 1.34, hash = Just "45jf" }
                ]
            , columns =
                [ Widget.floatColumn
                    { title = "Rating"
                    , value = .rating
                    , toString = String.fromFloat
                    , width = Element.fill
                    }
                , Widget.unsortableColumn
                    { title = "Hash"
                    , toString = .hash >> Maybe.withDefault "None"
                    , width = Element.fill
                    }
                ]
            , asc = False
            , sortBy = "Rating"
            , onChange = always idle
            }
      )
    , ( "Unsortable column"
      , Widget.sortTable style.sortTable
            { content =
                [ { id = 1, name = "Antonio", rating = 2.456, hash = Nothing }
                , { id = 2, name = "Ana", rating = 1.34, hash = Just "45jf" }
                ]
            , columns =
                [ Widget.floatColumn
                    { title = "Rating"
                    , value = .rating
                    , toString = String.fromFloat
                    , width = Element.fill
                    }
                , Widget.unsortableColumn
                    { title = "Hash"
                    , toString = .hash >> Maybe.withDefault "None"
                    , width = Element.fill
                    }
                ]
            , asc = True
            , sortBy = "Hash"
            , onChange = always idle
            }
      )
    , ( "Empty Table"
      , Widget.sortTable style.sortTable
            { content =
                [ { id = 1, name = "Antonio", rating = 2.456, hash = Nothing }
                , { id = 2, name = "Ana", rating = 1.34, hash = Just "45jf" }
                ]
            , columns = []
            , asc = True
            , sortBy = ""
            , onChange = always idle
            }
      )
    ]


modal : msg -> Style msg -> List ( String, Element msg )
modal _ _ =
    []


dialog : msg -> Style msg -> List ( String, Element msg )
dialog _ _ =
    []


textInput : msg -> Style msg -> List ( String, Element msg )
textInput idle style =
    [ ( "Nothing Selected"
      , { chips = []
        , text = ""
        , placeholder = Nothing
        , label = "Label"
        , onChange = always idle
        }
            |> Widget.textInput style.textInput
      )
    , ( "Some chips"
      , { chips =
            [ { icon = Icons.triangle |> Element.html |> Element.el []
              , text = "A"
              , onPress = Just idle
              }
            , { icon = Icons.circle |> Element.html |> Element.el []
              , text = "B"
              , onPress = Just idle
              }
            ]
        , text = ""
        , placeholder = Nothing
        , label = "Label"
        , onChange = always idle
        }
            |> Widget.textInput style.textInput
      )
    ]


list : msg -> Style msg -> List ( String, Element msg )
list _ style =
    [ ( "Row"
      , [ Element.text "A"
        , Element.text "B"
        , Element.text "C"
        ]
            |> Widget.row style.row
      )
    , ( "Column"
      , [ Element.text "A"
        , Element.text "B"
        , Element.text "C"
        ]
            |> Widget.column style.cardColumn
      )
    , ( "Singleton List"
      , [ Element.text "A"
        ]
            |> Widget.column style.cardColumn
      )
    , ( "Empty List"
      , []
            |> Widget.column style.cardColumn
      )
    ]
