module Internal.ExpansionPanel exposing (ExpansionPanel, expansionPanel, expansionPanelItem)

import Element exposing (Element)
import Element.Events as Events
import Widget.Icon exposing (Icon)
import Widget.Style exposing (ExpansionPanelStyle,ItemStyle)
import Internal.List as List exposing (Item)

type alias ExpansionPanel msg =
    { onToggle : Bool -> msg
    , icon : Icon
    , text : String
    , content : Element msg
    , isExpanded : Bool
    }


expansionPanel :
    ExpansionPanelStyle msg
    -> ExpansionPanel msg
    -> Element msg
expansionPanel style model =
    Element.column style.elementColumn <|
        [ Element.row
            ((Events.onClick <| model.onToggle <| not model.isExpanded)
                :: style.content.panel.elementRow
            )
            [ Element.row style.content.panel.content.label.elementRow
                [ model.icon
                    style.content.panel.content.label.content.icon
                    |> Element.map never
                , model.text
                    |> Element.text
                    |> Element.el style.content.panel.content.label.content.text.elementText
                ]
            , Element.map never <|
                if model.isExpanded then
                    style.content.panel.content.collapseIcon
                        style.content.panel.content.label.content.icon

                else
                    style.content.panel.content.expandIcon
                        style.content.panel.content.label.content.icon
            ]
        , if model.isExpanded then
            Element.el style.content.content.element <| model.content

          else
            Element.none
        ]

expansionPanelItem :
    ItemStyle (ExpansionPanelStyle msg)
    ->
        { onToggle : Bool -> msg
        , icon : Icon
        , text : String
        , content : Element msg
        , isExpanded : Bool
        }
    -> Item msg
expansionPanelItem style model =
    List.toItem style (\s -> expansionPanel s model)