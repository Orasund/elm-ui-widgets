module Internal.Tab exposing (Tab, tab)

import Element exposing (Element)
import Internal.Select as Select exposing (Select)
import Widget.Style exposing (TabStyle)


type alias Tab msg =
    { tabs : Select msg
    , content : Maybe Int -> Element msg
    }


tab : TabStyle msg -> Tab msg -> Element msg
tab style { tabs, content } =
    [ tabs
        |> Select.select
        |> List.map (Select.selectButton style.content.tabs.content)
        |> Element.row style.content.tabs.containerRow
    , tabs.selected
        |> content
        |> Element.el style.content.content
    ]
        |> Element.column style.containerColumn