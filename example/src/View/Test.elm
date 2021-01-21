module View.Test exposing (button, dialog, expansionPanel, list, modal, multiSelect, progressIndicator, select, sortTable, switch, tab, textInput)

import Data.Style exposing (Style)
import Element exposing (Element)
import Icons
import Set
import Widget
import Widget.Layout exposing (Part(..))
import FeatherIcons
import Widget.Icon as Icon


button : msg -> Style msg -> List ( String, Element msg )
button idle style =
    [ ( "Button"
      , Widget.button style.button
            { text = "Button"
            , icon = FeatherIcons.triangle |> Icon.elmFeather FeatherIcons.toHtml
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
            , icon = FeatherIcons.triangle |> Icon.elmFeather FeatherIcons.toHtml
            , onPress = Just idle
            }
      )
    , ( "Disabled button"
      , Widget.button style.button
            { text = "Button"
            , icon = FeatherIcons.triangle |> Icon.elmFeather FeatherIcons.toHtml
            , onPress = Nothing
            }
      )
    , ( "Inactive Select button"
      , Widget.selectButton style.button
            ( False
            , { text = "Button"
              , icon = FeatherIcons.triangle |> Icon.elmFeather FeatherIcons.toHtml
              , onPress = Just idle
              }
            )
      )
    , ( "Active Select button"
      , Widget.selectButton style.button
            ( True
            , { text = "Button"
              , icon = FeatherIcons.triangle |> Icon.elmFeather FeatherIcons.toHtml
              , onPress = Just idle
              }
            )
      )
    ]


switch : msg -> Style msg -> List ( String, Element msg )
switch idle style =
    [ ( "Disabled switch"
      , Widget.switch style.switch
            { description = "Disabled switch"
            , onPress = Nothing
            , active = False
            }
      )
    , ( "Inactive Select switch"
      , Widget.switch style.switch
            { description = "Inactive Select switch"
            , onPress = Just idle
            , active = False
            }
      )
    , ( "Active Select switch"
      , Widget.switch style.switch
            { description = "Active Select switch"
            , onPress = Just idle
            , active = True
            }
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
                        , icon = always Element.none
                        }
                    )
        , onSelect = always idle >> Just
        }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
                }
      )
    , ( "Nothing selected"
      , { selected = Nothing
        , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = always Element.none
                        }
                    )
        , onSelect = always idle >> Just
        }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
                }
      )
    , ( "Invalid selection"
      , { selected = Just -1
        , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = always  Element.none
                        }
                    )
        , onSelect = always idle >> Just
        }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
                }
      )
    , ( "Disabled selection"
      , { selected = Just 0
        , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = always Element.none
                        }
                    )
        , onSelect = always Nothing
        }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
                }
      )
    , ( "Empty Options"
      , { selected = Nothing
        , options =
            []
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = always Element.none
                        }
                    )
        , onSelect = always idle >> Just
        }
            |> Widget.select
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
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
                        , icon = always Element.none
                        }
                    )
        , onSelect = always idle >> Just
        }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
                }
      )
    , ( "Nothing selected"
      , { selected = Set.empty
        , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = always Element.none
                        }
                    )
        , onSelect = always idle >> Just
        }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
                }
      )
    , ( "Invalid selection"
      , { selected = Set.singleton -1
        , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = always Element.none
                        }
                    )
        , onSelect = always idle >> Just
        }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
                }
      )
    , ( "Disabled selection"
      , { selected = Set.singleton 0
        , options =
            [ 1, 2, 42 ]
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon =always Element.none
                        }
                    )
        , onSelect = always Nothing
        }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
                }
      )
    , ( "Empty Options"
      , { selected = Set.empty
        , options =
            []
                |> List.map
                    (\int ->
                        { text = String.fromInt int
                        , icon = always Element.none
                        }
                    )
        , onSelect = always idle >> Just
        }
            |> Widget.multiSelect
            |> Widget.buttonRow
                { list = style.buttonRow
                , button = style.selectButton
                }
      )
    ]


expansionPanel : msg -> Style msg -> List ( String, Element msg )
expansionPanel idle style =
    [ ( "Collapsed"
      , { onToggle = always idle
        , isExpanded = False
        , icon = FeatherIcons.triangle |> Icon.elmFeather FeatherIcons.toHtml
        , text = "Button"
        , content = Element.text <| "Hidden Message"
        }
            |> Widget.expansionPanel style.expansionPanel
      )
    , ( "Expanded"
      , { onToggle = always idle
        , isExpanded = True
        , icon = FeatherIcons.triangle |> Icon.elmFeather FeatherIcons.toHtml
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
                                , icon = always Element.none
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
                                , icon = always Element.none
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
            [ { icon = FeatherIcons.triangle |> Icon.elmFeather FeatherIcons.toHtml
              , text = "A"
              , onPress = Just idle
              }
            , { icon = FeatherIcons.circle |> Icon.elmFeather FeatherIcons.toHtml
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


progressIndicator : msg -> Style msg -> List ( String, Element msg )
progressIndicator _ style =
    let
        determinateIndicators =
            [ 0, 0.25, 0.5, 0.75, 1 ]
                |> List.map
                    (\completeness ->
                        ( "Completeness " ++ String.fromFloat completeness
                        , Widget.circularProgressIndicator style.progressIndicator (Just completeness)
                        )
                    )
    in
    [ ( "Indeterminate Progress Indicator"
      , Widget.circularProgressIndicator style.progressIndicator Nothing
      )
    ]
        ++ determinateIndicators
