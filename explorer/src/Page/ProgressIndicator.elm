module Page.ProgressIndicator exposing (page)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}
import Browser
import Element exposing (Element)
import Widget exposing (ProgressIndicatorStyle)
import Widget.Material as Material
import Element exposing (Element)
import Element.Background as Background
import Material.Icons as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Page
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Tile, TileMsg)
import Widget
import Widget.Customize as Customize
import Widget.Icon as Icon
import Widget.Material as Material
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


{-| The title of this page
-}
title : String
title =
    "Progress Indicator"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "Progress indicators express an unspecified wait time or display the length of a process."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewIndicator style progress indeterminate { palette } () =
            Widget.circularProgressIndicator (style palette)
                (indeterminate (toFloat progress/ 100 ))
                --Don't forget to change the title
                |> Page.viewTile "Widget.circularProgressIndicator"

    in
    [ viewIndicator ]
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
                ( "ProgressIndicator", Material.progressIndicator )
                [ ]
            )
        --Changing the text of the label
        |> Story.addStory
            (Story.rangeStory "Progress"
                { unit = "%", min = 0, max = 100, default = 50 }
            
            )
        --Should an event be triggered when pressing the button?
        |> Story.addStory
            (Story.boolStory "Indeterminate Indicator"
                ( always Nothing, Just )
                False
            )
        |> Story.build



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


type Model
    = MaybeProgress (Maybe Float)


type Msg
    = ChangedProgress (Maybe Float)


init : ( Model, Cmd Msg )
init =
    ( MaybeProgress Nothing
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ChangedProgress maybeFloat ->
            ( MaybeProgress maybeFloat
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view {palette} (MaybeProgress maybeProgress) =
    Widget.circularProgressIndicator (Material.progressIndicator palette) 
    maybeProgress



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


