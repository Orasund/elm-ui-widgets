module Internal.ProgressIndicator exposing (circularProgressIndicator)

import Element exposing (Element)
import Widget.Style exposing (ProgressIndicatorStyle)


circularProgressIndicator :
    ProgressIndicatorStyle msg
    -> Maybe Float
    -> Element msg
circularProgressIndicator style maybeProgress =
    style.containerFunction maybeProgress
