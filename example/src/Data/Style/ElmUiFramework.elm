module Data.Style.ElmUiFramework exposing (style)

import Data.Style exposing (Style)
import Element
import Element.Border as Border
import Element.Font as Font
import Framework
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Framework.Group as Group
import Framework.Heading as Heading
import Framework.Tag as Tag
import Icons
import Widget.Style
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , ExpansionPanelStyle
        , RowStyle
        , SnackbarStyle
        , SortTableStyle
        , TabStyle
        , TextInputStyle
        )


textButton : ButtonStyle msg
textButton =
    { container = Button.simple
    , labelRow = Grid.simple
    , ifDisabled = Color.disabled
    , ifActive = Color.primary
    , otherwise = []
    }


simpleButton : ButtonStyle msg
simpleButton =
    { container = Button.simple ++ Color.success
    , labelRow = Grid.simple
    , ifDisabled = Color.disabled
    , ifActive = Color.primary
    , otherwise = []
    }


menuTabButton : ButtonStyle msg
menuTabButton =
    { container =
        [ Element.height <| Element.px <| 42
        , Border.widthEach
            { top = 0
            , left = 0
            , right = 0
            , bottom = 4
            }
        , Element.paddingEach
            { top = 12
            , left = 8
            , right = 8
            , bottom = 4
            }
        , Border.color Color.black
        ]
    , labelRow = Grid.simple
    , ifDisabled = Color.disabled
    , ifActive = [ Border.color Color.turquoise ]
    , otherwise = []
    }


menuButton : ButtonStyle msg
menuButton =
    { labelRow = Grid.simple
    , container = Button.simple ++ Group.center ++ Color.dark
    , ifDisabled = Color.disabled
    , ifActive = Color.primary
    , otherwise = []
    }


sheetButton : ButtonStyle msg
sheetButton =
    { container =
        Button.fill
            ++ Group.center
            ++ Color.light
            ++ [ Font.alignLeft ]
    , labelRow = Grid.simple
    , ifDisabled = Color.disabled
    , ifActive = Color.primary
    , otherwise = []
    }


buttonStyle : ButtonStyle msg
buttonStyle =
    { labelRow = [ Element.spacing 8 ]
    , container = Button.simple
    , ifDisabled = Color.disabled
    , ifActive = Color.primary
    , otherwise = []
    }


snackbarButton : ButtonStyle msg
snackbarButton =
    { labelRow = Grid.simple
    , container = Button.simple ++ Color.dark
    , ifDisabled = Color.disabled
    , ifActive = Color.primary
    , otherwise = []
    }


tabButtonStyle : ButtonStyle msg
tabButtonStyle =
    { labelRow = [ Element.spacing 8 ]
    , container = Button.simple ++ Group.top
    , ifDisabled = Color.disabled
    , ifActive = Color.primary
    , otherwise = []
    }


textInputStyle : TextInputStyle msg
textInputStyle =
    { chipButton = chipButtonStyle
    , chipsRow =
        [ Element.width <| Element.shrink
        , Element.spacing <| 4
        , Element.paddingEach
            { top = 8
            , left = 0
            , right = 0
            , bottom = 8
            }
        ]
    , containerRow =
        Button.simple
            ++ Color.light
            ++ [ Border.color <| Element.rgb255 186 189 182
               , Font.alignLeft
               , Element.paddingXY 8 0
               , Element.height <| Element.px <| 42
               ]
            ++ Grid.simple
    , input =
        Color.light
            ++ [ Element.padding 8
               ]
    }


chipButtonStyle : ButtonStyle msg
chipButtonStyle =
    { container = Tag.simple
    , ifDisabled = []
    , labelRow = Grid.simple
    , ifActive = Color.primary
    , otherwise = []
    }


expansionPanelStyle : ExpansionPanelStyle msg
expansionPanelStyle =
    { containerColumn = Card.simple ++ Grid.simple ++ [ Element.height <| Element.shrink ]
    , panelRow = Grid.spacedEvenly ++ [ Element.height <| Element.shrink ]
    , labelRow = Grid.simple ++ [ Element.height <| Element.shrink ]
    , content = []
    , expandIcon = Icons.chevronDown |> Element.html |> Element.el []
    , collapseIcon = Icons.chevronUp |> Element.html |> Element.el []
    }


