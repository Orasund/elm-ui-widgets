module Internal.Material.Sheet exposing (sheet)

import Element
import Internal.Material.Palette exposing (Palette)
import Internal.Sheet exposing (SheetStyle)
import Widget.Material.Color as MaterialColor


sheet : Palette -> SheetStyle msg
sheet palette =
    { element = []
    , content =
        { elementColumn =
            (palette.surface |> MaterialColor.textAndBackground)
                ++ [ Element.width <| Element.maximum 360 <| Element.fill
                   , Element.padding 8
                   , Element.spacing 8
                   ]
        , content =
            { element = [ Element.width <| Element.fill ]
            , ifSingleton = []
            , ifFirst = []
            , ifLast = []
            , otherwise = []
            }
        }
    }
