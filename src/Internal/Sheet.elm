module Internal.Sheet exposing (SheetStyle, sheet)

import Element exposing (Attribute, Element)
import Internal.Item exposing (Item)
import Internal.List as List exposing (ColumnStyle)
import Widget.Customize as Customize


type alias SheetStyle msg =
    { element : List (Attribute msg)
    , content : ColumnStyle msg
    }


sheet : SheetStyle msg -> List (Item msg) -> Element msg
sheet style =
    List.itemList (style.content |> Customize.elementColumn [ Element.height <| Element.fill ])
        >> Element.el (style.element ++ [ Element.height <| Element.fill ])
