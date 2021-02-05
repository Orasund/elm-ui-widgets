module Example.List exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Element.Font as Font
import FeatherIcons
import Widget exposing (ButtonStyle, ColumnStyle, DividerStyle, ExpansionItemStyle, FullBleedItemStyle, HeaderStyle, ImageItemStyle, InsetItemStyle, ItemStyle, MultiLineItemStyle, SwitchStyle)
import Widget.Icon as Icon
import Widget.Material as Material
import Widget.Material.Color as MaterialColor


type alias Style style msg =
    { style
        | cardColumn : ColumnStyle msg
        , insetDivider : ItemStyle (DividerStyle msg) msg
        , middleDivider : ItemStyle (DividerStyle msg) msg
        , fullBleedDivider : ItemStyle (DividerStyle msg) msg
        , insetHeader : ItemStyle (HeaderStyle msg) msg
        , fullBleedHeader : ItemStyle (HeaderStyle msg) msg
        , insetItem : ItemStyle (InsetItemStyle msg) msg
        , imageItem : ItemStyle (ImageItemStyle msg) msg
        , expansionItem : ExpansionItemStyle msg
        , switch : SwitchStyle msg
        , multiLineItem : ItemStyle (MultiLineItemStyle msg) msg
        , fullBleedItem : ItemStyle (FullBleedItemStyle msg) msg
        , selectItem : ItemStyle (ButtonStyle msg) msg
    }


materialStyle : Style {} msg
materialStyle =
    { cardColumn = Material.cardColumn Material.defaultPalette
    , insetDivider = Material.insetDivider Material.defaultPalette
    , middleDivider = Material.middleDivider Material.defaultPalette
    , fullBleedDivider = Material.fullBleedDivider Material.defaultPalette
    , insetHeader = Material.insetHeader Material.defaultPalette
    , fullBleedHeader = Material.fullBleedHeader Material.defaultPalette
    , insetItem = Material.insetItem Material.defaultPalette
    , imageItem = Material.imageItem Material.defaultPalette
    , expansionItem = Material.expansionItem Material.defaultPalette
    , switch = Material.switch Material.defaultPalette
    , multiLineItem = Material.multiLineItem Material.defaultPalette
    , fullBleedItem = Material.fullBleedItem Material.defaultPalette
    , selectItem = Material.selectItem Material.defaultPalette
    }


type Model
    = IsExpanded Bool


type Msg
    = ToggleCollapsable Bool


init : ( Model, Cmd Msg )
init =
    ( IsExpanded False
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ToggleCollapsable bool ->
            ( IsExpanded bool
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (IsExpanded isExpanded) =
    [ "Section 1"
        |> Widget.headerItem style.fullBleedHeader
    , Widget.asItem <| Element.text <| "Custom Item"
    , Widget.divider style.middleDivider
    , Widget.fullBleedItem style.fullBleedItem
        { onPress = Nothing
        , icon =
            \_ ->
                Element.none
        , text = "Full Bleed Item"
        }
    , "Section 2"
        |> Widget.headerItem style.fullBleedHeader
    , Widget.insetItem style.insetItem
        { onPress = Nothing
        , icon =
            FeatherIcons.triangle
                |> Icon.elmFeather FeatherIcons.toHtml
        , text = "Item with Icon"
        , content =
            \_ ->
                Element.none
        }
    , Widget.imageItem style.imageItem
        { onPress = Nothing
        , image =
            Element.image [ Element.width <| Element.px <| 40, Element.height <| Element.px <| 40 ]
                { src = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Elm_logo.svg/1024px-Elm_logo.svg.png"
                , description = "Elm logo"
                }
        , text = "Item with Image"
        , content =
            \{ size, color } ->
                "1."
                    |> Element.text
                    |> Element.el
                        [ Font.color <| MaterialColor.fromColor color
                        , Font.size size
                        ]
        }
    , Widget.divider style.insetDivider
    , Widget.insetItem style.insetItem
        { onPress = not isExpanded |> ToggleCollapsable |> msgMapper |> Just
        , icon = always Element.none
        , text = "Click Me"
        , content =
            \{ size, color } ->
                "2."
                    |> Element.text
                    |> Element.el
                        [ Font.color <| MaterialColor.fromColor color
                        , Font.size size
                        ]
        }
    , Widget.multiLineItem style.multiLineItem
        { title = "Item"
        , text = "Description. Description. Description. Description. Description. Description. Description. Description. Description. Description."
        , onPress = Nothing
        , icon = always Element.none
        , content = always Element.none
        }
    , Widget.imageItem style.imageItem
        { onPress = not isExpanded |> ToggleCollapsable |> msgMapper |> Just
        , image = Element.none
        , text = "Clickable Item with Switch"
        , content =
            \_ ->
                Widget.switch style.switch
                    { description = "Click Me"
                    , active = isExpanded
                    , onPress =
                        not isExpanded
                            |> ToggleCollapsable
                            |> msgMapper
                            |> Just
                    }
        }
    , Widget.divider style.fullBleedDivider
    ]
        ++ Widget.expansionItem style.expansionItem
            { onToggle = ToggleCollapsable >> msgMapper
            , isExpanded = isExpanded
            , icon = always Element.none
            , text = "Expandable Item"
            , content =
                [ "Section 3"
                    |> Widget.headerItem style.insetHeader
                , Widget.insetItem style.insetItem
                    { onPress = Nothing
                    , icon = always Element.none
                    , text = "Item"
                    , content =
                        \{ size, color } ->
                            "3."
                                |> Element.text
                                |> Element.el
                                    [ Font.color <| MaterialColor.fromColor color
                                    , Font.size size
                                    ]
                    }
                ]
            }
        ++ [ "Menu" |> Widget.headerItem style.fullBleedHeader ]
        ++ ({ selected =
                if isExpanded then
                    Just 1

                else
                    Just 0
            , options =
                [ True, False ]
                    |> List.map
                        (\bool ->
                            { text =
                                if bool then
                                    "Expanded"

                                else
                                    "Collapsed"
                            , icon = always Element.none
                            }
                        )
            , onSelect =
                \int ->
                    (int == 1)
                        |> ToggleCollapsable
                        |> msgMapper
                        |> Just
            }
                |> Widget.selectItem style.selectItem
           )
        |> Widget.itemList style.cardColumn


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
