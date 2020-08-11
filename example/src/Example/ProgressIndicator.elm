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
    = MaybeProgressPercent (Maybe Int)


type Msg
    = ChangedProgressPercent (Maybe Int)


init : ( Model, Cmd Msg )
init =
    ( MaybeProgressPercent Nothing
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ChangedProgressPercent maybeInt ->
            ( MaybeProgressPercent maybeInt
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (MaybeProgressPercent maybeProgressPercent) =
    Widget.circularProgressIndicator style.progressIndicator
        { maybeProgressPercent = maybeProgressPercent
        }


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = view identity materialStyle >> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
