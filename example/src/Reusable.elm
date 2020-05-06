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
import Widget.ScrollingNav as ScrollingNav
import Widget.Snackbar as Snackbar
import Widget.SortTable as SortTable
import Data.Style exposing (Style)
import Data.Theme as Theme exposing (Theme)

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


snackbar : Style msg -> (( String, Bool ) -> msg) -> ( String, Element msg,Element msg )
snackbar style addSnackbar =
    ( "Snackbar"
    , [ Widget.button style.button
            { onPress =
                Just <|
                    addSnackbar <|
                        ( "This is a notification. It will disappear after 10 seconds."
                        , False
                        )
            , text = "Add Notification"
            , icon =Element.none
            }
      , Widget.button style.button
            { onPress =
                Just <|
                    addSnackbar <|
                        ( "You can add another notification if you want."
                        , True
                        )
            , text = "Add Notification with Action"
            , icon = Element.none
            }
      ]
        |> Element.column Grid.simple
    , Element.none
    )


sortTable : Style Msg -> SortTable.Model -> ( String, Element Msg,Element Msg )
sortTable style model =
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
    , Element.none
    )


scrollingNavCard : Style msg -> ( String, Element msg, Element msg )
scrollingNavCard style =
    ( "Scrolling Nav"
    , Element.text "Resize the screen and open the side-menu. Then start scrolling to see the scrolling navigation in action."
        |> List.singleton
        |> Element.paragraph []
    , Element.none
    )


view :
    Theme ->
    { addSnackbar : ( String, Bool ) -> msg
    , msgMapper : Msg -> msg
    , model : Model
    }
    ->
        { title : String
        , description : String
        , items : List ( String, Element msg,Element msg )
        }
view theme { addSnackbar, msgMapper, model } =
    let
        style = Theme.toStyle theme
    in
    { title = "Reusable Views"
    , description = "Reusable views have an internal state but no update function. You will need to do some wiring, but nothing complicated."
    , items =
        [ snackbar style addSnackbar
        , sortTable style model |> \(a,b,c) ->
            (a,b |> Element.map msgMapper,c |> Element.map msgMapper)
        , scrollingNavCard style
        ]
    }
