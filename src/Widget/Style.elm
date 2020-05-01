module Widget.Style exposing (ButtonStyle, DialogStyle, Style)

import Element exposing (Attribute, Element)
import Html exposing (Html)


type alias ButtonStyle msg =
    { container : List (Attribute msg)
    , disabled : List (Attribute msg)
    , label : List (Attribute msg)
    , active : List (Attribute msg)
    }


type alias DialogStyle msg =
    { containerColumn : List (Attribute msg)
    , title : List (Attribute msg)
    , buttonRow : List (Attribute msg)
    , accept : ButtonStyle msg
    , dismiss : ButtonStyle msg
    }


type alias Style style msg =
    { style
        | snackbar :
            { row : List (Attribute msg)
            , text : List (Attribute msg)
            , button : ButtonStyle msg
            }
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
