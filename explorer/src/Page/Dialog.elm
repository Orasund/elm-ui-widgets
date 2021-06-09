module Page.Dialog exposing (page)

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
    "Dialog"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "Dialogs inform users about a task and can contain critical information, require decisions, or involve multiple tasks."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewDialog style text titleString accept dismiss { palette } () =
            "Placeholder Text"
                |> Element.text
                |> Element.el
                    ([ Element.height <| Element.px 200
                     , Element.width <| Element.fill
                     ]
                        ++ (Widget.dialog (style palette)
                                { text = text
                                , title = titleString
                                , accept = accept
                                , dismiss = dismiss
                                }
                                |> List.singleton
                                |> Widget.singleModal
                           )
                    )
                |> Page.viewTile "Widget.dialog"
    in
    [ viewDialog ]
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
                ( "Alert Dialog", Material.alertDialog )
                []
            )
        --Changing the text of the label
        |> Story.addStory
            (Story.textStory "Text"
                "If an accept button is given then the window can only be closed manually. Else it can be closed by pressing somewhere outside of it."
            )
        |> Story.addStory
            (Story.boolStory "With title"
                ( Just "Title"
                , Nothing
                )
                True
            )
        --Should an event be triggered when pressing the button?
        |> Story.addStory
            (Story.boolStory "With accept button"
                ( Just
                    { text = "Ok"
                    , onPress = Just ()
                    }
                , Nothing
                )
                True
            )
        |> Story.addStory
            (Story.boolStory "Dismissible"
                ( Just
                    { text = "Dismiss"
                    , onPress = Just ()
                    }
                , Nothing
                )
                True
            )
        |> Story.build



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


type Model
    = IsOpen Bool


type Msg
    = OpenDialog Bool


init : ( Model, Cmd Msg )
init =
    ( IsOpen True
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        OpenDialog bool ->
            ( IsOpen bool
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } (IsOpen isOpen) =
    Widget.button (Material.containedButton palette)
        { text = "Show Dialog"
        , icon = MaterialIcons.visibility |> Icon.elmMaterialIcons Color
        , onPress =
            OpenDialog True
                |> Just
        }
        |> Element.el
            ([ Element.height <| Element.minimum 200 <| Element.fill
             , Element.width <| Element.minimum 400 <| Element.fill
             ]
                ++ (if isOpen then
                        { text = "This is a dialog window"
                        , title = Just "Dialog"
                        , accept =
                            Just
                                { text = "Ok"
                                , onPress =
                                    Just <|
                                        OpenDialog False
                                }
                        , dismiss =
                            Just
                                { text = "Dismiss"
                                , onPress =
                                    Just <|
                                        OpenDialog False
                                }
                        }
                            |> Widget.dialog (Material.alertDialog palette)
                            |> List.singleton
                            |> Widget.singleModal

                    else
                        []
                   )
            )



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
