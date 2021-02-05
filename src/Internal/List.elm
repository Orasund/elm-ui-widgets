module Internal.List exposing (ColumnStyle, RowStyle, buttonColumn, buttonRow, column, itemList, row)

import Element exposing (Attribute, Element)
import Internal.Button exposing (Button, ButtonStyle)
import Internal.Item as Item exposing (Item)
import Internal.Select as Select
import Widget.Customize as Customize


{-| -}
type alias RowStyle msg =
    { elementRow : List (Attribute msg)
    , content :
        { element : List (Attribute msg)
        , ifFirst : List (Attribute msg)
        , ifLast : List (Attribute msg)
        , ifSingleton : List (Attribute msg)
        , otherwise : List (Attribute msg)
        }
    }


{-| -}
type alias ColumnStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { element : List (Attribute msg)
        , ifFirst : List (Attribute msg)
        , ifLast : List (Attribute msg)
        , ifSingleton : List (Attribute msg)
        , otherwise : List (Attribute msg)
        }
    }


internal :
    { element : List (Attribute msg)
    , ifFirst : List (Attribute msg)
    , ifLast : List (Attribute msg)
    , ifSingleton : List (Attribute msg)
    , otherwise : List (Attribute msg)
    }
    -> List (Item msg)
    -> List (Element msg)
internal style list =
    list
        |> List.indexedMap
            (\i fun ->
                fun
                    (style.element
                        ++ (if List.length list == 1 then
                                style.ifSingleton

                            else if i == 0 then
                                style.ifFirst

                            else if i == (List.length list - 1) then
                                style.ifLast

                            else
                                style.otherwise
                           )
                    )
            )


row : RowStyle msg -> List (Element msg) -> Element msg
row style =
    List.map
        (\a ->
            Item.toItem
                { element = style.content.element
                , content = ()
                }
                (always a)
        )
        >> internal style.content
        >> Element.row style.elementRow


column : ColumnStyle msg -> List (Element msg) -> Element msg
column style =
    List.map
        (\a ->
            Item.toItem
                { element = style.content.element
                , content = ()
                }
                (always a)
        )
        >> itemList style


itemList : ColumnStyle msg -> List (Item msg) -> Element msg
itemList style =
    internal style.content >> Element.column style.elementColumn


internalButton :
    { element : List (Attribute msg)
    , ifSingleton : List (Attribute msg)
    , ifFirst : List (Attribute msg)
    , ifLast : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> List (Element msg)
internalButton style list =
    list
        |> List.indexedMap
            (\i ->
                Select.selectButton
                    (style.content
                        |> Customize.elementButton
                            (style.element
                                ++ (if List.length list == 1 then
                                        style.ifSingleton

                                    else if i == 0 then
                                        style.ifFirst

                                    else if i == (List.length list - 1) then
                                        style.ifLast

                                    else
                                        style.otherwise
                                   )
                            )
                    )
            )


buttonRow :
    { elementRow : RowStyle msg
    , content : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonRow style =
    internalButton
        { element =
            style.elementRow.content.element
        , ifSingleton =
            style.elementRow.content.ifSingleton
        , ifFirst =
            style.elementRow.content.ifFirst
        , ifLast =
            style.elementRow.content.ifLast
        , otherwise =
            style.elementRow.content.otherwise
        , content = style.content
        }
        >> Element.row style.elementRow.elementRow


buttonColumn :
    { elementColumn : ColumnStyle msg
    , content : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonColumn style =
    internalButton
        { element =
            style.elementColumn.content.element
        , ifSingleton =
            style.elementColumn.content.ifSingleton
        , ifFirst =
            style.elementColumn.content.ifFirst
        , ifLast =
            style.elementColumn.content.ifLast
        , otherwise =
            style.elementColumn.content.otherwise
        , content = style.content
        }
        >> Element.column style.elementColumn.elementColumn
