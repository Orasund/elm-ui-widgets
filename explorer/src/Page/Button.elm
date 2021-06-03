module Page.Button exposing (page)

import Element exposing (Element)
import Element.Background as Background
import Element.Font
import Material.Icons as MaterialIcons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import Page
import UIExplorer
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Tile, TileMsg)
import Widget
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


page =
    Page.create
        { title = "Button"
        , description = "A simple button"
        , book = book
        , demo = demo
        }


book : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
book =
    Story.book (Just "Options")
        (Story.initStaticTiles
            |> Story.addTile viewButton
            |> Story.addTile viewTextButton
            |> Story.addTile viewIconButton
         --|> Story.addTile viewButtonSource
        )
        |> Story.addStory
            (Story.optionListStory "Palette"
                darkPalette
                [ ( "dark", darkPalette )
                , ( "default", defaultPalette )
                ]
            )
        |> Story.addStory
            (Story.optionListStory "Material button"
                containedButton
                [ ( "contained", containedButton )
                , ( "outlined", outlinedButton )
                , ( "text", textButton )
                ]
            )
        |> Story.addStory
            (Story.textStory "Label"
                "OK"
            )
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
        |> Story.addStory
            (Story.boolStory "with event handler"
                ( Just (), Nothing )
                True
            )
        |> Story.build


viewLabel : String -> Element msg
viewLabel =
    Element.el [ Element.width <| Element.px 250 ] << Element.text


viewButton palette button text icon onPress _ _ =
    { title = Just "Button"
    , position = Tile.LeftColumnTile
    , attributes = [ Background.color <| MaterialColor.fromColor palette.surface ]
    , body =
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.Font.color <| MaterialColor.fromColor palette.on.surface
            ]
            [ Widget.button
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
            ]
    }


viewTextButton palette button text icon onPress _ _ =
    { title = Just "Text Button"
    , position = Tile.LeftColumnTile
    , attributes = [ Background.color <| MaterialColor.fromColor palette.surface ]
    , body =
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.Font.color <| MaterialColor.fromColor palette.on.surface
            ]
            [ Widget.textButton
                (button palette
                    |> Customize.elementButton
                        [ Element.alignLeft
                        , Element.centerY
                        ]
                )
                { text = text
                , onPress = onPress
                }
            ]
    }


viewIconButton palette button text icon onPress _ _ =
    { title = Just "Icon Button"
    , position = Tile.LeftColumnTile
    , attributes = [ Background.color <| MaterialColor.fromColor palette.surface ]
    , body =
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.Font.color <| MaterialColor.fromColor palette.on.surface
            ]
            [ Widget.iconButton
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
            ]
    }


viewButtonSource palette text icon onPress size _ _ =
    { title = Just "source code"
    , position = Tile.FullWidthTile
    , attributes = []
    , body =
        Tile.sourceCode <|
            """Widget.button
    (Material.containedButton palette
          |> Customize.elementButton [ Element.height <| Element.px """
                ++ String.fromInt size
                ++ """ ]
    )
    { text =\""""
                ++ text
                ++ """" 
    , icon = MaterialIcons.done |> Icon.elmMaterialIcons Widget.Material.Types.Color
    , onPress = """
                ++ (case onPress of
                        Nothing ->
                            "Nothing"

                        Just () ->
                            "Just ()"
                   )
                ++ """
    }
    """
    }


type alias Model =
    Int


type Msg
    = Increase Int
    | Decrease Int
    | Reset
    | Noop



--|> Story.addTile (Just "Interactive example") view


demo : Tile Model Msg ()
demo =
    { init = always init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


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


view _ model =
    let
        palette =
            Material.defaultPalette

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
