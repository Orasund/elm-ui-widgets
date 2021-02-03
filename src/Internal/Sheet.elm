module Internal.Sheet exposing (SideSheetStyle, sideSheet)

import Element exposing (Attribute, Element)
import Internal.Item exposing (Item)
import Internal.List as List exposing (ColumnStyle)
import Widget.Customize as Customize


type alias SideSheetStyle msg =
    { element : List (Attribute msg)
    , content : ColumnStyle msg
    }


sideSheet : SideSheetStyle msg -> List (Item msg) -> Element msg
sideSheet style =
    List.itemList (style.content |> Customize.elementColumn [ Element.height <| Element.fill ])
        >> Element.el (style.element ++ [ Element.height <| Element.fill ])
