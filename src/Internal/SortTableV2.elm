module Internal.SortTableV2 exposing
    ( ColumnV2
    , ColumnTypeV2
    , SortTableV2
    , floatColumnV2
    , intColumnV2
    , sortTableV2
    , stringColumnV2
    , unsortableColumnV2
    , customColumnV2
    )

import Element exposing (Attribute, Element, Length)
import Internal.Button as Button exposing (ButtonStyle)
import Widget.Icon exposing (Icon)
import Internal.SortTable as SortTable


{-| A Sortable list allows you to sort column.
-}
type ColumnTypeV2 a msg
    = StringColumn { value : a -> String, toString : String -> String }
    | IntColumn { value : a -> Int, toString : Int -> String }
    | FloatColumn { value : a -> Float, toString : Float -> String }
    | CustomColumn { value : a -> Element msg }
    | UnsortableColumn (a -> String)


{-| The Model contains the sorting column name and if ascending or descending.
-}
type alias SortTableV2 a msg =
    { content : List a
    , columns : List (ColumnV2 a msg)
    , sortBy : String
    , asc : Bool
    , onChange : String -> msg
    }


type ColumnV2 a msg
    = Column
        { title : String
        , content : ColumnTypeV2 a msg
        , width : Length
        }


unsortableColumnV2 : { title : String, toString : a -> String, width : Length } -> ColumnV2 a msg
unsortableColumnV2 { title, toString, width } =
    Column
        { title = title
        , content = UnsortableColumn toString
        , width = width
        }


{-| A Column containing a Int
-}
intColumnV2 : { title : String, value : a -> Int, toString : Int -> String, width : Length } -> ColumnV2 a msg
intColumnV2 { title, value, toString, width } =
    Column
        { title = title
        , content = IntColumn { value = value, toString = toString }
        , width = width
        }


{-| A Column containing a Float
-}
floatColumnV2 : { title : String, value : a -> Float, toString : Float -> String, width : Length } -> ColumnV2 a msg
floatColumnV2 { title, value, toString, width } =
    Column
        { title = title
        , content = FloatColumn { value = value, toString = toString }
        , width = width
        }


{-| A Column containing a String
-}
stringColumnV2 : { title : String, value : a -> String, toString : String -> String, width : Length } -> ColumnV2 a msg
stringColumnV2 { title, value, toString, width } =
    Column
        { title = title
        , content = StringColumn { value = value, toString = toString }
        , width = width
        }

{-| A Column containing an Element
-}
customColumnV2 : { title : String, value : a -> Element msg, width : Length } -> ColumnV2 a msg
customColumnV2 { title, value, width } =
    Column
        { title = title
        , content = CustomColumn { value = value }
        , width = width
        }


{-| The View
-}
sortTableV2 :
    SortTable.SortTableStyle msg
    -> SortTableV2 a msg
    -> Element msg
sortTableV2 style model =
    let
        findTitle : List (ColumnV2 a msg) -> Maybe (ColumnTypeV2 a msg)
        findTitle list =
            case list of
                [] ->
                    Nothing

                (Column head) :: tail ->
                    if head.title == model.sortBy then
                        Just head.content

                    else
                        findTitle tail
    in
    Element.table style.elementTable
        { data =
            model.content
                |> (model.columns
                        |> findTitle
                        |> Maybe.andThen
                            (\c ->
                                case c of
                                    StringColumn { value } ->
                                        Just <| List.sortBy value

                                    IntColumn { value } ->
                                        Just <| List.sortBy value

                                    FloatColumn { value } ->
                                        Just <| List.sortBy value

                                    CustomColumn _ ->
                                        Nothing

                                    UnsortableColumn _ ->
                                        Nothing
                            )
                        |> Maybe.withDefault identity
                   )
                |> (if model.asc then
                        identity

                    else
                        List.reverse
                   )
        , columns =
            model.columns
                |> List.map
                    (\(Column column) ->
                        { header =
                            Button.button style.content.header
                                { text = column.title
                                , icon =
                                    if column.title == model.sortBy then
                                        if model.asc then
                                            style.content.ascIcon

                                        else
                                            style.content.descIcon

                                    else
                                        style.content.defaultIcon
                                , onPress =
                                    case column.content of
                                        UnsortableColumn _ ->
                                            Nothing

                                        CustomColumn _ ->
                                            Nothing

                                        _ ->
                                            Just <| model.onChange <| column.title
                                }
                        , width = column.width
                        , view =
                            (case column.content of
                                IntColumn { value, toString } ->
                                    value
                                        >> toString
                                        >> Element.text
                                        >> List.singleton
                                        >> Element.paragraph []

                                FloatColumn { value, toString } ->
                                    value
                                        >> toString
                                        >> Element.text
                                        >> List.singleton
                                        >> Element.paragraph []

                                StringColumn { value, toString } ->
                                    value
                                        >> toString
                                        >> Element.text
                                        >> List.singleton
                                        >> Element.paragraph []

                                CustomColumn { value } ->
                                    value >> Element.el []

                                UnsortableColumn toString ->
                                    toString >> Element.text
                            )
                        }
                    )
        }
