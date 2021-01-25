module Example.List exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Widget
import Widget exposing (ColumnStyle, DividerStyle,ExpansionItemStyle, ItemStyle, HeaderStyle,TextItemStyle,ExpansionPanelStyle)
import Widget.Style.Material as Material
import FeatherIcons
import Widget.Icon as Icon
import Element.Font as Font
import Widget.Style.Material.Color as MaterialColor

type alias Style style msg =
    { style
        | cardColumn : ColumnStyle msg
        , insetDivider : ItemStyle (DividerStyle msg)
        , middleDivider : ItemStyle (DividerStyle msg)
        , fullBleedDivider : ItemStyle (DividerStyle msg)
        , insetHeader : ItemStyle (HeaderStyle msg)
        , fullBleedHeader : ItemStyle (HeaderStyle msg)
        , textItem : ItemStyle (TextItemStyle msg)
        , expansionPanelItem : ItemStyle (ExpansionPanelStyle msg)
        , expansionItem : ExpansionItemStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { cardColumn = Material.cardColumn Material.defaultPalette
    , insetDivider = Material.insetDivider Material.defaultPalette
    , middleDivider = Material.middleDivider Material.defaultPalette
    , fullBleedDivider = Material.fullBleedDivider Material.defaultPalette
    , insetHeader = Material.insetHeader Material.defaultPalette
    , fullBleedHeader = Material.fullBleedHeader Material.defaultPalette
    , textItem = Material.textItem Material.defaultPalette
    , expansionPanelItem = Material.expansionPanelItem Material.defaultPalette
    , expansionItem = Material.expansionItem Material.defaultPalette
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
    , Widget.item <| Element.text <| "Custom Item"
    , Widget.divider style.middleDivider
    , Widget.item <| Element.el [Element.centerY ] <|  Element.text <| "Custom Item (centered)"
    , "Section 2"
        |> Widget.headerItem style.fullBleedHeader
    , Widget.textItem style.textItem
        { onPress = Nothing
        , icon = 
            FeatherIcons.triangle
            |> Icon.elmFeather FeatherIcons.toHtml
        , text = "Item with Icon"
        , content = \{size,color} ->
            "1."
            |> Element.text
            |> Element.el
                [Font.color <| MaterialColor.fromColor color
                ,Font.size size
                ]
        }
    , Widget.divider style.insetDivider
    , Widget.textItem style.textItem
        { onPress = not isExpanded |>ToggleCollapsable |> msgMapper |> Just
        , icon = always Element.none
        , text = "Click Me"
        , content =
            \{size,color} ->
            "2."
            |> Element.text
            |> Element.el
                [Font.color <| MaterialColor.fromColor color
                ,Font.size size
                ]
        }
    , Widget.divider style.fullBleedDivider
    ]++ (Widget.expansionItem style.expansionItem
        { onToggle = ToggleCollapsable >> msgMapper
        , isExpanded = isExpanded
        , icon = always Element.none
        , text = "Expandable Item"
        , content = 
            [  "Section 3"
            |> Widget.headerItem style.insetHeader
        , Widget.textItem style.textItem
        { onPress = Nothing
        , icon =  always Element.none
        , text = "Item"
        , content =
            \{size,color} ->
            "3."
            |> Element.text
            |> Element.el
                [Font.color <| MaterialColor.fromColor color
                ,Font.size size
                ]
        }
        ]
        })
        |> Widget.itemList style.cardColumn


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
