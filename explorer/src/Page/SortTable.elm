module Page.SortTable exposing (page)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}

import Element exposing (Element)
import Material.Icons.Types exposing (Coloring(..))
import Page
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Tile, TileMsg)
import Widget
import Widget.Material as Material


{-| The title of this page
-}
title : String
title =
    "Sort Table"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "A simple sort table."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewTable style content columns asc sortBy { palette } () =
            Widget.sortTable (style palette)
                { content = content
                , columns = columns
                , asc = asc
                , sortBy = sortBy
                , onChange = always ()
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.sortTable"
    in
    [ viewTable ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


{-| Let's you play around with the options.
Note that the order of these stories must follow the order of the arguments from the view functions.
-}
book : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) flags
book =
    Story.book (Just "Options")
        viewFunctions
        --Adding a option for different styles.
        |> Story.addStory
            (Story.optionListStory "Style"
                ( "SortTable", Material.sortTable )
                []
            )
        |> Story.addStory
            (Story.optionListStory "Content"
                ( "Data"
                , [ { id = 1, name = "Antonio", rating = 2.456, hash = Nothing }
                  , { id = 2, name = "Ana", rating = 1.34, hash = Just "45jf" }
                  , { id = 3, name = "Alfred", rating = 4.22, hash = Just "6fs1" }
                  , { id = 4, name = "Thomas", rating = 3, hash = Just "k52f" }
                  ]
                )
                [ ( "None", [] )
                ]
            )
        --Changing the text of the label
        |> Story.addStory
            (Story.optionListStory "Columns"
                ( "4 Columns"
                , [ Widget.intColumn
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
                  , Widget.floatColumn
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
                )
                [ ( "1 Column"
                  , [ Widget.intColumn
                        { title = "Id"
                        , value = .id
                        , toString = \int -> "#" ++ String.fromInt int
                        , width = Element.fill
                        }
                    ]
                  )
                , ( "None", [] )
                ]
            )
        --Change the Icon
        |> Story.addStory
            (Story.boolStory "Sort ascendingly"
                ( True
                , False
                )
                True
            )
        |> Story.addStory
            (Story.optionListStory "Sort by"
                ( "Id", "Id" )
                [ ( "Name", "Name" )
                , ( "Rating", "Rating" )
                , ( "Hash", "Hash" )
                , ( "None", "" )
                ]
            )
        |> Story.build



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


type alias Model =
    { title : String
    , asc : Bool
    }


type Msg
    = ChangedSorting String


init : ( Model, Cmd Msg )
init =
    ( { title = "Name", asc = True }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedSorting string ->
            ( { title = string
              , asc =
                    if model.title == string then
                        not model.asc

                    else
                        True
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } model =
    Widget.sortTable (Material.sortTable palette)
        { content =
            [ { id = 1, name = "Antonio", rating = 2.456, hash = Nothing }
            , { id = 2, name = "Ana", rating = 1.34, hash = Just "45jf" }
            , { id = 3, name = "Alfred", rating = 4.22, hash = Just "6fs1" }
            , { id = 4, name = "Thomas", rating = 3, hash = Just "k52f" }
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
            , Widget.floatColumn
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
        , asc = model.asc
        , sortBy = model.title
        , onChange = ChangedSorting
        }



--------------------------------------------------------------------------------
-- DO NOT MODIFY ANYTHING AFTER THIS LINE
--------------------------------------------------------------------------------


demo : Tile Model Msg flags
demo =
    { init = always init
    , update = update
    , view = Page.demo view
    , subscriptions = subscriptions
    }


page =
    Page.create
        { title = title
        , description = description
        , book = book
        , demo = demo
        }
