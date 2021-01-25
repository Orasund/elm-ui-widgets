module Internal.Item exposing (DividerStyle, HeaderStyle, ImageItemStyle, ImageItem, MultiLineItemStyle,multiLineItem,imageItem, ExpansionItemStyle,ExpansionItem, Item, ItemStyle, TextItem, TextItemStyle,expansionItem, divider, headerItem, item, textItem, toItem)

import Element exposing (Attribute, Element)
import Element.Input as Input
import Widget.Icon as Icon exposing (Icon, IconStyle)
import Widget.Style.Customize exposing (content)


type alias ItemStyle content msg =
    { element : List (Attribute msg)
    , content : content
    }


type alias DividerStyle msg =
    { element : List (Attribute msg)
    }


type alias HeaderStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { divider : DividerStyle msg
        , title : List (Attribute msg)
        }
    }


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

type alias MultiLineItemStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { elementRow : List (Attribute msg)
        , content :
            { description : 
                { elementColumn :  List (Attribute msg)
                , content :
                    { title : {elementText : List (Attribute msg)}
                    , text : {elementText : List (Attribute msg)}
                    }
                }
            , icon : 
                { element : List (Attribute msg)
                , content : IconStyle
                }
            , content : IconStyle
            }
        }
    }

type alias ImageItemStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { elementRow : List (Attribute msg)
        , content :
            { text : { elementText : List (Attribute msg) }
            , image : { element : List (Attribute msg) }
            , content : IconStyle
            }
        }
    }

type alias ExpansionItemStyle msg =
    { item : ItemStyle (TextItemStyle msg) msg
    , expandIcon : Icon msg
    , collapseIcon : Icon msg
    }

type alias Item msg =
    List (Attribute msg) -> Element msg


type alias TextItem msg =
    { text : String
    , onPress : Maybe msg
    , icon : Icon msg
    , content : Icon msg
    }

type alias ImageItem msg =
    { text : String
    , onPress : Maybe msg
    , image : Element msg
    , content : Icon msg
    }

type alias ExpansionItem msg =
    { icon : Icon msg
    , text : String
    , onToggle : Bool -> msg
    , content : List (Item msg)
    , isExpanded : Bool
    }

type alias MultiLineItem msg =
    { title : String
    , text : String
    , onPress : Maybe msg
    , icon : Icon msg
    , content : Icon msg
    }

item : Element msg -> Item msg
item element =
    toItem
        { element = []
        , content = ()
        }
        (always element)


divider : ItemStyle (DividerStyle msg) msg -> Item msg
divider style =
    toItem style (\{ element } -> Element.none |> Element.el element)


headerItem : ItemStyle (HeaderStyle msg) msg -> String -> Item msg
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


textItem : ItemStyle (TextItemStyle msg) msg -> TextItem msg -> Item msg
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
                        |> Element.el style.content.content.icon.element
                    , text
                        |> Element.text
                        |> List.singleton
                        |> Element.paragraph []
                        |> Element.el style.content.content.text.elementText
                    , content style.content.content.content
                    ]
                        |> Element.row style.content.elementRow
                }
        )

imageItem : ItemStyle (ImageItemStyle msg) msg -> ImageItem msg -> Item msg
imageItem s { onPress, text, image, content } =
    toItem s
        (\style ->
            Input.button (style.elementButton ++ (if onPress == Nothing then
                    style.ifDisabled

                else
                    style.otherwise
               ))
                { onPress = onPress
                , label =
                    [ image 
                        |> Element.el style.content.content.image.element
                    , text
                        |> Element.text
                        |> List.singleton
                        |> Element.paragraph []
                        |> Element.el style.content.content.text.elementText
                    , content style.content.content.content
                    ]
                        |> Element.row style.content.elementRow
                }
        )



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

multiLineItem : ItemStyle (MultiLineItemStyle msg) msg -> MultiLineItem msg -> Item msg
multiLineItem s { onPress, title,text, icon, content } =
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
                        |> Element.el style.content.content.icon.element
                    ,   [ title
                            |> Element.text
                            |> List.singleton
                            |> Element.paragraph style.content.content.description.content.title.elementText
                        , text
                            |> Element.text
                            |> List.singleton
                            |> Element.paragraph style.content.content.description.content.text.elementText
                        ]
                        |> Element.column style.content.content.description.elementColumn
                    , content style.content.content.content
                    ]
                        |> Element.row style.content.elementRow
                }
        )

toItem : ItemStyle style msg -> (style -> Element msg) -> Item msg
toItem style element =
    \attr ->
        element style.content
            |> Element.el
                (attr ++ (style.element))