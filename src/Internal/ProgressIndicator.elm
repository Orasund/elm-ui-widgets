module Internal.ProgressIndicator exposing (ProgressIndicatorStyle, circularProgressIndicator)

import Element exposing (Element)


{-| -}
type alias ProgressIndicatorStyle msg =
    { elementFunction : Maybe Float -> Element msg
    }


circularProgressIndicator :
    ProgressIndicatorStyle msg
    -> Maybe Float
    -> Element msg
circularProgressIndicator style maybeProgress =
    style.elementFunction maybeProgress
