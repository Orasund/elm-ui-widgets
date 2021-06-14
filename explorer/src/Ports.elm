port module Ports exposing (saveSettings)

import Json.Encode


port saveSettings : String -> Cmd msg
