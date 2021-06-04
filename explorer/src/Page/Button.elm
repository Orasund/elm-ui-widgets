module Page.Button exposing (page)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}

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
        viewButton style text icon onPress { palette } () =
            Widget.button (style palette)
                { text = text
                , icon = icon
                , onPress = onPress
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.button"

        viewTextButton style text _ onPress { palette } () =
            Widget.textButton
                (style palette
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

        viewIconButton style text icon onPress { palette } () =
            Widget.iconButton
                (style palette
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
                ( "Contained", Material.containedButton )
                [ ( "Outlined", Material.outlinedButton )
                , ( "Text", Material.textButton )
                ]
            )
        --Changing the text of the label
        |> Story.addStory
            (Story.textStory "Label"
                "OK"
            )
        --Change the Icon
        |> Story.addStory
            (Story.boolStory "With Icon"
                ( MaterialIcons.done
                    |> Icon.elmMaterialIcons Color
                , always Element.none
                )
                True
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


type alias Model =
    Int


type Msg
    = Increase Int
    | Decrease Int
    | Reset
    | Noop


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


view : Context -> Model -> Element Msg
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
