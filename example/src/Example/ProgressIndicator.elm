module Example.ProgressIndicator exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Widget
import Widget.Style exposing (ProgressIndicatorStyle)
import Widget.Style.Material as Material


type alias Style style msg =
    { style
        | progressIndicator : ProgressIndicatorStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { progressIndicator = Material.progressIndicator Material.defaultPalette
    }


type Model
    = MaybeProgress (Maybe Float)


type Msg
    = ChangedProgress (Maybe Float)


init : ( Model, Cmd Msg )
init =
    ( MaybeProgress Nothing
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ChangedProgress maybeFloat ->
            ( MaybeProgress maybeFloat
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (MaybeProgress maybeProgress) =
    Widget.circularProgressIndicator style.progressIndicator maybeProgress


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = view identity materialStyle >> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
