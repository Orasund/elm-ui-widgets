module Internal.ProgressIndicator exposing (circularProgressIndicator)

import Element exposing (Element)
import Widget.Style exposing (ProgressIndicatorStyle)


circularProgressIndicator :
    ProgressIndicatorStyle msg
    -> { maybeProgressPercent : Maybe Int }
    -> Element msg
circularProgressIndicator style { maybeProgressPercent } =
    -- TODO determinate indicator based on progressPercent
    style.icon maybeProgressPercent



-- TODO linear progress indicator
