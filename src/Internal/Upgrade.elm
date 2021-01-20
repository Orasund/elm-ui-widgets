module Internal.Upgrade exposing (upgradeButton,upgradeDialog,upgradeSortTable,upgradeTextInput,upgradeExpansionPanel,upgradeSnackbar)

import Widget.Style exposing ( ButtonStyleV2,SnackbarStyleV2, DialogStyleV2, SortTableStyleV2,TextInputStyleV2,ExpansionPanelStyleV2, ButtonStyle, SwitchStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, LayoutStyle, RowStyle, SnackbarStyle, SortTableStyle, TabStyle, TextInputStyle, ProgressIndicatorStyle)


upgradeButton : ButtonStyle msg -> ButtonStyleV2 msg
upgradeButton style =
    { containerButton = style.container
    , ifDisabled = style.ifDisabled
    , ifActive = style.ifActive
    , otherwise = style.otherwise
    , content =
        { containerRow = style.labelRow
        , contentText = style.text
        }
    }

upgradeDialog : DialogStyle msg -> DialogStyleV2 msg
upgradeDialog style =
    { containerColumn = style.containerColumn
    , content =
        { title =
            { contentText = style.title
            }
        , text =
            { contentText = style.text
            }
        , buttons =
            { containerRow = style.buttonRow
            , content =
                { accept = upgradeButton style.acceptButton
                , dismiss = upgradeButton style.dismissButton
                }
            }
        }
    }

upgradeSortTable : SortTableStyle msg -> SortTableStyleV2 msg
upgradeSortTable style =
    { containerTable = style.containerTable
    , content =
        { header = upgradeButton style.headerButton
        , ascIcon = style.ascIcon
        , descIcon = style.descIcon
        , defaultIcon = style.defaultIcon
        }
    }

upgradeTextInput : TextInputStyle msg -> TextInputStyleV2 msg
upgradeTextInput style =
    { containerRow = style.containerRow
    , content =
        { chips =
            { containerRow = style.chipsRow
            , content = upgradeButton style.chipButton
            }
        , text =
            { containerTextInput = style.input
            }
        }
    }


upgradeExpansionPanel : ExpansionPanelStyle msg -> ExpansionPanelStyleV2 msg
upgradeExpansionPanel style =
    { containerColumn = style.containerColumn
    , content =
        { panel =
            { containerRow = style.panelRow
            , content =
                { label =
                    { containerRow = style.labelRow
                    }
                , expandIcon = style.expandIcon
                , collapseIcon = style.collapseIcon
                }
            } 
        , content =
            { container = style.content
            }
        }
    }

upgradeSnackbar : SnackbarStyle msg -> SnackbarStyleV2 msg
upgradeSnackbar style =
    { containerRow = style.containerRow
    , content =
        { text =
            { containerText = style.text
            }
        , button = upgradeButton style.button
        }
    }