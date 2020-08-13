module Widget.Style exposing (ButtonStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, LayoutStyle, RowStyle, SnackbarStyle, SortTableStyle, TabStyle, TextInputStyle, ProgressIndicatorStyle)

{-| This module contains style types for every widget.

@docs ButtonStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, LayoutStyle, RowStyle, SnackbarStyle, SortTableStyle, TabStyle, TextInputStyle, ProgressIndicatorStyle

-}

import Element exposing (Attribute, Element)
import Html exposing (Html)


{-| -}
type alias ButtonStyle msg =
    { container : List (Attribute msg)
    , labelRow : List (Attribute msg)
    , text : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , ifActive : List (Attribute msg)
    , otherwise : List (Attribute msg)
    }


{-| -}
type alias DialogStyle msg =
    { containerColumn : List (Attribute msg)
    , title : List (Attribute msg)
    , buttonRow : List (Attribute msg)
    , acceptButton : ButtonStyle msg
    , dismissButton : ButtonStyle msg
    , text : List (Attribute msg)
    }


{-| Technical Remark:

  - If icons are defined in Svg, they might not display correctly.
    To avoid that, make sure to wrap them in `Element.html >> Element.el []`

-}
type alias ExpansionPanelStyle msg =
    { containerColumn : List (Attribute msg)
    , panelRow : List (Attribute msg)
    , labelRow : List (Attribute msg)
    , content : List (Attribute msg)
    , expandIcon : Element Never
    , collapseIcon : Element Never
    }


{-| -}
type alias SnackbarStyle msg =
    { containerRow : List (Attribute msg)
    , text : List (Attribute msg)
    , button : ButtonStyle msg
    }


{-| -}
type alias TextInputStyle msg =
    { chipButton : ButtonStyle msg
    , containerRow : List (Attribute msg)
    , chipsRow : List (Attribute msg)
    , input : List (Attribute msg)
    }


{-| -}
type alias TabStyle msg =
    { button : ButtonStyle msg
    , optionRow : List (Attribute msg)
    , containerColumn : List (Attribute msg)
    , content : List (Attribute msg)
    }


{-| -}
type alias RowStyle msg =
    { containerRow : List (Attribute msg)
    , element : List (Attribute msg)
    , ifFirst : List (Attribute msg)
    , ifLast : List (Attribute msg)
    , otherwise : List (Attribute msg)
    }


{-| -}
type alias ColumnStyle msg =
    { containerColumn : List (Attribute msg)
    , element : List (Attribute msg)
    , ifFirst : List (Attribute msg)
    , ifLast : List (Attribute msg)
    , otherwise : List (Attribute msg)
    }


{-| Technical Remark:

  - If icons are defined in Svg, they might not display correctly.
    To avoid that, make sure to wrap them in `Element.html >> Element.el []`

-}
type alias SortTableStyle msg =
    { containerTable : List (Attribute msg)
    , headerButton : ButtonStyle msg
    , ascIcon : Element Never
    , descIcon : Element Never
    , defaultIcon : Element Never
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
    , menuIcon : Element Never
    , moreVerticalIcon : Element Never
    , spacing : Int
    , title : List (Attribute msg)
    , searchIcon : Element Never
    , search : List (Attribute msg)
    , searchFill : List (Attribute msg)
    }


{-| -}
type alias ProgressIndicatorStyle msg =
    { containerFunction : Maybe Float -> Element msg
    }
