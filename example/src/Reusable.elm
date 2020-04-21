module Reusable exposing (Model, Msg, init, update, view)

import Browser
import Element exposing (Color, Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Framework
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Framework.Group as Group
import Framework.Heading as Heading
import Framework.Input as Input
import Framework.Tag as Tag
import Heroicons.Solid as Heroicons
import Html exposing (Html)
import Html.Attributes as Attributes
import Set exposing (Set)
import Time
import Widget
import Widget.FilterSelect as FilterSelect
import Widget.ScrollingNav as ScrollingNav
import Widget.Snackbar as Snackbar
import Widget.SortTable as SortTable
import Widget.ValidatedInput as ValidatedInput


type alias Model =
    SortTable.Model


type Msg
    = SortBy { title : String, asc : Bool }


type alias Item =
    { name : String
    , amount : Int
    , price : Float
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SortBy m ->
            m


init : Model
init =
    SortTable.sortBy { title = "Name", asc = True }


snackbar : ((String,Bool) -> msg) -> (String,Element msg)
snackbar addSnackbar =
    ( "Snackbar"
    , [Input.button Button.simple
        { onPress = Just <| addSnackbar <|
            ("This is a notification. It will disappear after 10 seconds."
            , False
            )
        , label =
            "Add Notification"
                |> Element.text
                |> List.singleton
                |> Element.paragraph []
        }
    ,  Input.button Button.simple
        { onPress = Just <| addSnackbar <|
            ("You can add another notification if you want."
            , True
            )
        , label =
            "Add Notification with Action"
                |> Element.text
                |> List.singleton
                |> Element.paragraph []
        }
    ] |> Element.column Grid.simple
    )

sortTable : SortTable.Model -> (String,Element Msg)
sortTable model =
    ( "Sort Table"
    , SortTable.view
        { content =
            [ { id = 1, name = "Antonio", rating = 2.456 }
            , { id = 2, name = "Ana", rating = 1.34 }
            , { id = 3, name = "Alfred", rating = 4.22 }
            , { id = 4, name = "Thomas", rating = 3 }
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
        |> (\{ data, columns } ->
                { data = data
                , columns =
                    columns
                        |> List.map
                            (\config ->
                                { header =
                                    Input.button [ Font.bold ]
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
                                                , Element.html <|
                                                    if model.asc then
                                                        Heroicons.cheveronUp [ Attributes.width 16 ]

                                                    else
                                                        Heroicons.cheveronDown [ Attributes.width 16 ]
                                                ]
                                                    |> Element.row (Grid.simple ++ [ Font.bold ])

                                            else
                                                config.header |> Element.text
                                        }
                                , view = config.view >> Element.text
                                , width = Element.fill
                                }
                            )
                }
           )
        |> Element.table Grid.simple
    )

scrollingNavCard : (String , Element msg )
scrollingNavCard =
    ("Scrolling Nav"
    , Element.text "Resize the screen and open the side-menu. Then start scrolling to see the scrolling navigation in action."
        |> List.singleton
        |> Element.paragraph []
    )

view :
    { addSnackbar : (String,Bool) -> msg
    , msgMapper : Msg -> msg
    , model : Model
    }
    -> { title : String
        , description : String
        , items : List (String,Element msg)
        }
view { addSnackbar, msgMapper, model } =
    { title = "Reusable Views"
    , description = "Reusable views have an internal state but no update function. You will need to do some wiring, but nothing complicated."
    , items =
        [ snackbar addSnackbar
        , sortTable model |> Tuple.mapSecond (Element.map msgMapper)
        , scrollingNavCard
        ]
    }
