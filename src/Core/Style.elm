module Core.Style exposing (Style, menuButton, menuIconButton, menuTabButton, sheetButton)

import Element exposing (Attribute, Element)
import Html exposing (Html)
import Widget
import Widget.Button as Button exposing (Button, ButtonStyle)


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


menuButton : Style style msg -> ( Bool, Button msg ) -> Element msg
menuButton style =
    Widget.selectButton style.menuButton


menuIconButton : Style style msg -> Button msg -> Element msg
menuIconButton style =
    Button.viewIconOnly style.menuButton


sheetButton : Style style msg -> ( Bool, Button msg ) -> Element msg
sheetButton style =
    Widget.selectButton style.sheetButton


menuTabButton : Style style msg -> ( Bool, Button msg ) -> Element msg
menuTabButton style =
    Widget.selectButton style.menuTabButton
