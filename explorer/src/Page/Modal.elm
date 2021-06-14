module Page.Modal exposing (page)

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
    "Modal"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "All modal surfaces are interruptive by design – their purpose is to have the user focus on content on a surface that appears in front of all other surfaces."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewSingle content onDismiss { palette } () =
            let
                contentEl =
                    content
                        |> Element.text
                        |> List.singleton
                        |> Element.paragraph []
                        |> List.singleton
                        |> Widget.column (Material.cardColumn palette)
                        |> Element.el [ Element.padding 8 ]
            in
            "Placeholder Text"
                |> Element.text
                |> Element.el
                    ([ Element.height <| Element.px 200
                     , Element.width <| Element.fill
                     ]
                        ++ ([ { onDismiss = onDismiss
                              , content = contentEl
                              }
                            , { onDismiss = onDismiss
                              , content =
                                    contentEl
                                        |> Element.el
                                            [ Element.moveDown 10
                                            , Element.moveRight 10
                                            ]
                              }
                            , { onDismiss = onDismiss
                              , content =
                                    contentEl
                                        |> Element.el
                                            [ Element.moveDown 20
                                            , Element.moveRight 20
                                            ]
                              }
                            ]
                                |> Widget.singleModal
                           )
                    )
                --Don't forget to change the title
                |> Page.viewTile "Widget.singleModal"

        viewMulti content onDismiss { palette } () =
            let
                contentEl =
                    content
                        |> Element.text
                        |> List.singleton
                        |> Element.paragraph []
                        |> List.singleton
                        |> Widget.column (Material.cardColumn palette)
                        |> Element.el [ Element.padding 8 ]
            in
            "Placeholder Text"
                |> Element.text
                |> Element.el
                    ([ Element.height <| Element.px 200
                     , Element.width <| Element.fill
                     ]
                        ++ ([ { onDismiss = onDismiss
                              , content = contentEl
                              }
                            , { onDismiss = onDismiss
                              , content =
                                    contentEl
                                        |> Element.el
                                            [ Element.moveDown 10
                                            , Element.moveRight 10
                                            ]
                              }
                            , { onDismiss = onDismiss
                              , content =
                                    contentEl
                                        |> Element.el
                                            [ Element.moveDown 20
                                            , Element.moveRight 20
                                            ]
                              }
                            ]
                                |> Widget.multiModal
                           )
                    )
                --Don't forget to change the title
                |> Page.viewTile "Widget.multiModal"
    in
    [ viewSingle, viewMulti ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


{-| Let's you play around with the options.
Note that the order of these stories must follow the order of the arguments from the view functions.
-}
book : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) flags
book =
    Story.book (Just "Options")
        viewFunctions
        --Changing the text of the label
        |> Story.addStory
            (Story.textStory "Content"
                "This is a windows that is in front of everything else. You can allow the user to close it by pressing outside of it or disable this feature."
            )
        --Should an event be triggered when pressing the button?
        |> Story.addStory
            (Story.boolStory "With event handler"
                ( Just (), Nothing )
                True
            )
        |> Story.build



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


type Model
    = IsEnabled Bool


type Msg
    = ToggleModal Bool


init : ( Model, Cmd Msg )
init =
    ( IsEnabled True
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ToggleModal bool ->
            ( IsEnabled bool
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } (IsEnabled isEnabled) =
    Widget.button (Material.containedButton palette)
        { text = "Show Modal"
        , icon = MaterialIcons.visibility |> Icon.elmMaterialIcons Color
        , onPress =
            ToggleModal True
                |> Just
        }
        |> Element.el
            ([ Element.height <| Element.minimum 200 <| Element.fill
             , Element.width <| Element.minimum 400 <| Element.fill
             ]
                ++ (if isEnabled then
                        [ { onDismiss =
                                ToggleModal False
                                    |> Just
                          , content =
                                "Click on the area around this box to close it."
                                    |> Element.text
                                    |> List.singleton
                                    |> Element.paragraph []
                                    |> List.singleton
                                    |> Widget.column (Material.cardColumn palette)
                                    |> Element.el
                                        [ Element.width <| Element.px 250
                                        , Element.centerX
                                        , Element.centerY
                                        ]
                          }
                        , { onDismiss = Nothing
                          , content =
                                "This card can not be selected."
                                    |> Element.text
                                    |> List.singleton
                                    |> Element.paragraph []
                                    |> List.singleton
                                    |> Widget.column (Material.cardColumn palette)
                                    |> Element.el
                                        [ Element.height <| Element.px 150
                                        , Element.width <| Element.px 200
                                        , Element.centerX
                                        , Element.centerY
                                        ]
                          }
                        , { onDismiss = Nothing
                          , content =
                                "This is message is behind the other two"
                                    |> Element.text
                                    |> List.singleton
                                    |> Element.paragraph []
                                    |> List.singleton
                                    |> Widget.column (Material.cardColumn palette)
                                    |> Element.el
                                        [ Element.height <| Element.px 300
                                        , Element.width <| Element.px 300
                                        , Element.centerX
                                        , Element.centerY
                                        ]
                          }
                        ]
                            |> Widget.multiModal

                    else
                        []
                   )
            )



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
