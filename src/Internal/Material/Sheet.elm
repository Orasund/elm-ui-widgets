module Internal.Material.Sheet exposing (sideSheet)

import Element
import Internal.Material.Palette exposing (Palette)
import Internal.Sheet exposing (SideSheetStyle)
import Widget.Material.Color as MaterialColor


sideSheet : Palette -> SideSheetStyle msg
sideSheet palette =
    { element = [ ]
    , content =
        { elementColumn =
            (palette.surface |> MaterialColor.textAndBackground)
                ++ [ Element.width <| Element.maximum 360 <| Element.fill
                   ]
        , content =
            { element = 
                [ Element.width <| Element.fill ]
            , ifSingleton = []
            , ifFirst = []
            , ifLast = []
            , otherwise = []
            }
        }
    }
