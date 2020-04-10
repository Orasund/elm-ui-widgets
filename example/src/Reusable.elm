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


snackbar : (String -> msg) -> Element msg
snackbar addSnackbar =
    [ Element.el Heading.h3 <| Element.text "Snackbar"
    , Input.button Button.simple
        { onPress = Just <| addSnackbar "This is a notification. It will disappear after 10 seconds."
        , label =
            "Add Notification"
                |> Element.text
                |> List.singleton
                |> Element.paragraph []
        }
    ]
        |> Element.column (Grid.simple ++ Card.large ++ [Element.height <| Element.fill])


sortTable : SortTable.Model -> Element Msg
sortTable model =
    [ Element.el Heading.h3 <| Element.text "Sort Table"
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
    ]
        |> Element.column (Grid.simple ++ Card.large ++ [Element.height <| Element.fill])

scrollingNavCard : Element msg
scrollingNavCard =
    [ Element.el Heading.h3 <| Element.text "Scrolling Nav"
    , Element.text "Resize the screen and open the side-menu. Then start scrolling to see the scrolling navigation in action."
        |> List.singleton
        |> Element.paragraph []
    ]
        |> Element.column (Grid.simple ++ Card.large ++ [Element.height <| Element.fill])


view :
    { addSnackbar : String -> msg
    , msgMapper : Msg -> msg
    , model : Model
    }
    -> Element msg
view { addSnackbar, msgMapper, model } =
    Element.column (Grid.section ++ [ Element.centerX ])
        [ Element.el Heading.h2 <| Element.text "Reusable Views"
        , "Reusable views have an internal state but no update function. You will need to do some wiring, but nothing complicated."
            |> Element.text
            |> List.singleton
            |> Element.paragraph []
        , Element.wrappedRow (Grid.simple ++ [Element.height <| Element.shrink]) <|
            [ snackbar addSnackbar
            , sortTable model |> Element.map msgMapper
            , scrollingNavCard
            ]
        ]
