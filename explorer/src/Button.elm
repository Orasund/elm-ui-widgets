module Button exposing (page)

import Element exposing (Element)
import Element.Background as Background
import Material.Icons as MaterialIcons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import Story exposing (Story)
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
        |> Tooling.page


intro =
    Tooling.markdown
        """ A simple button """


book =
    Story.book (Just "States") buttonBlocs
        |> Story.addStory
            (Story "Palette"
                [ ( "default", defaultPalette )
                , ( "dark", darkPalette )
                ]
            )
        |> Story.addStory
            (Story "Text"
                [ ( "OK", "OK" )
                , ( "Cancel", "Cancel" )
                , ( "Something a little too long", "Something a little too long" )
                ]
            )
        |> Story.addStory
            (Story "Icon"
                [ ( "done"
                  , MaterialIcons.done
                        |> Icon.elmMaterialIcons Color
                  )
                ]
            )
        |> Story.addStory
            (Story "onPress"
                [ ( "Something", Just Noop )
                , ( "Nothing", Nothing )
                ]
            )
        |> Story.build


type alias Model =
    Int


type Msg
    = Increase Int
    | Decrease Int
    | Reset
    | Noop


buttonBlocs =
    Story.initBlocs
        { init = always init
        , update = update
        , subscriptions = subscriptions
        }
        |> Story.addBloc Nothing viewButton
        |> Story.addBloc (Just "Interactive example") view



--|> Story.addBloc (Just "Interactive example") view


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


viewButton palette text icon onPress _ _ =
    Tooling.canvas <|
        Widget.button (containedButton palette)
            { text = text
            , icon = icon
            , onPress = onPress
            }


view palette _ _ _ _ model =
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
