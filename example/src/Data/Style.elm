module Data.Style exposing (Style, style)

import Element exposing (Attribute)
import Element.Border as Border
import Element.Font as Font
import Widget
    exposing
        ( AppBarStyle
        , ButtonStyle
        , ColumnStyle
        , DialogStyle
        , DividerStyle
        , ExpansionItemStyle
        , FullBleedItemStyle
        , HeaderStyle
        , ImageItemStyle
        , InsetItemStyle
        , ItemStyle
        , MultiLineItemStyle
        , PasswordInputStyle
        , ProgressIndicatorStyle
        , RowStyle
        , SortTableStyle
        , SwitchStyle
        , TabStyle
        , TextInputStyle
        )
import Widget.Icon exposing (Icon)
import Widget.Material as Material exposing (Palette)
import Widget.Material.Color as MaterialColor
import Widget.Snackbar exposing (SnackbarStyle)


style : Palette -> Style msg
style palette =
    { container =
        (Material.defaultPalette.background |> MaterialColor.textAndBackground)
            ++ [ Font.family
                    [ Font.typeface "Roboto"
                    , Font.sansSerif
                    ]
               , Font.size 16
               , Font.letterSpacing 0.5
               ]
    , containedButton = Material.containedButton Material.defaultPalette
    , outlinedButton = Material.outlinedButton Material.defaultPalette
    , textButton = Material.textButton Material.defaultPalette
    , iconButton = Material.iconButton Material.defaultPalette
    , sortTable = Material.sortTable palette
    , row = Material.row
    , buttonRow = Material.buttonRow
    , cardColumn = Material.cardColumn palette
    , column = Material.column
    , button = Material.outlinedButton palette
    , primaryButton = Material.containedButton palette
    , selectButton = Material.toggleButton palette
    , tab = Material.tab palette
    , textInput = Material.textInput palette
    , passwordInput = Material.passwordInput palette
    , chipButton = Material.chip palette
    , dialog = Material.alertDialog palette
    , progressIndicator = Material.progressIndicator palette
    , switch = Material.switch palette
    , fullBleedDivider = Material.fullBleedDivider palette
    , insetDivider = Material.insetDivider palette
    , middleDivider = Material.middleDivider palette
    , insetHeader = Material.insetHeader palette
    , fullBleedHeader = Material.fullBleedHeader palette
    , insetItem = Material.insetItem palette
    , multiLineItem = Material.multiLineItem palette
    , imageItem = Material.imageItem palette
    , expansionItem = Material.expansionItem palette
    , sideSheet = Material.sideSheet palette
    , fullBleedItem = Material.fullBleedItem Material.defaultPalette
    , selectItem = Material.selectItem Material.defaultPalette
    , menuBar = Material.menuBar Material.defaultPalette
    , tabBar = Material.tabBar Material.defaultPalette
    , sheetButton = Material.selectItem Material.defaultPalette
    , searchFill =
        { elementRow =
            (Material.defaultPalette.surface
                |> MaterialColor.textAndBackground
            )
                ++ [ Element.height <| Element.px 56 ]
        , content =
            { chips =
                { elementRow = [ Element.spacing 8 ]
                , content = Material.chip Material.defaultPalette
                }
            , text =
                { elementTextInput =
                    (Material.defaultPalette.surface
                        |> MaterialColor.textAndBackground
                    )
                        ++ [ Border.width 0
                           , Element.mouseOver []
                           , Element.focused []
                           ]
                }
            }
        }
    , snackbar = Material.snackbar Material.defaultPalette
    }


type alias Style msg =
    { container : List (Attribute msg)
    , containedButton : ButtonStyle msg
    , outlinedButton : ButtonStyle msg
    , textButton : ButtonStyle msg
    , iconButton : ButtonStyle msg
    , dialog : DialogStyle msg
    , button : ButtonStyle msg
    , switch : SwitchStyle msg
    , primaryButton : ButtonStyle msg
    , tab : TabStyle msg
    , textInput : TextInputStyle msg
    , passwordInput : PasswordInputStyle msg
    , chipButton : ButtonStyle msg
    , row : RowStyle msg
    , buttonRow : RowStyle msg
    , column : ColumnStyle msg
    , cardColumn : ColumnStyle msg
    , sortTable : SortTableStyle msg
    , selectButton : ButtonStyle msg
    , progressIndicator : ProgressIndicatorStyle msg
    , insetDivider : ItemStyle (DividerStyle msg) msg
    , middleDivider : ItemStyle (DividerStyle msg) msg
    , fullBleedDivider : ItemStyle (DividerStyle msg) msg
    , insetHeader : ItemStyle (HeaderStyle msg) msg
    , fullBleedHeader : ItemStyle (HeaderStyle msg) msg
    , insetItem : ItemStyle (InsetItemStyle msg) msg
    , multiLineItem : ItemStyle (MultiLineItemStyle msg) msg
    , imageItem : ItemStyle (ImageItemStyle msg) msg
    , expansionItem : ExpansionItemStyle msg
    , sideSheet : ColumnStyle msg
    , fullBleedItem : ItemStyle (FullBleedItemStyle msg) msg
    , selectItem : ItemStyle (ButtonStyle msg) msg
    , menuBar :
        AppBarStyle
            { menuIcon : Icon msg
            , title : List (Attribute msg)
            }
            msg
    , tabBar :
        AppBarStyle
            { menuTabButton : ButtonStyle msg
            , title : List (Attribute msg)
            }
            msg
    , sheetButton : ItemStyle (ButtonStyle msg) msg
    , searchFill : TextInputStyle msg
    , snackbar : SnackbarStyle msg
    }
