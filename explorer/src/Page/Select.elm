module Page.Select exposing (page)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}

import Element exposing (Element)
import Element.Background as Background
import Element.Font
import Material.Icons as MaterialIcons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import Page
import UIExplorer
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Position, Tile, TileMsg)
import Widget exposing (ButtonStyle)
import Widget.Customize as Customize
import Widget.Icon as Icon exposing (Icon)
import Widget.Material as Material exposing (Palette)
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


{-| The title of this page
-}
title : String
title =
    "Select"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "Select buttons group a set of actions using layout and spacing."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewSelectButtonRow style selected options onSelect { palette } () =
            Widget.select
                { selected = selected
                , options = options
                , onSelect = onSelect
                }
                |> Widget.buttonRow
                    { elementRow = Material.buttonRow
                    , content = style palette
                    }
                --Don't forget to change the title
                |> Page.viewTile "Widget.buttonRow with Material.buttonRow"

        viewSelectRow style selected options onSelect { palette } () =
            Widget.select
                { selected = selected
                , options = options
                , onSelect = onSelect
                }
                |> Widget.buttonRow
                    { elementRow = Material.row
                    , content = style palette
                    }
                --Don't forget to change the title
                |> Page.viewTile "Widget.buttonRow with Material.row"

        viewSelectColumn style selected options onSelect { palette } () =
            Widget.select
                { selected = selected
                , options = options
                , onSelect = onSelect
                }
                |> Widget.buttonColumn
                    { elementColumn = Material.column
                    , content = style palette
                    }
                --Don't forget to change the title
                |> Page.viewTile "Widget.buttonColumn"
    in
    [ viewSelectButtonRow, viewSelectRow, viewSelectColumn ]
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
                ( "Contained", Material.containedButton )
                [ ( "Outlined", Material.outlinedButton )
                , ( "Text", Material.textButton )
                , ( "Toggle", Material.toggleButton )
                ]
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
            (let
                default =
                    [ { icon = always Element.none, text = "42" }
                    , { icon =
                            MaterialIcons.done
                                |> Icon.elmMaterialIcons Color
                      , text = ""
                      }
                    ]
             in
             Story.optionListStory "Options"
                ( "3 Option"
                , [ { icon = always Element.none, text = "42" }
                  , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "" }
                  , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "42" }
                  ]
                )
                [ ( "2 Option", default )
                , ( "1 Option", [ { icon = always Element.none, text = "Apples" } ] )
                ]
            )
        --Should an event be triggered when pressing the button?
        |> Story.addStory
            (Story.boolStory "With event handler"
                ( always <| Just (), always Nothing )
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
    = ChangedSelected Int


init : ( Model, Cmd Msg )
init =
    ( Selected Nothing
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ChangedSelected int ->
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
    { selected = selected
    , options =
        [ 1, 2, 42 ]
            |> List.map
                (\int ->
                    { text = String.fromInt int
                    , icon = always Element.none
                    }
                )
    , onSelect = ChangedSelected >> Just
    }
        |> Widget.select
        |> Widget.buttonRow
            { elementRow = Material.buttonRow
            , content = Material.toggleButton palette
            }



--------------------------------------------------------------------------------
-- DO NOT MODIFY ANYTHING AFTER THIS LINE
--------------------------------------------------------------------------------


demo =
    { init = always init
    , view = Page.demo view
    , update = update
    , subscriptions = subscriptions
    }


page =
    Page.create
        { title = title
        , description = description
        , book = book
        , demo = demo
        }
