module Internal.List exposing (buttonColumn, buttonRow, column, row)

import Element exposing (Attribute, Element)
import Internal.Button exposing (Button)
import Internal.Select as Select
import Widget.Style exposing (ButtonStyle, ColumnStyle, ItemStyle, RowStyle)
import Widget.Style.Customize as Customize


internal :
    ItemStyle msg
    -> List (Element msg)
    -> List (Element msg)
internal style list =
    list
        |> List.indexedMap
            (\i ->
                Element.el <|
                    style.element
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


row : RowStyle msg -> List (Element msg) -> Element msg
row style =
    internal style.content >> Element.row style.elementRow


column : ColumnStyle msg -> List (Element msg) -> Element msg
column style =
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
        { element = style.elementRow.content.element
        , ifSingleton = style.elementRow.content.ifSingleton
        , ifFirst = style.elementRow.content.ifFirst
        , ifLast = style.elementRow.content.ifLast
        , otherwise = style.elementRow.content.otherwise
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
        { element = style.elementColumn.content.element
        , ifSingleton = style.elementColumn.content.ifSingleton
        , ifFirst = style.elementColumn.content.ifFirst
        , ifLast = style.elementColumn.content.ifLast
        , otherwise = style.elementColumn.content.otherwise
        , content = style.content
        }
        >> Element.column style.elementColumn.elementColumn
