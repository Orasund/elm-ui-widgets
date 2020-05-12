module Example.ExpansionPanel exposing (Model, Msg, init, subscriptions, update, view)

import Element exposing (Element)
import Widget
import Widget.Style exposing (ExpansionPanelStyle)


type alias Style style msg =
    { style
        | expansionPanel : ExpansionPanelStyle msg
    }


type alias Model =
    { isExpanded : Bool }


type Msg
    = ToggleCollapsable Bool


init : ( Model, Cmd Msg )
init =
    ( { isExpanded = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleCollapsable bool ->
            ( { model
                | isExpanded = bool
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
    { onToggle = ToggleCollapsable >> msgMapper
    , isExpanded = model.isExpanded
    , icon = Element.none
    , text = "Title"
    , content = Element.text <| "Hello World"
    }
        |> Widget.expansionPanel style.expansionPanel
