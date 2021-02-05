module Example.Layout exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element,Attribute,DeviceClass(..))
import FeatherIcons
import Widget exposing (TextInputStyle ,TextInput
    ,Dialog,DialogStyle,ColumnStyle
    ,ButtonStyle,Modal,AppBarStyle,ItemStyle,HeaderStyle,InsetItemStyle)
import Widget.Icon as Icon exposing (Icon)
import Widget.Material as Material
import Widget.Material.Typography as Typography
import Widget.Layout as Layout
import Widget.Snackbar as Snackbar exposing (Snackbar,Message,SnackbarStyle)
import Browser.Events as Events
import Widget.Material.Color as MaterialColor
import Element.Font as Font
import Element.Border as Border
import Material.Icons.Types exposing (Coloring(..))
import Material.Icons
import Widget.Customize as Customize
import Time

type Part
    = LeftSheet
    | RightSheet
    | Search

type alias Style style msg =
    { style
    | container : List (Attribute msg)
    , snackbar : SnackbarStyle msg
    , sideSheet : ColumnStyle msg
    , sheetButton : ItemStyle (ButtonStyle msg) msg
    , searchFill : TextInputStyle msg
    , insetItem : ItemStyle (InsetItemStyle msg) msg
    , menuBar :
        AppBarStyle
            { menuIcon : Icon msg
            , title : List (Attribute msg)
            }
            msg
    , tabBar :
        AppBarStyle
            { menuTabButton : ButtonStyle msg
            , title : List (Attribute msg)
            }
            msg
    , dialog : DialogStyle msg
    , containedButton : ButtonStyle msg
    , column : ColumnStyle msg
    }

materialStyle : Style {} msg
materialStyle =
  { container =
        (Material.defaultPalette.background |> MaterialColor.textAndBackground)
            ++ [ Font.family
                    [ Font.typeface "Roboto"
                    , Font.sansSerif
                    ]
               , Font.size 16
               , Font.letterSpacing 0.5
               ]
    , menuBar = Material.menuBar Material.defaultPalette
    , tabBar = Material.tabBar Material.defaultPalette
    , snackbar = Material.snackbar Material.defaultPalette
    , sheetButton = Material.selectItem Material.defaultPalette
    , sideSheet = Material.sideSheet Material.defaultPalette
    , searchFill =
        { elementRow =
            (Material.defaultPalette.surface
                |> MaterialColor.textAndBackground) ++
                [ Element.height <| Element.px 56 ]
        , content =
            { chips =
                { elementRow = [ Element.spacing 8 ]
                , content = Material.chip Material.defaultPalette
                }
            , text =
                { elementTextInput =
                    (Material.defaultPalette.surface
                        |> MaterialColor.textAndBackground
                    )
                        ++ [ Border.width 0
                        , Element.mouseOver []
                        , Element.focused []
                        ]
                }
            }
        }
    , insetItem = Material.insetItem Material.defaultPalette
    , dialog = Material.alertDialog Material.defaultPalette
    , containedButton = Material.containedButton Material.defaultPalette
    , column = Material.column
    }

type alias Model
    = { window : { height : Int, width : Int }
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
            ( { model | active = maybePart}
            , Cmd.none
            )
        Resized window ->
            ( { model | window = window }
            , Cmd.none
            )
        SetSelected int  ->
            ( { model | selected = int}
            , Cmd.none
            )
        AddSnackbar ->
            ( {model | snackbar = model.snackbar |> Snackbar.insert "This is a message"}
            , Cmd.none
            )
        ShowDialog bool ->
            ( { model | showDialog = bool}
            , Cmd.none
            )
        SetSearchText maybeString ->
            ( { model | searchText = maybeString}
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
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style {snackbar,searchText,selected, window, showDialog, active } =
  let
        deviceClass : DeviceClass
        deviceClass =
            Phone --Replace this line to make the layout responsive
            --Layout.getDeviceClass window
        
        dialog : Maybe (Modal msg)
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
                                msgMapper <|
                                    ShowDialog False
                        }
                }
                    |> Widget.dialog style.dialog
                    |> Just
            else
                Nothing

        onChangedSidebar =
          ChangedSidebar
        
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
            , onSelect = SetSelected >> msgMapper >> Just
            }

        actions =
            { icon =
                    Material.Icons.change_history
                        |> Icon.elmMaterialIcons Color
                , text = "Action"
                , onPress = Nothing
                }
            |> List.repeat 5

        { primaryActions, moreActions } =
            Layout.partitionActions actions
        
        title =
          "Title"
          |> Element.text
          |> Element.el (Typography.h6 ++ [ Element.paddingXY 8 0 ])
        
        search : TextInput msg
        search =
            { chips = []
            , text = searchText
            , placeholder = Nothing
            , label = "Search"
            , onChange = SetSearchText >> msgMapper
            }

        nav : Element msg
        nav =
            if
                (deviceClass == Phone)
                    || (deviceClass == Tablet)
                    || (menu.options |> List.length) > 5
            then
                Widget.menuBar style.menuBar
                    { title = title
                    , deviceClass = deviceClass
                    , openLeftSheet = Just <| msgMapper <| ChangedSidebar <| Just LeftSheet
                    , openRightSheet = Just <| msgMapper <| ChangedSidebar <| Just RightSheet
                    , openTopSheet = Just <| msgMapper <| ChangedSidebar <| Just Search
                    , primaryActions = primaryActions
                    , search = Just search
                    }

            else
                Widget.tabBar style.tabBar
                    { title = title
                    , menu = menu
                    , deviceClass = deviceClass
                    , openRightSheet = Just <|msgMapper <| ChangedSidebar <| Just RightSheet
                    , openTopSheet = Nothing
                    , primaryActions = primaryActions
                    , search =  Just search
                    }

        snackbarElem : Element msg
        snackbarElem =
            snackbar
                |> Snackbar.view style.snackbar 
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
                |> msgMapper

        modals =
            Layout.orderModals
                { dialog = dialog
                , leftSheet =
                    if active == Just LeftSheet then
                        Layout.leftSheet
                            { button = style.sheetButton
                            , sheet = style.sideSheet
                            }
                            { title = title
                            , menu = menu
                            , onDismiss = onDismiss
                            }
                            |> Just

                    else
                        Nothing
                , rightSheet =
                    if active == Just RightSheet then
                        Layout.rightSheet
                            { sheet = style.sideSheet
                            , insetItem = style.insetItem
                            }
                            { onDismiss = onDismiss
                            , moreActions =moreActions
                            }
                            |> Just

                    else
                        Nothing
                , topSheet =
                    if active == Just Search then
                        Layout.searchSheet style.searchFill
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
    , Widget.button style.containedButton
        { onPress =
            Just <|
                msgMapper <|
                    AddSnackbar
        , text = "Add Notification"
        , icon = always Element.none
        }
    ]
    |> Element.column [Element.width <| Element.fill, Element.spacing 8]
    |> Element.el 
            (List.concat
                [ style.container
                , [ Element.inFront snackbarElem ]
                , modals
                    |> Widget.singleModal
                , [ Element.height <| Element.minimum 200 <| Element.fill
                , Element.width <| Element.minimum 400 <| Element.fill
                ]
                ]
            )

main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
