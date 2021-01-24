module Internal.Tab exposing (Tab, TabStyle, tab)

import Color exposing (Color)
import Element exposing (Attribute, Element)
import Html exposing (Html)
import Internal.Button exposing (ButtonStyle)
import Internal.Select as Select exposing (Select)
import Widget.Icon exposing (Icon)


{-| -}
type alias TabStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { tabs :
            { elementRow : List (Attribute msg)
            , content : ButtonStyle msg
            }
        , content : List (Attribute msg)
        }
    }


type alias Tab msg =
    { tabs : Select msg
    , content : Maybe Int -> Element msg
    }


tab : TabStyle msg -> Tab msg -> Element msg
tab style { tabs, content } =
    [ tabs
        |> Select.select
        |> List.map (Select.selectButton style.content.tabs.content)
        |> Element.row style.content.tabs.elementRow
    , tabs.selected
        |> content
        |> Element.el style.content.content
    ]
        |> Element.column style.elementColumn
