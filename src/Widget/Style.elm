module Widget.Style exposing (ButtonStyle, SwitchStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, LayoutStyle, RowStyle, SnackbarStyle, SortTableStyle, TabStyle, TextInputStyle, ProgressIndicatorStyle)

{-| This module contains style types for every widget.

@docs ButtonStyle, SwitchStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, LayoutStyle, RowStyle, SnackbarStyle, SortTableStyle, TabStyle, TextInputStyle, ProgressIndicatorStyle

-}

import Color exposing (Color)
import Element exposing (Attribute, Element)
import Html exposing (Html)
import Widget.Icon as Icon exposing (Icon)


type alias IconStyle =
    { size : Int
    , color : Color
    }


{-| -}
type alias SwitchStyle msg =
    { elementButton : List (Attribute msg)
    , content :
        { element : List (Attribute msg)
        , ifDisabled : List (Attribute msg)
        , ifActive : List (Attribute msg)
        , otherwise : List (Attribute msg)
        }
    , contentInFront :
        { element : List (Attribute msg)
        , ifDisabled : List (Attribute msg)
        , ifActive : List (Attribute msg)
        , otherwise : List (Attribute msg)
        , content :
            { element : List (Attribute msg)
            , ifDisabled : List (Attribute msg)
            , ifActive : List (Attribute msg)
            , otherwise : List (Attribute msg)
            }
        }
    }


{-| -}
type alias ButtonStyle msg =
    { elementButton : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , ifActive : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content :
        { elementRow : List (Attribute msg)
        , content :
            { text : { contentText : List (Attribute msg) }
            , icon :
                { ifDisabled : IconStyle
                , ifActive : IconStyle
                , otherwise : IconStyle
                }
            }
        }
    }


{-| -}
type alias DialogStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { title :
            { contentText : List (Attribute msg)
            }
        , text :
            { contentText : List (Attribute msg)
            }
        , buttons :
            { elementRow : List (Attribute msg)
            , content :
                { accept : ButtonStyle msg
                , dismiss : ButtonStyle msg
                }
            }
        }
    }


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
                , expandIcon : Icon
                , collapseIcon : Icon
                , icon : IconStyle
                }
            }
        , content :
            { element : List (Attribute msg)
            }
        }
    }


{-| -}
type alias SnackbarStyle msg =
    { elementRow : List (Attribute msg)
    , content :
        { text :
            { elementText : List (Attribute msg)
            }
        , button : ButtonStyle msg
        }
    }


{-| -}
type alias TextInputStyle msg =
    { elementRow : List (Attribute msg)
    , content :
        { chips :
            { elementRow : List (Attribute msg)
            , content : ButtonStyle msg
            }
        , text :
            { elementTextInput : List (Attribute msg)
            }
        }
    }


{-| -}
type alias TabStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { tabs :
            { elementRow : List (Attribute msg)
            , content : ButtonStyle msg
            }
        , content : List (Attribute msg)
        }
    }


{-| -}
type alias RowStyle msg =
    { elementRow : List (Attribute msg)
    , ifFirst : List (Attribute msg)
    , ifLast : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content : List (Attribute msg)
    }


{-| -}
type alias ColumnStyle msg =
    { elementColumn : List (Attribute msg)
    , ifFirst : List (Attribute msg)
    , ifLast : List (Attribute msg)
    , otherwise : List (Attribute msg)
    , content : List (Attribute msg)
    }


{-| Technical Remark:

  - If icons are defined in Svg, they might not display correctly.
    To avoid that, make sure to wrap them in `Element.html >> Element.el []`

-}
type alias SortTableStyle msg =
    { elementTable : List (Attribute msg)
    , content :
        { header : ButtonStyle msg
        , ascIcon : Icon
        , descIcon : Icon
        , defaultIcon : Icon
        }
    }


{-| Technical Remark:

  - If icons are defined in Svg, they might not display correctly.
    To avoid that, make sure to wrap them in `Element.html >> Element.el []`

-}
type alias LayoutStyle msg =
    { container : List (Attribute msg)
    , snackbar : SnackbarStyle msg
    , layout : List (Attribute msg) -> Element msg -> Html msg
    , header : List (Attribute msg)
    , sheet : List (Attribute msg)
    , sheetButton : ButtonStyle msg
    , menuButton : ButtonStyle msg
    , menuTabButton : ButtonStyle msg
    , menuIcon : Icon
    , moreVerticalIcon : Icon
    , spacing : Int
    , title : List (Attribute msg)
    , searchIcon : Icon
    , search : List (Attribute msg)
    , searchFill : List (Attribute msg)
    }


{-| -}
type alias ProgressIndicatorStyle msg =
    { elementFunction : Maybe Float -> Element msg
    }
