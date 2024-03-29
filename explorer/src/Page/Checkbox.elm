module Page.Checkbox exposing (page)

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
    "Checkbox"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "Checkboxes toggle the state of a single item on or off."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewCheckbox style desc selected onPress { palette } () =
            Widget.checkbox (style palette)
                { description = desc
                , checked = selected
                , onChange = onPress
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.checkbox"
    in
    [ viewCheckbox ]
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
                ( "Checkbox", Material.checkbox )
                []
            )
        --Changing the text of the label
        |> Story.addStory
            (Story.textStory "Description"
                "Be Awesome"
            )
        --Change the Icon
        |> Story.addStory
            (Story.boolStory "Selected"
                ( True
                , False
                )
                True
            )
        --Should an event be triggered when pressing the button?
        |> Story.addStory
            (Story.boolStory "with event handler"
                ( Just (always ()), Nothing )
                True
            )
        |> Story.build



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


type Model
    = IsButtonEnabled Bool


type Msg
    = ToggledButtonStatus


init : ( Model, Cmd Msg )
init =
    ( IsButtonEnabled False
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (IsButtonEnabled buttonEnabled) =
    case msg of
        ToggledButtonStatus ->
            ( IsButtonEnabled <| not buttonEnabled
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } (IsButtonEnabled isButtonEnabled) =
    Widget.checkbox (Material.checkbox palette)
        { description = "click me"
        , checked = isButtonEnabled
        , onChange =
            always ToggledButtonStatus
                |> Just
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
