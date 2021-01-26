module Example.Button exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Material.Icons as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Widget exposing (ButtonStyle, ColumnStyle, RowStyle)
import Widget.Icon as Icon
import Widget.Style.Customize as Customize
import Widget.Style.Material as Material
import Widget.Style.Material.Color as MaterialColor
import Widget.Style.Material.Typography as Typography


type alias Style style msg =
    { style
        | containedButton : ButtonStyle msg
        , outlinedButton : ButtonStyle msg
        , textButton : ButtonStyle msg
        , iconButton : ButtonStyle msg
        , row : RowStyle msg
        , column : ColumnStyle msg
        , cardColumn : ColumnStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { containedButton = Material.containedButton Material.defaultPalette
    , outlinedButton = Material.outlinedButton Material.defaultPalette
    , textButton = Material.textButton Material.defaultPalette
    , iconButton = Material.iconButton Material.defaultPalette
    , row = Material.row
    , column = Material.column
    , cardColumn = Material.cardColumn Material.defaultPalette
    }


type alias Model =
    Int


type Msg
    = Increase Int
    | Decrease Int
    | Reset


init : ( Model, Cmd Msg )
init =
    ( 0
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
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
                                |> msgMapper
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
                    |> msgMapper
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
                        |> msgMapper
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
                    |> msgMapper
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


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
