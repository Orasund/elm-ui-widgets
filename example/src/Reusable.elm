module Reusable exposing (view)

import Data.Style exposing (Style)
import Data.Theme as Theme exposing (Theme)
import Element exposing (Element)
import Framework.Grid as Grid
import Widget


snackbar : Style msg -> (( String, Bool ) -> msg) -> ( String, Element msg, List (Element msg) )
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
            , icon = Element.none
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
    ,[]
    )


scrollingNavCard : Style msg -> ( String, Element msg, List (Element msg) )
scrollingNavCard _ =
    ( "Scrolling Nav"
    , Element.text "Resize the screen and open the side-menu. Then start scrolling to see the scrolling navigation in action."
        |> List.singleton
        |> Element.paragraph []
    , []
    )


layout : Style msg -> ( String, Element msg, List(Element msg) )
layout _ =
    ( "Layout"
    , Element.text "The layout combines the menu bar, both side bar, the dialog window and the snackbar. Try using all of them and also try resizing the window to see how they interact with each other."
        |> List.singleton
        |> Element.paragraph []
    , []
    )


view :
    { theme : Theme
    , addSnackbar : ( String, Bool ) -> msg
    }
    ->
        { title : String
        , description : String
        , items : List ( String, Element msg, List (Element msg) )
        }
view { theme, addSnackbar } =
    let
        style =
            Theme.toStyle theme
    in
    { title = "Reusable Views"
    , description = "Reusable views have an internal state but no update function. You will need to do some wiring, but nothing complicated."
    , items =
        [ snackbar style addSnackbar
        , scrollingNavCard style
        , layout style
        ]
    }
