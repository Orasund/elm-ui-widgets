module Page.Button exposing (page)

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
import Widget.Material as Material
    exposing
        ( Palette
        , containedButton
        , darkPalette
        , defaultPalette
        , outlinedButton
        , textButton
        )
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


{-| The title of this page
-}
title : String
title =
    "Button"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "Buttons allow users to take actions, and make choices, with a single tap."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewButton button text icon onPress { palette } () =
            Widget.button (button palette)
                { text = text
                , icon = icon
                , onPress = onPress
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.button"

        viewTextButton button text icon onPress { palette } () =
            Widget.textButton
                (button palette
                    |> Customize.elementButton
                        [ Element.alignLeft
                        , Element.centerY
                        ]
                )
                { text = text
                , onPress = onPress
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.textButton"

        viewIconButton button text icon onPress { palette } () =
            Widget.iconButton
                (button palette
                    |> Customize.elementButton
                        [ Element.alignLeft
                        , Element.centerY
                        ]
                )
                { text = text
                , icon = icon
                , onPress = onPress
                }
                |> Page.viewTile "Widget.itemButton"
    in
    [ viewButton, viewTextButton, viewIconButton ]
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
                containedButton
                [ ( "contained", containedButton )
                , ( "outlined", outlinedButton )
                , ( "text", textButton )
                ]
            )
        --Changing the text of the label
        |> Story.addStory
            (Story.textStory "Label"
                "OK"
            )
        --Change the Icon
        |> Story.addStory
            (Story.optionListStory "Icon"
                (MaterialIcons.done
                    |> Icon.elmMaterialIcons Color
                )
                [ ( "done"
                  , MaterialIcons.done
                        |> Icon.elmMaterialIcons Color
                  )
                ]
            )
        --Should an event be triggered when pressing the button?
        |> Story.addStory
            (Story.boolStory "with event handler"
                ( Just (), Nothing )
                True
            )
        |> Story.build



--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------
{- This section here is essentially just a normal Elm program. -}


type alias Model =
    Int


type Msg
    = Increase Int
    | Decrease Int
    | Reset
    | Noop



--|> Story.addTile (Just "Interactive example") view


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        Increase int ->
            ( model + int
            , Cmd.none
            )

        Decrease int ->
            ( if (model - int) >= 0 then
                model - int

              else
                model
            , Cmd.none
            )

        Reset ->
            ( 0
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Context -> Int -> { title : Maybe String, position : Position, attributes : List b, body : Element Msg }
view { palette } model =
    let
        style =
            { containedButton = Material.containedButton palette
            , outlinedButton = Material.outlinedButton palette
            , textButton = Material.textButton palette
            , iconButton = Material.iconButton palette
            , row = Material.row
            , column = Material.column
            , cardColumn = Material.cardColumn palette
            }
    in
    { title = Just "Interactive Demo"
    , position = Tile.FullWidthTile
    , attributes = []
    , body =
        [ model
            |> String.fromInt
            |> Element.text
            |> Element.el
                (Typography.h4
                    ++ [ Element.centerX, Element.centerY ]
                )
            |> List.singleton
            |> Widget.column
                (style.cardColumn
                    |> Customize.elementColumn
                        [ Element.centerX
                        , Element.width <| Element.px 128
                        , Element.height <| Element.px 128
                        , Widget.iconButton style.iconButton
                            { text = "+2"
                            , icon =
                                MaterialIcons.exposure_plus_2
                                    |> Icon.elmMaterialIcons Color
                            , onPress =
                                Increase 2
                                    |> Just
                            }
                            |> Element.el [ Element.alignRight ]
                            |> Element.inFront
                        ]
                    |> Customize.mapContent
                        (Customize.element
                            [ Element.width <| Element.px 128
                            , Element.height <| Element.px 128
                            , Material.defaultPalette.secondary
                                |> MaterialColor.fromColor
                                |> Background.color
                            ]
                        )
                )
        , [ [ Widget.textButton style.textButton
                { text = "Reset"
                , onPress =
                    Reset
                        |> Just
                }
            , Widget.button style.outlinedButton
                { text = "Decrease"
                , icon =
                    MaterialIcons.remove
                        |> Icon.elmMaterialIcons Color
                , onPress =
                    if model > 0 then
                        Decrease 1
                            |> Just

                    else
                        Nothing
                }
            ]
                |> Widget.row (style.row |> Customize.elementRow [ Element.alignRight ])
          , [ Widget.button style.containedButton
                { text = "Increase"
                , icon =
                    MaterialIcons.add
                        |> Icon.elmMaterialIcons Color
                , onPress =
                    Increase 1
                        |> Just
                }
            ]
                |> Widget.row (style.row |> Customize.elementRow [ Element.alignLeft ])
          ]
            |> Widget.row
                (style.row
                    |> Customize.elementRow [ Element.width <| Element.fill ]
                    |> Customize.mapContent (Customize.element [ Element.width <| Element.fill ])
                )
        ]
            |> Widget.column
                (style.column
                    |> Customize.elementColumn [ Element.width <| Element.fill ]
                    |> Customize.mapContent (Customize.element [ Element.width <| Element.fill ])
                )
    }


demo : Tile Model Msg ()
demo =
    { init = always init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }



--------------------------------------------------------------------------------
-- DO NOT MODIFY ANTHING AFTER THIS LINE
--------------------------------------------------------------------------------


page =
    Page.create
        { title = title
        , description = description
        , book = book
        , demo = demo
        }
