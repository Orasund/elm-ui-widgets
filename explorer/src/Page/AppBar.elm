module Page.AppBar exposing (page)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}

import Browser.Events as Events
import Element exposing (DeviceClass(..), Element)
import Element.Border as Border
import Element.Font as Font
import Material.Icons as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Page
import Time
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Tile, TileMsg)
import Widget exposing (Modal, TextInput)
import Widget.Icon as Icon
import Widget.Layout as Layout
import Widget.Material as Material
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography
import Widget.Snackbar as Snackbar exposing (Snackbar)


{-| The title of this page
-}
title : String
title =
    "App Bar"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "The top app bar displays information and actions relating to the current screen."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewMenuBar titleString deviceClass openLeftSheet openRightSheet openTopSheet primaryActions search { palette } () =
            Widget.menuBar (Material.menuBar palette)
                { title = titleString |> Element.text |> Element.el []
                , deviceClass = deviceClass
                , openLeftSheet = openLeftSheet
                , openRightSheet = openRightSheet
                , openTopSheet = openTopSheet
                , primaryActions =
                    { icon =
                        MaterialIcons.change_history
                            |> Icon.elmMaterialIcons Color
                    , text = "Action"
                    , onPress = Just ()
                    }
                        |> List.repeat primaryActions
                , search = search
                }
                |> Element.el [ Element.width <| Element.px 400, Element.scrollbarX ]
                --Don't forget to change the title
                |> Page.viewTile "Widget.button"

        viewTabBar titleString deviceClass _ openRightSheet openTopSheet primaryActions search { palette } () =
            Widget.tabBar (Material.tabBar palette)
                { title = titleString |> Element.text |> Element.el []
                , menu =
                    { selected = Just 0
                    , options =
                        [ "Home", "About" ]
                            |> List.map
                                (\string ->
                                    { text = string
                                    , icon = always Element.none
                                    }
                                )
                    , onSelect = always (Just ())
                    }
                , deviceClass = deviceClass
                , openRightSheet = openRightSheet
                , openTopSheet = openTopSheet
                , primaryActions =
                    { icon =
                        MaterialIcons.change_history
                            |> Icon.elmMaterialIcons Color
                    , text = "Action"
                    , onPress = Just ()
                    }
                        |> List.repeat primaryActions
                , search = search
                }
                |> Element.el [ Element.width <| Element.px 400, Element.scrollbarX ]
                --Don't forget to change the title
                |> Page.viewTile "Widget.button"
    in
    [ viewMenuBar, viewTabBar ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


{-| Let's you play around with the options.
Note that the order of these stories must follow the order of the arguments from the view functions.
-}
book : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
book =
    Story.book (Just "Options")
        viewFunctions
        --Changing the text of the label
        |> Story.addStory
            (Story.textStory "Title"
                "Title"
            )
        --Change the Icon
        |> Story.addStory
            (Story.optionListStory "Device Class"
                ( "Phone", Phone )
                [ ( "Tablet", Tablet )
                , ( "Desktop", Desktop )
                , ( "BigDesktop", BigDesktop )
                ]
            )
        --Should an event be triggered when pressing the button?
        |> Story.addStory
            (Story.boolStory "With openLeftSheet event handler"
                ( Just (), Nothing )
                True
            )
        |> Story.addStory
            (Story.boolStory "With openRightSheet event handler"
                ( Just (), Nothing )
                True
            )
        |> Story.addStory
            (Story.boolStory "With openTopSheet event handler"
                ( Just (), Nothing )
                True
            )
        --Changing the text of the label
        |> Story.addStory
            (Story.rangeStory "Primary Actions"
                { unit = "Buttons", min = 0, max = 5, default = 3 }
            )
        |> Story.addStory
            (Story.boolStory "With search"
                ( Just
                    { chips = []
                    , text = "Placeholder Text"
                    , placeholder = Nothing
                    , label = "Search"
                    , onChange = always ()
                    }
                , Nothing
                )
                True
            )
        |> Story.build



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


container palette =
    (palette.background |> MaterialColor.textAndBackground)
        ++ [ Font.family
                [ Font.typeface "Roboto"
                , Font.sansSerif
                ]
           , Font.size 16
           , Font.letterSpacing 0.5
           ]


searchFill palette =
    { elementRow =
        (palette.surface
            |> MaterialColor.textAndBackground
        )
            ++ [ Element.height <| Element.px 56 ]
    , content =
        { chips =
            { elementRow = [ Element.spacing 8 ]
            , content = Material.chip palette
            }
        , text =
            { elementTextInput =
                (palette.surface
                    |> MaterialColor.textAndBackground
                )
                    ++ [ Border.width 0
                       , Element.mouseOver []
                       , Element.focused []
                       ]
            }
        }
    }


type Part
    = LeftSheet
    | RightSheet
    | Search


type alias Model =
    { window :
        { height : Int
        , width : Int
        }
    , showDialog : Bool
    , snackbar : Snackbar String
    , active : Maybe Part
    , selected : Int
    , searchText : String
    }


type Msg
    = ChangedSidebar (Maybe Part)
    | Resized { width : Int, height : Int }
    | SetSelected Int
    | AddSnackbar
    | ShowDialog Bool
    | SetSearchText String
    | TimePassed Int


init : ( Model, Cmd Msg )
init =
    ( { window = { height = 200, width = 400 }
      , showDialog = False
      , snackbar = Snackbar.init
      , active = Just RightSheet
      , selected = 0
      , searchText = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedSidebar maybePart ->
            ( { model | active = maybePart }
            , Cmd.none
            )

        Resized window ->
            ( { model | window = window }
            , Cmd.none
            )

        SetSelected int ->
            ( { model | selected = int }
            , Cmd.none
            )

        AddSnackbar ->
            ( { model | snackbar = model.snackbar |> Snackbar.insert "This is a message" }
            , Cmd.none
            )

        ShowDialog bool ->
            ( { model | showDialog = bool }
            , Cmd.none
            )

        SetSearchText maybeString ->
            ( { model | searchText = maybeString }
            , Cmd.none
            )

        TimePassed sec ->
            ( case model.active of
                Just LeftSheet ->
                    model

                Just RightSheet ->
                    model

                _ ->
                    { model
                        | snackbar = model.snackbar |> Snackbar.timePassed sec
                    }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Events.onResize (\h w -> Resized { height = h, width = w })
        , Time.every 50 (always (TimePassed 50))
        ]


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } { snackbar, searchText, selected, showDialog, active } =
    let
        deviceClass : DeviceClass
        deviceClass =
            Phone

        --Replace this line to make the layout responsive
        --Layout.getDeviceClass window
        dialog : Maybe (Modal Msg)
        dialog =
            if showDialog then
                { text = "This is a dialog window"
                , title = Just "Dialog"
                , accept = Nothing
                , dismiss =
                    Just
                        { text = "Accept"
                        , onPress =
                            Just <|
                                ShowDialog False
                        }
                }
                    |> Widget.dialog (Material.alertDialog palette)
                    |> Just

            else
                Nothing

        menu =
            { selected = Just selected
            , options =
                [ "Home", "About" ]
                    |> List.map
                        (\string ->
                            { text = string
                            , icon = always Element.none
                            }
                        )
            , onSelect = SetSelected >> Just
            }

        actions =
            { icon =
                MaterialIcons.change_history
                    |> Icon.elmMaterialIcons Color
            , text = "Action"
            , onPress = Nothing
            }
                |> List.repeat 5

        { primaryActions, moreActions } =
            Layout.partitionActions actions

        titleEl =
            "Title"
                |> Element.text
                |> Element.el (Typography.h6 ++ [ Element.paddingXY 8 0 ])

        search : TextInput Msg
        search =
            { chips = []
            , text = searchText
            , placeholder = Nothing
            , label = "Search"
            , onChange = SetSearchText
            }

        nav : Element Msg
        nav =
            if
                (deviceClass == Phone)
                    || (deviceClass == Tablet)
                    || (menu.options |> List.length)
                    > 5
            then
                Widget.menuBar (Material.menuBar palette)
                    { title = titleEl
                    , deviceClass = deviceClass
                    , openLeftSheet = Just <| ChangedSidebar <| Just LeftSheet
                    , openRightSheet = Just <| ChangedSidebar <| Just RightSheet
                    , openTopSheet = Just <| ChangedSidebar <| Just Search
                    , primaryActions = primaryActions
                    , search = Just search
                    }

            else
                Widget.tabBar (Material.tabBar palette)
                    { title = titleEl
                    , menu = menu
                    , deviceClass = deviceClass
                    , openRightSheet = Just <| ChangedSidebar <| Just RightSheet
                    , openTopSheet = Nothing
                    , primaryActions = primaryActions
                    , search = Just search
                    }

        snackbarElem : Element Msg
        snackbarElem =
            snackbar
                |> Snackbar.view (Material.snackbar palette)
                    (\text ->
                        { text = text
                        , button = Nothing
                        }
                    )
                |> Maybe.map
                    (Element.el
                        [ Element.padding 8
                        , Element.alignBottom
                        , Element.alignRight
                        ]
                    )
                |> Maybe.withDefault Element.none

        onDismiss =
            Nothing
                |> ChangedSidebar

        modals =
            Layout.orderModals
                { dialog = dialog
                , leftSheet =
                    if active == Just LeftSheet then
                        Layout.leftSheet
                            { button = Material.selectItem palette
                            , sheet = Material.sideSheet palette
                            }
                            { title = titleEl
                            , menu = menu
                            , onDismiss = onDismiss
                            }
                            |> Just

                    else
                        Nothing
                , rightSheet =
                    if active == Just RightSheet then
                        Layout.rightSheet
                            { sheet = Material.sideSheet palette
                            , insetItem = Material.insetItem palette
                            }
                            { onDismiss = onDismiss
                            , moreActions = moreActions
                            }
                            |> Just

                    else
                        Nothing
                , topSheet =
                    if active == Just Search then
                        Layout.searchSheet (searchFill palette)
                            { search = search
                            , onDismiss = onDismiss
                            }
                            |> Just

                    else
                        Nothing
                , bottomSheet = Nothing
                }
    in
    [ nav
    , Widget.button (Material.containedButton palette)
        { onPress = Just <| AddSnackbar
        , text = "Add Notification"
        , icon = always Element.none
        }
    ]
        |> Element.column [ Element.width <| Element.fill, Element.spacing 8 ]
        |> Element.el
            (List.concat
                [ container palette
                , [ Element.inFront snackbarElem ]
                , modals
                    |> Widget.singleModal
                , [ Element.height <| Element.minimum 200 <| Element.fill
                  , Element.width <| Element.minimum 400 <| Element.fill
                  ]
                ]
            )



--------------------------------------------------------------------------------
-- DO NOT MODIFY ANYTHING AFTER THIS LINE
--------------------------------------------------------------------------------


demo : Tile Model Msg ()
demo =
    { init = always init
    , update = update
    , view = Page.demo view
    , subscriptions = subscriptions
    }


page =
    Page.create
        { title = title
        , description = description
        , book = book
        , demo = demo
        }
