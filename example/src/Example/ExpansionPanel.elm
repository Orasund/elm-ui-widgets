module Example.ExpansionPanel exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Widget
import Widget.Style exposing (ExpansionPanelStyle)
import Widget.Style.Material as Material


type alias Style style msg =
    { style
        | expansionPanel : ExpansionPanelStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { expansionPanel = Material.expansionPanel Material.defaultPalette
    }


type Model
    = IsExpanded Bool


type Msg
    = ToggleCollapsable Bool


init : ( Model, Cmd Msg )
init =
    ( IsExpanded False
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ToggleCollapsable bool ->
            ( IsExpanded bool
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (IsExpanded isExpanded) =
    { onToggle = ToggleCollapsable >> msgMapper
    , isExpanded = isExpanded
    , icon = always Element.none
    , text = "Title"
    , content = Element.text <| "Hello World"
    }
        |> Widget.expansionPanel style.expansionPanel


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
