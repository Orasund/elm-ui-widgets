module Example exposing (main)

import Browser
import Element exposing (Element)
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
import Html exposing (Html)
import Html.Attributes as Attributes
import Set exposing (Set)
import Widget
import Widget.FilterSelect as FilterSelect
import Widget.ScrollingNav as ScrollingNav
import Widget.ValidatedInput as ValidatedInput
import Widget.Snackbar as Snackbar
import Stateless
import Reusable
import Component
import Time

type Section
    = ComponentViews
    | ReusableViews
    | StatelessViews

type alias Model =
    { component : Component.Model
    , stateless : Stateless.Model
    , reusable : Reusable.Model
    , scrollingNav : ScrollingNav.Model Section
    , snackbar : Snackbar.Model String
    , displayDialog : Bool
    }

type Msg
    = StatelessSpecific Stateless.Msg
    | ReusableSpecific Reusable.Msg
    | ComponentSpecific Component.Msg
    | ScrollingNavSpecific (ScrollingNav.Msg Section)
    | TimePassed Int
    | AddSnackbar String
    | ToggleDialog Bool


init : () -> ( Model, Cmd Msg )
init () =
    let
        ( scrollingNav, cmd ) =
            ScrollingNav.init
                { labels =
                    \section ->
                        case section of
                            ComponentViews ->
                                "Component Views"
                            ReusableViews ->
                                "Reusable Views"

                            StatelessViews ->
                                "Stateless Views"
                , arrangement = [ StatelessViews, ReusableViews, ComponentViews ]
                }
    in
    ({ component = Component.init
      , stateless = Stateless.init
      , reusable = Reusable.init
      , scrollingNav = scrollingNav
      , snackbar = Snackbar.init
      , displayDialog = False
      }
    
    , cmd |> Cmd.map ScrollingNavSpecific
    )




view : Model -> Html Msg
view model =
    [ Element.el [ Element.height <| Element.px <| 42 ] <| Element.none
    , [ Element.el Heading.h1 <| Element.text "Elm-Ui-Widgets"
        , model.scrollingNav
            |> ScrollingNav.view
                (\section ->
                    case section of
                        ComponentViews ->
                            model.component
                            |> Component.view
                            |> Element.map ComponentSpecific
                        ReusableViews ->
                            Reusable.view 
                                {addSnackbar = AddSnackbar
                                ,model = model.reusable 
                                ,msgMapper = ReusableSpecific
                                }
                                
                        StatelessViews ->
                            Stateless.view
                                { msgMapper = StatelessSpecific
                                , showDialog = ToggleDialog True
                                }
                                model.stateless
                )
        ]
        |> Element.column Framework.container
    ]
        |> Element.column Grid.compact
        |> Framework.responsiveLayout
            [ Element.inFront <|
                (model.scrollingNav
                    |> ScrollingNav.viewSections
                        { fromString =
                            \string ->
                                case string of
                                    "Component Views" ->
                                        Just ComponentViews
                                    "Reusable Views" ->
                                        Just ReusableViews

                                    "Stateless Views" ->
                                        Just StatelessViews

                                    _ ->
                                        Nothing
                        , label = Element.text 
                        , msgMapper = ScrollingNavSpecific
                        , attributes = \selected -> Button.simple
                            ++ Group.center
                            ++ (if selected then
                                    Color.primary

                                else
                                    Color.dark
                                )
                        }
                    |> Widget.select
                    |> Element.row
                        (Color.dark ++ Grid.compact)
                    |> Element.el
                        (Framework.container
                            ++ [ Element.padding <| 0
                               , Element.centerX
                               ]
                        )
                    |> Element.el
                        (Color.dark
                            ++ [ Element.alignTop
                               , Element.height <| Element.px <| 42
                               , Element.width <| Element.fill
                               ]
                        )
                )
            , Element.inFront <|
                ( model.snackbar
                    |> Snackbar.current
                    |> Maybe.map
                        (Element.text >>
                            List.singleton >>
                            Element.paragraph (Card.simple ++ Color.dark)
                            >> Element.el [Element.padding 8,Element.alignBottom
                            , Element.alignRight]


                        )
                    |> Maybe.withDefault Element.none
                )
            , Element.inFront <|
                if model.displayDialog then
                    Widget.dialog {
                        onDismiss = Just <| ToggleDialog False
                        ,content =
                            [ Element.el Heading.h3 <| Element.text "Dialog"
                            , "This is a dialog window"
                            |> Element.text 
                            |> List.singleton
                            |> Element.paragraph []
                            , Input.button (Button.simple ++ [Element.alignRight])
                                {onPress = Just <| ToggleDialog False
                                , label = Element.text "Ok"
                                }
                            ]
                            |>Element.column (Grid.simple ++ Card.large)
             } else Element.none
            ]
        


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ComponentSpecific m ->
            model.component
                |> Component.update m
                |> Tuple.mapBoth
                    (\component ->
                        { model
                            | component = component
                        }
                    )
                    (Cmd.map ComponentSpecific)

        ReusableSpecific m ->
            (model.reusable
                |> Reusable.update m
                |> (\reusable ->
                        { model
                            | reusable = reusable
                        }
                    ),Cmd.none)
        
        StatelessSpecific m ->
            model.stateless
                |> Stateless.update m
                |> Tuple.mapBoth
                    (\stateless ->
                        { model
                            | stateless = stateless
                        }
                    )
                    (Cmd.map StatelessSpecific)
        

        ScrollingNavSpecific m ->
            model.scrollingNav
                |> ScrollingNav.update m
                |> Tuple.mapBoth
                    (\scrollingNav ->
                        { model
                            | scrollingNav = scrollingNav
                        }
                    )
                    (Cmd.map ScrollingNavSpecific)
    
        TimePassed int ->
            ({ model
            | snackbar = model.snackbar |> Snackbar.timePassed int
            },Cmd.none)
        
        AddSnackbar string ->
            ( { model | snackbar = model.snackbar |> Snackbar.insert string}
            , Cmd.none
            )
        
        ToggleDialog bool ->
            ( { model | displayDialog = bool }
            , Cmd.none 
            )

subscriptions : Model -> Sub Msg
subscriptions model=
    Sub.batch
    [ScrollingNav.subscriptions
        |> Sub.map ScrollingNavSpecific
    , Time.every 50 (always ( TimePassed 50))
    ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
