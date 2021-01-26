module Main exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import FeatherIcons
import Time
import Widget exposing (ButtonStyle, ColumnStyle, RowStyle, SnackbarStyle)
import Widget.Snackbar as Snackbar exposing (Snackbar)
import Widget.Material as Material


type alias Style style msg =
    { style
        | primaryButton : ButtonStyle msg
        , button : ButtonStyle msg
        , column : ColumnStyle msg
        , snackbar : SnackbarStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { primaryButton = Material.containedButton Material.defaultPalette
    , button = Material.outlinedButton Material.defaultPalette
    , column = Material.column
    , snackbar = Material.snackbar Material.defaultPalette
    }


type alias Model =
    Snackbar ( String, Bool )


type Msg
    = AddSnackbar ( String, Bool )
    | TimePassed Int


init : ( Model, Cmd Msg )
init =
    ( Snackbar.init
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimePassed int ->
            ( model |> Snackbar.timePassed int
            , Cmd.none
            )

        AddSnackbar snack ->
            ( model |> Snackbar.insert snack
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 50 (always (TimePassed 50))


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
    [ Widget.button style.button
        { onPress =
            Just <|
                msgMapper <|
                    AddSnackbar <|
                        ( "This is a notification. It will disappear after 10 seconds."
                        , False
                        )
        , text = "Add Notification"
        , icon = Element.none
        }
    , Widget.button style.button
        { onPress =
            Just <|
                msgMapper <|
                    AddSnackbar <|
                        ( "You can add another notification if you want."
                        , True
                        )
        , text = "Add Notification with Action"
        , icon = Element.none
        }
    ]
        |> Widget.column style.column
        |> Element.el
            [ Element.height <| Element.minimum 200 <| Element.fill
            , Element.width <| Element.minimum 400 <| Element.fill
            , Element.inFront <|
                (model
                    |> Snackbar.view style.snackbar
                        (\( text, hasButton ) ->
                            { text = text
                            , button =
                                if hasButton then
                                    Just
                                        { text = "Add"
                                        , onPress =
                                            Just <|
                                                msgMapper <|
                                                    AddSnackbar ( "This is another message", False )
                                        }

                                else
                                    Nothing
                            }
                        )
                    |> Maybe.map
                        (Element.el
                            [ Element.padding 8
                            , Element.alignBottom
                            , Element.alignRight
                            ]
                        )
                    |> Maybe.withDefault Element.none
                )
            ]


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