dialog : DialogStyle msg
dialog =
    { containerColumn =
        Card.simple
            ++ Grid.simple
            ++ [ Element.centerY
               , Element.width <| Element.minimum 280 <| Element.maximum 560 <| Element.fill
               ]
    , title = Heading.h3
    , buttonRow =
        Grid.simple
            ++ [ Element.paddingEach
                    { top = 28
                    , bottom = 0
                    , left = 0
                    , right = 0
                    }
               ]
    , acceptButton = simpleButton
    , dismissButton = textButton
    }


snackbar : SnackbarStyle msg
snackbar =
    { containerRow =
        Card.simple
            ++ Color.dark
            ++ Grid.simple
            ++ [ Element.paddingXY 8 6
               , Element.height <| Element.px <| 54
               ]
    , button = snackbarButton
    , text = [ Element.paddingXY 8 0 ]
    }


tab : TabStyle msg
tab =
    { button = tabButtonStyle
    , optionRow = Grid.simple
    , containerColumn = Grid.compact
    , content = Card.small ++ Group.bottom
    }


row : RowStyle msg
row =
    { containerRow = Grid.compact
    , element = []
    , ifFirst = Group.left
    , ifLast = Group.right
    , otherwise = Group.center
    }


cardColumn : ColumnStyle msg
cardColumn =
    { containerColumn = Grid.compact ++ [ Element.height <| Element.fill ]
    , element = Card.large ++ [ Element.height <| Element.fill ]
    , ifFirst = Group.top
    , ifLast = Group.bottom
    , otherwise = Group.center
    }


column : ColumnStyle msg
column =
    { containerColumn = Grid.compact
    , element = []
    , ifFirst = Group.top
    , ifLast = Group.bottom
    , otherwise = Group.center
    }


sortTable : SortTableStyle msg
sortTable =
    { containerTable = Grid.simple
    , headerButton = tabButtonStyle
    , ascIcon = Icons.chevronUp |> Element.html |> Element.el []
    , descIcon = Icons.chevronDown |> Element.html |> Element.el []
    , defaultIcon = Element.none
    }


style : Style msg
style =
    { sortTable = sortTable
    , row = row
    , cardColumn = cardColumn
    , column = column
    , button = buttonStyle
    , primaryButton = simpleButton
    , tab = tab
    , textInput = textInputStyle
    , chipButton = chipButtonStyle
    , expansionPanel = expansionPanelStyle
    , dialog = dialog
    , snackbar = snackbar
    , layout = Framework.responsiveLayout

    {--\a w ->
        Html.div []
        [ Html.node "meta"
            [ Attributes.attribute "name" "viewport"
            , Attributes.attribute "content" "width=device-width, initial-scale=1.0"
            ]
            []
        , Element.layoutWith
            {options = (Element.focusStyle
                { borderColor = Nothing
                , backgroundColor = Nothing
                , shadow = Nothing
                }
                |> List.singleton)
            }
         (Framework.layoutAttributes ++ a) <| w
        ]--}
    , header =
        Framework.container
            ++ Color.dark
            ++ [ Element.padding <| 0
               , Element.height <| Element.px <| 42
               ]
    , menuButton = menuButton
    , sheetButton = sheetButton
    , menuTabButton = menuTabButton
    , sheet =
        Color.light ++ [ Element.width <| Element.maximum 256 <| Element.fill ]
    , menuIcon =
        Icons.menu |> Element.html |> Element.el []
    , moreVerticalIcon =
        Icons.moreVertical |> Element.html |> Element.el []
    , spacing = 8
    , title = Heading.h2
    , searchIcon =
        Icons.search |> Element.html |> Element.el []
    , search =
        Color.simple
            ++ Card.large
            ++ [ Font.color <| Element.rgb255 0 0 0
               , Element.padding 6
               , Element.centerY
               , Element.alignRight
               ]
    , searchFill =
        Color.light ++ Group.center
    }
