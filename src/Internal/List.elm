module Internal.List exposing (ColumnStyle, DividerStyle, Item, ItemStyle, RowStyle, HeaderStyle, buttonColumn, buttonRow, column, divider, headerItem, item, itemList, row, toItem)

import Element exposing (Attribute, Element)
import Internal.Button exposing (Button, ButtonStyle)
import Internal.Select as Select
import Widget.Style.Customize as Customize exposing (content)


{-| -}
type alias ItemStyle content =
    { element : List (Attribute Never)
    , content : content
    }


{-| -}
type alias DividerStyle msg =
    { element : List (Attribute msg)
    }


{-| -}
type alias HeaderStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { divider : DividerStyle msg
        , title : List (Attribute msg)
        }
    }


{-| -}
type alias RowStyle msg =
    { elementRow : List (Attribute msg)
    , content :
        { element : List (Attribute Never)
        , ifFirst : List (Attribute Never)
        , ifLast : List (Attribute Never)
        , ifSingleton : List (Attribute Never)
        , otherwise : List (Attribute Never)
        }
    }


{-| -}
type alias ColumnStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { element : List (Attribute Never)
        , ifFirst : List (Attribute Never)
        , ifLast : List (Attribute Never)
        , ifSingleton : List (Attribute Never)
        , otherwise : List (Attribute Never)
        }
    }


type alias Item msg =
    List (Attribute msg) -> Element msg


item : Element msg -> Item msg
item element =
    toItem
        { element = []
        , content = ()
        }
        (always element)


divider : ItemStyle (DividerStyle msg) -> Item msg
divider style =
    toItem style (\{ element } -> Element.none |> Element.el element)


headerItem : ItemStyle (HeaderStyle msg) -> String -> Item msg
headerItem style title =
    toItem style
        (\{ elementColumn, content } ->
            [ Element.none
                |> Element.el content.divider.element
            , title
                |> Element.text
                |> Element.el content.title
            ]
                |> Element.column elementColumn
        )


toItem : ItemStyle style -> (style -> Element msg) -> Item msg
toItem style element =
    \attr ->
        element style.content
            |> Element.el
                (attr ++ (style.element |> List.map (Element.mapAttribute never)))


internal :
    { element : List (Attribute Never)
    , ifFirst : List (Attribute Never)
    , ifLast : List (Attribute Never)
    , ifSingleton : List (Attribute Never)
    , otherwise : List (Attribute Never)
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
                        |> List.map (Element.mapAttribute never)
                    )
            )


row : RowStyle msg -> List (Element msg) -> Element msg
row style =
    List.map
        (\a ->
            toItem
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
            toItem
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
                |> List.map (Element.mapAttribute never)
        , ifSingleton =
            style.elementRow.content.ifSingleton
                |> List.map (Element.mapAttribute never)
        , ifFirst =
            style.elementRow.content.ifFirst
                |> List.map (Element.mapAttribute never)
        , ifLast =
            style.elementRow.content.ifLast
                |> List.map (Element.mapAttribute never)
        , otherwise =
            style.elementRow.content.otherwise
                |> List.map (Element.mapAttribute never)
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
                |> List.map (Element.mapAttribute never)
        , ifSingleton =
            style.elementColumn.content.ifSingleton
                |> List.map (Element.mapAttribute never)
        , ifFirst =
            style.elementColumn.content.ifFirst
                |> List.map (Element.mapAttribute never)
        , ifLast =
            style.elementColumn.content.ifLast
                |> List.map (Element.mapAttribute never)
        , otherwise =
            style.elementColumn.content.otherwise
                |> List.map (Element.mapAttribute never)
        , content = style.content
        }
        >> Element.column style.elementColumn.elementColumn
