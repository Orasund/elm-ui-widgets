module Example.List exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element)
import Widget
import Widget.Style exposing (ColumnStyle)
import Widget.Style.Material as Material
import Browser

type alias Style style msg =
    { style
        | cardColumn : ColumnStyle msg
    }

materialStyle : Style {} msg
materialStyle =
    { cardColumn = Material.cardColumn Material.defaultPalette
    }

type alias Model =
    ()


type alias Msg =
    Never


init : ( Model, Cmd Msg )
init =
    ( ()
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ () =
    ( ()
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions () =
    Sub.none


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view _ style () =
    [ Element.text <| "A"
    , Element.text <| "B"
    , Element.text <| "C"
    ]
        |> Widget.column style.cardColumn

main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = view identity materialStyle >> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }