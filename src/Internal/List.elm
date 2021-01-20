module Internal.List exposing (buttonColumn, buttonRow, column, row)

import Element exposing (Attribute, Element)
import Internal.Button exposing (Button)
import Internal.Select as Select
import Widget.Style exposing (ButtonStyle, ColumnStyle, RowStyle)
import Widget.Style.Customize as Customize

internal :
    { list
        | content : List (Attribute msg)
        , ifFirst : List (Attribute msg)
        , ifLast : List (Attribute msg)
        , otherwise : List (Attribute msg)
    }
    -> List (Element msg)
    -> List (Element msg)
internal style list =
    list
        |> List.indexedMap
            (\i ->
                Element.el <|
                    style.content
                        ++ (if List.length list == 1 then
                                []

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
    internal style >> Element.row style.containerRow


column : ColumnStyle msg -> List (Element msg) -> Element msg
column style =
    internal style >> Element.column style.containerColumn


internalButton :
    { list :
        { list
            | content : List (Attribute msg)
            , ifFirst : List (Attribute msg)
            , ifLast : List (Attribute msg)
            , otherwise : List (Attribute msg)
        }
    , button : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> List (Element msg)
internalButton style list =
    list
        |> List.indexedMap
            (\i ->
                Select.selectButton
                    (style.button
                        |> Customize.containerButton
                            (style.list.content
                            ++ (if List.length list == 1 then
                                    []

                                else if i == 0 then
                                    style.list.ifFirst

                                else if i == (List.length list - 1) then
                                    style.list.ifLast

                                else
                                    style.list.otherwise
                               ))
                    )
            )


buttonRow :
    { list : RowStyle msg
    , button : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonRow style =
    internalButton style >> Element.row style.list.containerRow


buttonColumn :
    { list : ColumnStyle msg
    , button : ButtonStyle msg
    }
    -> List ( Bool, Button msg )
    -> Element msg
buttonColumn style =
    internalButton style >> Element.column style.list.containerColumn
