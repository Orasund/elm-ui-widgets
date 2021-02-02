module Internal.Grid exposing (ColumnStyle, RowStyle)

import Element exposing (Attribute, Element)

{-| -}
type alias RowStyle msg =
    { elementRow : List (Attribute msg)
    , content :
        { element : List (Attribute msg)
        , ifFirst : List (Attribute msg)
        , ifLast : List (Attribute msg)
        , ifSingleton : List (Attribute msg)
        , otherwise : List (Attribute msg)
        }
    }


{-| -}
type alias ColumnStyle msg =
    { elementColumn : List (Attribute msg)
    , content :
        { element : List (Attribute msg)
        , ifFirst : List (Attribute msg)
        , ifLast : List (Attribute msg)
        , ifSingleton : List (Attribute msg)
        , otherwise : List (Attribute msg)
        }
    }