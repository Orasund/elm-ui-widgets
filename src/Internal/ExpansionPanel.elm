module Internal.ExpansionPanel exposing (ExpansionPanel, expansionPanel)

{-| Part of Material Design Lists
-}

import Element exposing (Element)
import Element.Events as Events
import Widget.Style exposing (ExpansionPanelStyle)


type alias ExpansionPanel msg =
    { onToggle : Bool -> msg
    , icon : Element Never
    , text : String
    , content : Element msg
    , isExpanded : Bool
    }


expansionPanel :
    ExpansionPanelStyle msg
    -> ExpansionPanel msg
    -> Element msg
expansionPanel style model =
    Element.column style.containerColumn <|
        [ Element.row
            ((Events.onClick <| model.onToggle <| not model.isExpanded)
                :: style.content.panel.containerRow
            )
            [ Element.row style.content.panel.content.label.containerRow
                [ model.icon |> Element.map never
                , model.text |> Element.text
                ]
            , Element.map never <|
                if model.isExpanded then
                    style.content.panel.content.collapseIcon

                else
                    style.content.panel.content.expandIcon
            ]
        , if model.isExpanded then
            Element.el style.content.content.container <| model.content

          else
            Element.none
        ]
