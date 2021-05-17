module Example.PasswordInput exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Set exposing (Set)
import Widget exposing (ColumnStyle, PasswordInputStyle)
import Widget.Material as Material


type alias Style style msg =
    { style
        | passwordInput : PasswordInputStyle msg
        , column : ColumnStyle msg
    }


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


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
    [ { text = model.passwordInput
      , placeholder = Nothing
      , label = "Chips"
      , onChange = SetPasswordInput >> msgMapper
      , show = False
      }
        |> Widget.currentPasswordInput style.passwordInput
    ]
        |> Widget.column style.column


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
