module Page.Tab exposing (page)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}

import Element exposing (Element)
import Material.Icons as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Page
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Tile, TileMsg)
import Widget
import Widget.Icon as Icon
import Widget.Material as Material


{-| The title of this page
-}
title : String
title =
    "Tab"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "Tabs organize content across different screens, data sets, and other interactions."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewTab style selected options onSelect { palette } () =
            Widget.tab (style palette)
                { tabs =
                    { selected = selected
                    , options = options
                    , onSelect = onSelect
                    }
                , content =
                    \s ->
                        (case s of
                            Just 0 ->
                                "This is Tab 1"

                            Just 1 ->
                                "This is the second tab"

                            Just 2 ->
                                "The thrid and last tab"

                            _ ->
                                "Please select a tab"
                        )
                            |> Element.text
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.tab"
    in
    [ viewTab ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


{-| Let's you play around with the options.
Note that the order of these stories must follow the order of the arguments from the view functions.
-}
book : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
book =
    Story.book (Just "Options")
        viewFunctions
        --Adding a option for different styles.
        |> Story.addStory
            (Story.optionListStory "Style"
                ( "Tab", Material.tab )
                []
            )
        --Changing the text of the label
        |> Story.addStory
            (Story.optionListStory "Selected"
                ( "Third", Just 2 )
                [ ( "Second", Just 1 )
                , ( "First", Just 0 )
                , ( "Nothing or Invalid", Nothing )
                ]
            )
        --Change the Icon
        |> Story.addStory
            (Story.optionListStory "Options"
                ( "3 Option"
                , [ { icon = always Element.none, text = "42" }
                  , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "" }
                  , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "42" }
                  ]
                )
                [ ( "2 Option"
                  , [ { icon = always Element.none, text = "42" }
                    , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "" }
                    ]
                  )
                , ( "1 Option", [ { icon = always Element.none, text = "42" } ] )
                ]
            )
        --Should an event be triggered when pressing the button?
        |> Story.addStory
            (Story.boolStory "With event handler"
                ( always (Just ()), always Nothing )
                True
            )
        |> Story.build



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


type Model
    = Selected (Maybe Int)


type Msg
    = ChangedTab Int


init : ( Model, Cmd Msg )
init =
    ( Selected Nothing
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ChangedTab int ->
            ( Selected <| Just int
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } (Selected selected) =
    Widget.tab (Material.tab palette)
        { tabs =
            { selected = selected
            , options =
                [ 1, 2, 3 ]
                    |> List.map
                        (\int ->
                            { text = "Tab " ++ (int |> String.fromInt)
                            , icon = always Element.none
                            }
                        )
            , onSelect = ChangedTab >> Just
            }
        , content =
            \s ->
                (case s of
                    Just 0 ->
                        "This is Tab 1"

                    Just 1 ->
                        "This is the second tab"

                    Just 2 ->
                        "The thrid and last tab"

                    _ ->
                        "Please select a tab"
                )
                    |> Element.text
        }



--------------------------------------------------------------------------------
-- DO NOT MODIFY ANYTHING AFTER THIS LINE
--------------------------------------------------------------------------------


demo : Tile Model Msg ()
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
