module Pages.Button exposing (page)

import Element exposing (Element)
import Element.Background as Background
import Element.Font
import Material.Icons as MaterialIcons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import StoryTileWithSource
import String.Interpolate exposing (interpolate)
import UIExplorer
import UIExplorer.Story as Story
import UIExplorer.Tile as Tile
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
    Tile.first (intro |> Tile.withTitle "Button")
        |> Tile.nextGroup book
        |> Tile.next demo
        |> Tile.page


intro =
    Tile.markdown []
        """ A simple button """


book =
    Story.book (Just "options")
        (StoryTileWithSource.init
            |> StoryTileWithSource.addTile viewButton
            |> StoryTileWithSource.addTile viewTextButton
            |> StoryTileWithSource.addTile viewIconButton
            |> StoryTileWithSource.addTile viewSelectButton
         --|> Story.addTile viewButtonSource
        )
        |> Story.addStory
            (Story.optionListStory "Palette"
                ( "dark", darkPalette )
                [ ( "dark", ( "Material.darkPalette", darkPalette ) )
                , ( "default", ( "Material.defaultPalette", defaultPalette ) )
                ]
            )
        |> Story.addStory
            (Story.optionListStory "Material button"
                ( "contained", containedButton )
                [ ( "contained", ( "Material.containedButton", containedButton ) )
                , ( "outlined", ( "Material.outlined", outlinedButton ) )
                , ( "text", ( "Material.textButton", textButton ) )
                ]
            )
        |> Story.addStory
            (Story.textStory "Label"
                "OK"
            )
        |> Story.addStory
            (Story.optionListStory "Icon"
                ( "done"
                , MaterialIcons.done
                    |> Icon.elmMaterialIcons Color
                )
                [ ( "save"
                  , ( "save"
                    , MaterialIcons.save
                        |> Icon.elmMaterialIcons Color
                    )
                  )
                , ( "done"
                  , ( "done"
                    , MaterialIcons.done
                        |> Icon.elmMaterialIcons Color
                    )
                  )
                ]
            )
        |> Story.addStory
            (Story.boolStory "with event handler"
                ( ( "Just Noop", Just StoryTileWithSource.Noop )
                , ( "Nothing", Nothing )
                )
                True
            )
        |> StoryTileWithSource.build


viewLabel : String -> Element msg
viewLabel =
    Element.el [ Element.width <| Element.px 250 ] << Element.text


viewButton ( paletteSrc, palette ) ( buttonSrc, button ) text ( iconSrc, icon ) ( onPressSrc, onPress ) _ _ =
    { title = Nothing
    , position = Tile.LeftColumnTile
    , attributes = [ Background.color <| MaterialColor.fromColor palette.surface ]
    , demo =
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.Font.color <| MaterialColor.fromColor palette.on.surface
            ]
            [ viewLabel "button"
            , Widget.button
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
    , source =
        interpolate
            """Widget.button
    ({0} {1})
    { text ="{2}"
    , icon = MaterialIcons.{3}
        |> Widget.Icon.elmMaterialIcons Widget.Material.Types.Color
    , onPress = {4}
    }
    """
            [ buttonSrc, paletteSrc, text, iconSrc, onPressSrc ]
    }


viewTextButton ( paletteSrc, palette ) ( buttonSrc, button ) text ( iconSrc, icon ) ( onPressSrc, onPress ) _ _ =
    { title = Nothing
    , position = Tile.LeftColumnTile
    , attributes = [ Background.color <| MaterialColor.fromColor palette.surface ]
    , demo =
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.Font.color <| MaterialColor.fromColor palette.on.surface
            ]
            [ viewLabel "textButton"
            , Widget.textButton
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
    , source =
        interpolate
            """Widget.textButton
    ({0} {1})
    { text = "{2}"
    , onPress = {3}
    }
    """
            [ buttonSrc, paletteSrc, text, onPressSrc ]
    }


viewIconButton ( paletteSrc, palette ) ( buttonSrc, button ) text ( iconSrc, icon ) ( onPressSrc, onPress ) _ _ =
    { title = Nothing
    , position = Tile.LeftColumnTile
    , attributes = [ Background.color <| MaterialColor.fromColor palette.surface ]
    , demo =
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.Font.color <| MaterialColor.fromColor palette.on.surface
            ]
            [ viewLabel "iconButton"
            , Widget.iconButton
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
    , source =
        interpolate
            """Widget.iconButton
    ({0} {1})
    { text = "{2}"
    , icon = MaterialIcons.{3}
        |> Widget.Icon.elmMaterialIcons Widget.Material.Types.Color
    , onPress = {4}
    }
    """
            [ buttonSrc, paletteSrc, text, iconSrc, onPressSrc ]
    }


viewSelectButton ( paletteSrc, palette ) ( buttonSrc, button ) text ( iconSrc, icon ) ( onPressSrc, onPress ) _ _ =
    { title = Nothing
    , position = Tile.LeftColumnTile
    , attributes = [ Background.color <| MaterialColor.fromColor palette.surface ]
    , demo =
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.Font.color <| MaterialColor.fromColor palette.on.surface
            ]
            [ viewLabel "select button"
            , Element.column [ Element.width Element.fill, Element.spacing 8 ]
                [ Widget.selectButton
                    (button palette
                        |> Customize.elementButton
                            [ Element.centerY
                            , Element.alignLeft
                            ]
                    )
                    ( False
                    , { text = text
                      , icon = icon
                      , onPress = onPress
                      }
                    )
                , Widget.selectButton
                    (button palette
                        |> Customize.elementButton
                            [ Element.centerY
                            , Element.alignLeft
                            ]
                    )
                    ( True
                    , { text = text
                      , icon = icon
                      , onPress = onPress
                      }
                    )
                ]
            ]
    , source =
        interpolate
            """Element.column [ Element.width Element.fill, Element.spacing 8 ]
    [ Widget.selectButton
        ({0} {1})
        ( False
        , { text = "{2}"
          , icon =
              MaterialIcons.{3}
                |> Widget.Icon.elmMaterialIcons Widget.Material.Types.Color
          , onPress = {4}
          }
        )
    , Widget.selectButton
        ({0} {1})
        ( True
        , { text = "{2}"
          , icon =
              MaterialIcons.{3}
                |> Widget.Icon.elmMaterialIcons Widget.Material.Types.Color
          , onPress = {4}
          }
        )
    ]
    """
            [ buttonSrc, paletteSrc, text, iconSrc, onPressSrc ]
    }


type alias Model =
    Int


type Msg
    = Increase Int
    | Decrease Int
    | Reset
    | Noop



--|> Story.addTile (Just "Interactive example") view


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
