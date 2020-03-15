module Widget.SortTable exposing
    ( Model, init, view, sortBy
    , intColumn, floatColumn, stringColumn
    )

{-| A Sortable list allows you to sort coulmn.

```
    SortTable.view
        { content =
            [ {id = 1, name = "Antonio", rating = 2.456}
            , {id = 2, name = "Ana", rating = 1.34}
            , {id = 3, name = "Alfred", rating = 4.22}
            , {id = 4, name = "Thomas", rating = 3 }
            ]
        , columns =
            [ SortTable.intColumn
                { title = "Id"
                , value = .id
                , toString = \int -> "#" ++ String.fromInt int
                }
            , SortTable.stringColumn
                { title = "Name"
                , value = .name
                , toString = identity
                }
            , SortTable.floatColumn
                { title = "rating"
                , value = .rating
                , toString = String.fromFloat
                }
            ]
        , model = model
        }
        |> (\{data,columns} ->
            {data = data
            ,columns = columns
                |> List.map (\config->
                        { header =
                            Input.button [Font.bold]
                                { onPress =
                                    { title = config.header
                                    , asc =
                                        if config.header == model.title then
                                            not model.asc
                                        else
                                            True
                                    }
                                        |> SortBy
                                        |> Just
                                , label =
                                    if config.header == model.title then
                                        [ config.header |> Element.text
                                        , Element.text <|
                                            if model.asc then
                                                "/\"
                                            else
                                                "\/"
                                        ]
                                            |> Element.row [Font.bold]
                                    else
                                        config.header  |> Element.text
                                }
                        , view = config.view >> Element.text
                        , width = Element.fill
                        }
                    )
            })
        |> Element.table []
```


# Basics

@docs Model, init, view, sortBy


# Columns

@docs intColumn, floatColumn, stringColumn

-}


type ColumnType a
    = StringColumn { value : a -> String, toString : String -> String }
    | IntColumn { value : a -> Int, toString : Int -> String }
    | FloatColumn { value : a -> Float, toString : Float -> String }


{-| The Model contains the sorting column name and if ascending or descending.
-}
type alias Model =
    { title : String
    , asc : Bool
    }


type alias Column a =
    { title : String
    , content : ColumnType a
    }


{-| The initial State setting the sorting column name to the empty string.
-}
init : Model
init =
    { title = "", asc = True }


{-| A Column containing a Int
-}
intColumn : { title : String, value : a -> Int, toString : Int -> String } -> Column a
intColumn { title, value, toString } =
    { title = title
    , content = IntColumn { value = value, toString = toString }
    }


{-| A Column containing a Float
-}
floatColumn : { title : String, value : a -> Float, toString : Float -> String } -> Column a
floatColumn { title, value, toString } =
    { title = title
    , content = FloatColumn { value = value, toString = toString }
    }


{-| A Column containing a String
-}
stringColumn : { title : String, value : a -> String, toString : String -> String } -> Column a
stringColumn { title, value, toString } =
    { title = title
    , content = StringColumn { value = value, toString = toString }
    }


{-| Change the sorting criteras.

```
    sortBy =
        identity
```

-}
sortBy : { title : String, asc : Bool } -> Model
sortBy =
    identity


{-| The View
-}
view :
    { content : List a
    , columns : List (Column a)
    , model : Model
    }
    ->
        { data : List a
        , columns : List { header : String, view : a -> String }
        }
view { content, columns, model } =
    let
        findTitle : List (Column a) -> Maybe (ColumnType a)
        findTitle list =
            case list of
                [] ->
                    Nothing

                head :: tail ->
                    if head.title == model.title then
                        Just head.content

                    else
                        findTitle tail
    in
    { data =
        content
            |> (columns
                    |> findTitle
                    |> Maybe.map
                        (\c ->
                            case c of
                                StringColumn { value } ->
                                    List.sortBy value

                                IntColumn { value } ->
                                    List.sortBy value

                                FloatColumn { value } ->
                                    List.sortBy value
                        )
                    |> Maybe.withDefault identity
               )
            |> (if model.asc then
                    identity

                else
                    List.reverse
               )
    , columns =
        columns
            |> List.map
                (\column ->
                    { header = column.title
                    , view =
                        case column.content of
                            IntColumn { value, toString } ->
                                value >> toString

                            FloatColumn { value, toString } ->
                                value >> toString

                            StringColumn { value, toString } ->
                                value >> toString
                    }
                )
    }
