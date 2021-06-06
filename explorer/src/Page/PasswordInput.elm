module Page.PasswordInput exposing (Model, Msg, init, page, subscriptions, update, view)

import Element exposing (Element)
import Element.Input as Input
import Material.Icons.Types exposing (Coloring(..))
import Page
import UIExplorer.Story as Story
import UIExplorer.Tile exposing (Context, Tile)
import Widget
import Widget.Material as Material


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
        viewCurrentPassword text placeholder label show { palette } () =
            Widget.currentPasswordInput (Material.passwordInput palette)
                { text = text
                , placeholder = placeholder
                , label = label
                , onChange = always ()
                , show = show
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.currentPasswordInput"

        viewNewPassword text placeholder label show { palette } () =
            Widget.newPasswordInput (Material.passwordInput palette)
                { text = text
                , placeholder = placeholder
                , label = label
                , onChange = always ()
                , show = show
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
            (Story.textStory "Text"
                "123456789"
            )
        |> Story.addStory
            (Story.boolStory "Placeholder"
                ( "password"
                    |> Element.text
                    |> Input.placeholder []
                    |> Just
                , Nothing
                )
                True
            )
        |> Story.addStory
            (Story.textStory "Label"
                "Password"
            )
        |> Story.addStory
            (Story.boolStory "Show"
                ( True
                , False
                )
                True
            )
        |> Story.build



---{- This next section is essentially just a normal Elm program. -}
-----------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


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


view : Context -> Model -> Element Msg
view { palette } model =
    [ "Try  filling out these fields using autofill" |> Element.text
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
