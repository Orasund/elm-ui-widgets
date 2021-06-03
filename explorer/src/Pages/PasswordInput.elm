module Pages.PasswordInput exposing (Model, Msg, init, page, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Element.Background as Background
import Element.Font
import Element.Input as Input
import Material.Icons as MaterialIcons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import Set exposing (Set)
import UIExplorer
import UIExplorer.Story as Story
import UIExplorer.Tile as Tile
import Widget exposing (ColumnStyle, PasswordInputStyle)
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
    Tile.first (intro |> Tile.withTitle "Password Input")
        |> Tile.nextGroup book
        |> Tile.next demo
        |> Tile.page


intro =
    Tile.markdown []
        """ An input field for a password. """


book =
    Story.book (Just "options")
        (Story.initStaticTiles
            |> Story.addTile viewPassword
        )
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


type alias Style style msg =
    { style
        | passwordInput : PasswordInputStyle msg
        , column : ColumnStyle msg
    }


viewLabel : String -> Element msg
viewLabel =
    Element.el [ Element.width <| Element.px 250 ] << Element.text


viewPassword palette text placeholder label _ _ =
    { title = Nothing
    , position = Tile.LeftColumnTile
    , attributes = [ Background.color <| MaterialColor.fromColor palette.surface ]
    , body =
        Element.column
            [ Element.width Element.fill
            , Element.centerY
            , Element.Font.color <| MaterialColor.fromColor palette.on.surface
            ]
            [ viewLabel "Current Password"
            , { text = text
              , placeholder = placeholder
              , label = label
              , onChange = always ()
              , show = False
              }
                |> Widget.currentPasswordInput (Material.passwordInput palette)
            ]
    }



--------------------------------------------------------------------------------
-- Example
--------------------------------------------------------------------------------


materialStyle : Style {} msg
materialStyle =
    { passwordInput = Material.passwordInput Material.defaultPalette
    , column = Material.column
    }


type alias Model =
    { passwordInput : String
    }


type Msg
    = SetPasswordInput String


init : ( Model, Cmd Msg )
init =
    ( { passwordInput = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPasswordInput string ->
            ( { model | passwordInput = string }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view _ model =
    { title = Just "Interactive Demo"
    , position = Tile.FullWidthTile
    , attributes = []
    , body =
        { text = model.passwordInput
        , placeholder = Nothing
        , label = "Chips"
        , onChange = SetPasswordInput
        , show = False
        }
            |> Widget.currentPasswordInput (Material.passwordInput Material.defaultPalette)
    }


demo =
    { init = always init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
