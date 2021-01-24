module Example.List exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Widget
import Widget exposing (ColumnStyle, DividerStyle, ItemStyle, HeaderStyle)
import Widget.Style.Material as Material


type alias Style style msg =
    { style
        | cardColumn : ColumnStyle msg
        , insetDivider : ItemStyle (DividerStyle msg)
        , middleDividers : ItemStyle (DividerStyle msg)
        , insetHeader : ItemStyle (HeaderStyle msg)
        , fullBleedHeader : ItemStyle (HeaderStyle msg)
    }


materialStyle : Style {} msg
materialStyle =
    { cardColumn = Material.cardColumn Material.defaultPalette
    , insetDivider = Material.insetDivider Material.defaultPalette
    , middleDividers = Material.middleDividers Material.defaultPalette
    , insetHeader = Material.insetHeader Material.defaultPalette
    , fullBleedHeader = Material.fullBleedHeader Material.defaultPalette
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


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view _ style () =
    [ "Section 1"
        |> Widget.headerItem style.fullBleedHeader
    , Widget.item <| Element.text <| "A"
    , "Section 2"
        |> Widget.headerItem style.fullBleedHeader
    , Widget.item <| Element.text <| "B"
    , Widget.divider style.middleDividers
    , Widget.item <| Element.text <| "C"
    ]
        |> Widget.itemList style.cardColumn


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
