module Page.PasswordInput exposing (Model, Msg, init, page, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Element.Background as Background
import Element.Font
import Element.Input as Input
import Material.Icons as MaterialIcons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import Page
import Set exposing (Set)
import UIExplorer exposing (Page)
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Group, Position, Tile, TileMsg)
import Widget exposing (ButtonStyle, ColumnStyle, PasswordInputStyle)
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
    "Password Input"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "If we want to play nicely with a browser's ability to autofill a form, we need to be able to give it a hint about what we're expecting.\n    \nThe following inputs are very similar to Input.text, but they give the browser a hint to allow autofill to work correctly."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewCurrentPassword palette text placeholder label _ _ =
            Widget.currentPasswordInput (Material.passwordInput palette)
                { text = text
                , placeholder = placeholder
                , label = label
                , onChange = always ()
                , show = False
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.currentPasswordInput"

        viewNewPassword palette text placeholder label _ _ =
            Widget.newPasswordInput (Material.passwordInput palette)
                { text = text
                , placeholder = placeholder
                , label = label
                , onChange = always ()
                , show = False
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.newPasswordInput"
    in
    [ viewNewPassword, viewCurrentPassword ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


book =
    Story.book (Just "Options")
        viewFunctions
        |> Story.addStory
            (Story.optionListStory "Palette"
                darkPalette
                [ ( "dark", darkPalette )
                , ( "default", defaultPalette )
                ]
            )
        |> Story.addStory
            (Story.textStory "Text"
                "123456789"
            )
        |> Story.addStory
            (Story.optionListStory "Placeholder"
                Nothing
                [ ( "Yes"
                  , "password"
                        |> Element.text
                        |> Input.placeholder []
                        |> Just
                  )
                , ( "No", Nothing )
                ]
            )
        |> Story.addStory
            (Story.textStory "Label"
                "Password"
            )
        |> Story.build



--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------
{- This section here is essentially just a normal Elm program. -}


type alias Model =
    { passwordInput : String
    , newInput : String
    }


type Msg
    = SetPasswordInput String
    | SetNewPasswordInput String


init : ( Model, Cmd Msg )
init =
    ( { passwordInput = ""
      , newInput = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPasswordInput string ->
            ( { model | passwordInput = string }, Cmd.none )

        SetNewPasswordInput string ->
            ( { model | newInput = string }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view { palette } model =
    { title = Just "Interactive Demo"
    , position = Tile.FullWidthTile
    , attributes = []
    , body =
        [ "Try  fill out these fields using autofill" |> Element.text
        , [ "Current Password"
                |> Element.text
                |> Element.el [ Element.width <| Element.fill ]
          , Widget.currentPasswordInput (Material.passwordInput palette)
                { text = model.passwordInput
                , placeholder = Nothing
                , label = "Chips"
                , onChange = SetPasswordInput
                , show = False
                }
          ]
            |> Element.row [ Element.width <| Element.fill, Element.spaceEvenly ]
        , [ "New Password"
                |> Element.text
                |> Element.el [ Element.width <| Element.fill ]
          , Widget.newPasswordInput (Material.passwordInput palette)
                { text = model.newInput
                , placeholder = Nothing
                , label = "Chips"
                , onChange = SetNewPasswordInput
                , show = False
                }
          ]
            |> Element.row [ Element.width <| Element.fill, Element.spaceEvenly ]
        , Element.text <|
            if (model.newInput /= "") && (model.newInput == model.passwordInput) then
                "Yeay, the two passwords match!"

            else
                ""
        ]
            |> Element.column [ Element.width <| Element.fill, Element.spacing 8 ]
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
