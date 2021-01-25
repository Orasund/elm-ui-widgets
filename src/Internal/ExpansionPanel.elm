module Internal.ExpansionPanel exposing (ExpansionPanel, ExpansionPanelStyle, expansionPanel, expansionPanelItem)

import Element exposing (Attribute, Element)
import Element.Events as Events
import Internal.Item as Item exposing (Item, ItemStyle)
import Widget.Icon exposing (Icon, IconStyle)


{-| Technical Remark:

  - If icons are defined in Svg, they might not display correctly.
    To avoid that, make sure to wrap them in `Element.html >> Element.el []`

-}
type alias ExpansionPanelStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { panel :
            { elementRow : List (Attribute msg)
            , content :
                { label :
                    { elementRow : List (Attribute msg)
                    , content :
                        { icon : IconStyle
                        , text : { elementText : List (Attribute msg) }
                        }
                    }
                , expandIcon : Icon msg
                , collapseIcon : Icon msg
                , icon : IconStyle
                }
            }
        , content : {element : List (Attribute msg)}
            }
        }


type alias ExpansionPanel msg =
    { onToggle : Bool -> msg
    , icon : Icon msg
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
                , model.text
                    |> Element.text
                    |> Element.el style.content.panel.content.label.content.text.elementText
                ]
            , if model.isExpanded then
                    style.content.panel.content.collapseIcon
                        style.content.panel.content.icon

                else
                    style.content.panel.content.expandIcon
                        style.content.panel.content.icon
            ]
        , if model.isExpanded then
            Element.el style.content.content.element <| model.content

          else
            Element.none
        ]


expansionPanelItem :
    ItemStyle (ExpansionPanelStyle msg) msg
    ->
        { onToggle : Bool -> msg
        , icon : Icon msg
        , text : String
        , content : Element msg
        , isExpanded : Bool
        }
    -> Item msg
expansionPanelItem style model =
    Item.toItem style (\s -> expansionPanel s model)
