module Button exposing (page)

import Element exposing (Element)
import Element.Background as Background
import Material.Icons as MaterialIcons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import Story
import Tooling
import UiExplorer
import Widget
import Widget.Customize as Customize
import Widget.Icon as Icon exposing (Icon)
import Widget.Material as Material exposing (Palette, containedButton, darkPalette, defaultPalette)
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


page =
    Tooling.firstBloc (intro |> Tooling.withBlocTitle "Button")
        |> Tooling.nextBlocList book
        |> Tooling.nextBloc demo
        |> Tooling.page


intro =
    Tooling.markdown []
        """ A simple button """


book =
    Story.book (Just "States")
        (Story.initStaticBlocs
            |> Story.addBloc Tooling.LeftColumnBloc
                [ Background.color <| MaterialColor.fromColor MaterialColor.gray ]
                Nothing
                viewButton
        )
        |> Story.addStory
            (Story.optionListStory "Palette"
                defaultPalette
                [ ( "default", defaultPalette )
                , ( "dark", darkPalette )
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
        |> Story.addStory
            (Story.rangeStory "Height"
                { unit = "px"
                , min = 1
                , max = 200
                , default = 48
                }
            )
        |> Story.build


viewButton palette text icon onPress size _ _ =
    Widget.button
        (containedButton palette
            |> Customize.elementButton
                [ Element.height <| Element.px size
                , Element.centerX
                , Element.centerY
                ]
        )
        { text = text
        , icon = icon
        , onPress = onPress
        }


type alias Model =
    Int


type Msg
    = Increase Int
    | Decrease Int
    | Reset
    | Noop



--|> Story.addBloc (Just "Interactive example") view


demo =
    { init = always init
    , update = update
    , title = Just "Interactive Demo"
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
    { position = Tooling.FullWidthBloc
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
