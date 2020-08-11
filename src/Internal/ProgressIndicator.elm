module Internal.ProgressIndicator exposing (circularProgressIndicator)

import Element exposing (Element)
import Widget.Style exposing (ProgressIndicatorStyle)


circularProgressIndicator :
    ProgressIndicatorStyle msg
    -> { progressPercent : Maybe Int }
    -> Element msg
circularProgressIndicator style { progressPercent } =
    -- TODO determinate indicator based on progressPercent
    style.icon



-- TODO linear progress indicator
