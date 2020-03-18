module Material.Widget exposing (Widget)


type Icon
    = Plus


type ButtonEmphasis
    = Low
    | Default -- can be removed
    | High


type ButtonSort
    = TextButton { emphasis : ButtonEmphasis, label : String }
    | IconButton


type Button msg
    = Button
        { sort : ButtonSort
        , enabled : Bool
        , onClick : msg
        , icon : Maybe Icon
        }


type ToggleButton msg state
    = ToggleButton
        { options :
            List
                ( state
                , { enabled : Bool
                  , onClick : state -> msg
                  , icon : Icon
                  }
                )
        , selected : Maybe state
        }


type FAButton msg
    = FAButton
        { onClick : msg
        , icon : Icon
        , label : Maybe String
        }


type SpeedDial msg
    = SpeedDial
        { options : List (FAButton msg)
        , icon : Icon
        , label : Maybe String
        }


type Widget msg state
    = ButtonWidget (Button msg)
    | ToggleButtonWidget (ToggleButton msg state)
    | FAButtonWidget ButtonSort (FAButton msg)
    | SpeedDialWidget ButtonSort (FAButton msg) -- can be removed
