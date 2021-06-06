module Page.Snackbar exposing (page)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}

import Element exposing (Element)
import Material.Icons.Types exposing (Coloring(..))
import Page
import Time
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Tile, TileMsg)
import Widget
import Widget.Material as Material
import Widget.Snackbar as Snackbar exposing (Snackbar)


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
        viewSnackbar style text button { palette } () =
            Snackbar.view (style palette)
                identity
                (Snackbar.init
                    |> Snackbar.insert
                        { text = text
                        , button = button
                        }
                )
                |> Maybe.withDefault Element.none
                --Don't forget to change the title
                |> Page.viewTile "Snackbar.view"
    in
    [ viewSnackbar ]
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
                ( "Snackbar", Material.snackbar )
                []
            )
        --Changing the text of the label
        |> Story.addStory
            (Story.textStory "Text"
                "This is a notification that will close after 10 seconds. Additional notifications are being queued."
            )
        --Change the Icon
        |> Story.addStory
            (Story.optionListStory "Button"
                ( "Button with event handler"
                , Just
                    { text = "Close"
                    , onPress = Just ()
                    }
                )
                [ ( "Eventless Button"
                  , Just
                        { text = "Close"
                        , onPress = Nothing
                        }
                  )
                , ( "None"
                  , Nothing
                  )
                ]
            )
        |> Story.build



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


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
            ( model |> Snackbar.dismiss |> Snackbar.insert snack
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 50 (always (TimePassed 50))


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } model =
    [ Widget.button (Material.containedButton palette)
        { onPress =
            Just <|
                AddSnackbar <|
                    ( "This is a notification. It will disappear after 10 seconds."
                    , False
                    )
        , text = "Add Notification"
        , icon = always Element.none
        }
    , Widget.button (Material.containedButton palette)
        { onPress =
            Just <|
                AddSnackbar <|
                    ( "You can add another notification if you want."
                    , True
                    )
        , text = "Add Notification with Action"
        , icon = always Element.none
        }
    ]
        |> Widget.column Material.column
        |> Element.el
            [ Element.height <| Element.minimum 200 <| Element.fill
            , Element.width <| Element.minimum 400 <| Element.fill
            , Element.inFront <|
                (model
                    |> Snackbar.view (Material.snackbar palette)
                        (\( text, hasButton ) ->
                            { text = text
                            , button =
                                if hasButton then
                                    Just
                                        { text = "Add"
                                        , onPress =
                                            Just <|
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
