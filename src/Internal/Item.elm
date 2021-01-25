module Internal.Item exposing (DividerStyle, HeaderStyle, ExpansionItemStyle,ExpansionItem, Item, ItemStyle, TextItem, TextItemStyle,expansionItem, divider, headerItem, item, textItem, toItem)

import Element exposing (Attribute, Element)
import Element.Input as Input
import Widget.Icon as Icon exposing (Icon, IconStyle)
import Widget.Style.Customize exposing (content)


{-| -}
type alias ItemStyle content =
    { element : List (Attribute Never)
    , content : content
    }


{-| -}
type alias DividerStyle msg =
    { element : List (Attribute msg)
    }


{-| -}
type alias HeaderStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { divider : DividerStyle msg
        , title : List (Attribute msg)
        }
    }


{-| -}
type alias TextItemStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { elementRow : List (Attribute msg)
        , content :
            { text : { elementText : List (Attribute msg) }
            , icon : 
                { element : List (Attribute msg)
                , content : IconStyle
                }
            , content : IconStyle
            }
        }
    }


type alias Item msg =
    List (Attribute msg) -> Element msg


type alias TextItem msg =
    { text : String
    , onPress : Maybe msg
    , icon : Icon
    , content : Icon
    }


item : Element msg -> Item msg
item element =
    toItem
        { element = []
        , content = ()
        }
        (always element)


divider : ItemStyle (DividerStyle msg) -> Item msg
divider style =
    toItem style (\{ element } -> Element.none |> Element.el element)


headerItem : ItemStyle (HeaderStyle msg) -> String -> Item msg
headerItem style title =
    toItem style
        (\{ elementColumn, content } ->
            [ Element.none
                |> Element.el content.divider.element
            , title
                |> Element.text
                |> Element.el content.title
            ]
                |> Element.column elementColumn
        )


textItem : ItemStyle (TextItemStyle msg) -> TextItem msg -> Item msg
textItem s { onPress, text, icon, content } =
    toItem s
        (\style ->
            Input.button (style.elementButton ++ (if onPress == Nothing then
                    style.ifDisabled

                else
                    style.otherwise
               ))
                { onPress = onPress
                , label =
                    [ icon style.content.content.icon.content
                        |> Element.map never
                        |> Element.el style.content.content.icon.element
                    , text
                        |> Element.text
                        |> List.singleton
                        |> Element.paragraph []
                        |> Element.el style.content.content.text.elementText
                    , content style.content.content.content
                        |> Element.map never
                    ]
                        |> Element.row style.content.elementRow
                }
        )

type alias ExpansionItemStyle msg =
    { item : ItemStyle (TextItemStyle msg)
    , expandIcon : Icon
    , collapseIcon : Icon
    }

type alias ExpansionItem msg =
    { icon : Icon
    , text : String
    , onToggle : Bool -> msg
    , content : List (Item msg)
    , isExpanded : Bool
    }


expansionItem : ExpansionItemStyle msg -> ExpansionItem msg -> List (Item msg)
expansionItem s { icon, text,onToggle,content,isExpanded} =
    (textItem s.item
         { text = text
        , onPress = Just <| onToggle <| not isExpanded
        , icon = icon
        , content =
            (if isExpanded then 
                s.collapseIcon 
            else 
                s.expandIcon )
        
        }
    )
        :: (if isExpanded then content else [])

toItem : ItemStyle style -> (style -> Element msg) -> Item msg
toItem style element =
    \attr ->
        element style.content
            |> Element.el
                (attr ++ (style.element |> List.map (Element.mapAttribute never)))