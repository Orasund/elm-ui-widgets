module Internal.ProgressIndicator exposing (circularProgressIndicator)

import Element exposing (Element)
import Widget.Style exposing (ProgressIndicatorStyle)


circularProgressIndicator :
    ProgressIndicatorStyle msg
    -> { maybeProgress : Maybe Float }
    -> Element msg
circularProgressIndicator style { maybeProgress } =
    style.icon maybeProgress
