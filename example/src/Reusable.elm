module Reusable exposing ( view)

import Browser
import Element exposing (Color, Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Framework
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Framework.Group as Group
import Framework.Heading as Heading
import Framework.Input as Input
import Framework.Tag as Tag
import Heroicons.Solid as Heroicons
import Html exposing (Html)
import Html.Attributes as Attributes
import Set exposing (Set)
import Time
import Widget
import Widget.ScrollingNav as ScrollingNav
import Widget.Snackbar as Snackbar
import Data.Style exposing (Style)
import Data.Theme as Theme exposing (Theme)


type alias Item =
    { name : String
    , amount : Int
    , price : Float
    }



snackbar : Style msg -> (( String, Bool ) -> msg) -> ( String, Element msg,Element msg )
snackbar style addSnackbar =
    ( "Snackbar"
    , [ Widget.button style.button
            { onPress =
                Just <|
                    addSnackbar <|
                        ( "This is a notification. It will disappear after 10 seconds."
                        , False
                        )
            , text = "Add Notification"
            , icon =Element.none
            }
      , Widget.button style.button
            { onPress =
                Just <|
                    addSnackbar <|
                        ( "You can add another notification if you want."
                        , True
                        )
            , text = "Add Notification with Action"
            , icon = Element.none
            }
      ]
        |> Element.column Grid.simple
    , Element.none
    )





scrollingNavCard : Style msg -> ( String, Element msg, Element msg )
scrollingNavCard style =
    ( "Scrolling Nav"
    , Element.text "Resize the screen and open the side-menu. Then start scrolling to see the scrolling navigation in action."
        |> List.singleton
        |> Element.paragraph []
    , Element.none
    )


view :
    Theme ->
    { addSnackbar : ( String, Bool ) -> msg
    }
    ->
        { title : String
        , description : String
        , items : List ( String, Element msg,Element msg )
        }
view theme { addSnackbar } =
    let
        style = Theme.toStyle theme
    in
    { title = "Reusable Views"
    , description = "Reusable views have an internal state but no update function. You will need to do some wiring, but nothing complicated."
    , items =
        [ snackbar style addSnackbar
        , scrollingNavCard style
        ]
    }
