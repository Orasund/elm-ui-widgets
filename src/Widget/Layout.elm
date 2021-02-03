module Widget.Layout exposing
    ( LayoutStyle, Layout, Part(..), init, timePassed
    , activate, queueMessage
    , menuBar, tabBar
    , leftSheet, rightSheet, searchSheet
    , getDeviceClass, partitionActions, orderModals
    , view
    )

{-| Combines multiple concepts from the [material design specification](https://material.io/components/), namely:

  - Top App Bar
  - Navigation Draw
  - Side Panel
  - Dialog
  - Snackbar

It is responsive and changes view to apply to the [material design guidelines](https://material.io/components/app-bars-top).


# Basics

@docs LayoutStyle, Layout, Part, init, timePassed


# Actions

@docs activate, queueMessage


# Views

@docs menuBar, tabBar


## Sheets

@docs leftSheet, rightSheet, searchSheet


## Utility Functions

@docs getDeviceClass, partitionActions, orderModals

-}

import Array
import Element exposing (Attribute, DeviceClass(..), Element)
import Element.Input as Input
import Html exposing (Html)
import Internal.Button as Button exposing (Button, ButtonStyle)
import Internal.Dialog as Dialog
import Internal.Item as Item exposing (InsetItemStyle, ItemStyle)
import Internal.Modal as Modal exposing (Modal)
import Internal.Select as Select exposing (Select)
import Internal.Sheet as Sheet exposing (SideSheetStyle)
import Internal.TextInput as TextInput exposing (TextInput, TextInputStyle)
import Widget.Customize as Customize
import Widget.Icon exposing (Icon)
import Widget.Snackbar as Snackbar exposing (Message, SnackbarStyle)


{-| -}
type alias LayoutStyle msg =
    { container : List (Attribute msg)
    , snackbar : SnackbarStyle msg
    , header : List (Attribute msg)
    , sheet : SideSheetStyle msg
    , sheetButton : ItemStyle (ButtonStyle msg) msg
    , menuButton : ButtonStyle msg
    , menuTabButton : ButtonStyle msg
    , menuIcon : Icon msg
    , moreVerticalIcon : Icon msg
    , spacing : Int
    , title : List (Attribute msg)
    , searchIcon : Icon msg
    , search : TextInputStyle msg
    , searchFill : TextInputStyle msg
    , insetItem : ItemStyle (InsetItemStyle msg) msg
    }


{-| The currently visible part: either the left sheet, right sheet or the search bar
-}
type Part
    = LeftSheet
    | RightSheet
    | Search


{-| The model of the layout containing the snackbar and the currently active side sheet (or search bar)
-}
type alias Layout msg =
    { snackbar : Snackbar.Snackbar (Message msg)
    , active : Maybe Part
    }


{-| The initial state of the layout
-}
init : Layout msg
init =
    { snackbar = Snackbar.init
    , active = Nothing
    }


{-| Queues a message and displayes it as a snackbar once no other snackbar is visible.
-}
queueMessage : Message msg -> Layout msg -> Layout msg
queueMessage message layout =
    { layout
        | snackbar = layout.snackbar |> Snackbar.insert message
    }


{-| Open either a side sheet or the search bar.
-}
activate : Maybe Part -> Layout msg -> Layout msg
activate part layout =
    { layout
        | active = part
    }


{-| Update the model, put this function into your subscription.
The first argument is the seconds that have passed sice the function was called last.
-}
timePassed : Int -> Layout msg -> Layout msg
timePassed sec layout =
    case layout.active of
        Just LeftSheet ->
            layout

        Just RightSheet ->
            layout

        _ ->
            { layout
                | snackbar = layout.snackbar |> Snackbar.timePassed sec
            }



--------------------------------------------------------------------------------
-- View
--------------------------------------------------------------------------------


{-| obtain the Device Calss from a given window.

Checkout Element.classifyDevice for more information.

-}
getDeviceClass : { height : Int, width : Int } -> DeviceClass
getDeviceClass window =
    window
        |> Element.classifyDevice
        |> .class


{-| partitions actions into primary and additional actions.

It is intended to hide the additional actions in a side menu.

-}
partitionActions : List (Button msg) -> { primaryActions : List (Button msg), moreActions : List (Button msg) }
partitionActions actions =
    { primaryActions =
        if (actions |> List.length) > 4 then
            actions |> List.take 2

        else if (actions |> List.length) == 4 then
            actions |> List.take 1

        else if (actions |> List.length) == 3 then
            []

        else
            actions |> List.take 2
    , moreActions =
        if (actions |> List.length) > 4 then
            actions |> List.drop 2

        else if (actions |> List.length) == 4 then
            actions |> List.drop 1

        else if (actions |> List.length) == 3 then
            actions

        else
            actions |> List.drop 2
    }


{-| A top bar that displays a menu icon on the left side.
-}
menuBar :
    { style
        | menuIcon : Icon msg
        , title : List (Attribute msg)
        , header : List (Attribute msg)
        , menuButton : ButtonStyle msg
        , moreVerticalIcon : Icon msg
        , spacing : Int
        , searchIcon : Icon msg
        , search : TextInputStyle msg
    }
    ->
        { title : Element msg
        , deviceClass : DeviceClass
        , openLeftSheet : msg
        , openRightSheet : msg
        , openTopSheet : msg
        , primaryActions : List (Button msg)
        , moreActions : List (Button msg)
        , search : Maybe (TextInput msg)
        }
    -> Element msg
menuBar style m =
    internalNav
        [ Button.iconButton style.menuButton
            { onPress = Just <| m.openLeftSheet
            , icon = style.menuIcon
            , text = "Menu"
            }
        , m.title |> Element.el style.title
        ]
        style
        m


{-| A top bar that displays the menu as tabs
-}
tabBar :
    { style
        | menuTabButton : ButtonStyle msg
        , title : List (Attribute msg)
        , header : List (Attribute msg)
        , menuButton : ButtonStyle msg
        , moreVerticalIcon : Icon msg
        , spacing : Int
        , searchIcon : Icon msg
        , search : TextInputStyle msg
    }
    ->
        { title : Element msg
        , menu : Select msg
        , deviceClass : DeviceClass
        , openRightSheet : msg
        , openTopSheet : msg
        , primaryActions : List (Button msg)
        , moreActions : List (Button msg)
        , search : Maybe (TextInput msg)
        }
    -> Element msg
tabBar style m =
    internalNav
        [ m.title |> Element.el style.title
        , m.menu
            |> Select.select
            |> List.map (Select.selectButton style.menuTabButton)
            |> Element.row
                [ Element.width <| Element.shrink
                ]
        ]
        style
        m


{-| -}
internalNav :
    List (Element msg)
    ->
        { style
            | header : List (Attribute msg)
            , menuButton : ButtonStyle msg
            , moreVerticalIcon : Icon msg
            , spacing : Int
            , searchIcon : Icon msg
            , search : TextInputStyle msg
        }
    ->
        { model
            | deviceClass : DeviceClass
            , openRightSheet : msg
            , openTopSheet : msg
            , primaryActions : List (Button msg)
            , moreActions : List (Button msg)
            , search : Maybe (TextInput msg)
        }
    -> Element msg
internalNav menuElements style { deviceClass, openRightSheet, openTopSheet, primaryActions, moreActions, search } =
    [ menuElements
        |> Element.row
            [ Element.width <| Element.shrink
            , Element.spacing style.spacing
            ]
    , if deviceClass == Phone || deviceClass == Tablet then
        Element.none

      else
        search
            |> Maybe.map
                (\{ onChange, text, label } ->
                    TextInput.textInput style.search
                        { chips = []
                        , onChange = onChange
                        , text = text
                        , placeholder =
                            Just <|
                                Input.placeholder [] <|
                                    Element.text label
                        , label = label
                        }
                )
            |> Maybe.withDefault Element.none
    , [ search
            |> Maybe.map
                (\{ label } ->
                    if deviceClass == Tablet then
                        [ Button.button style.menuButton
                            { onPress = Just <| openTopSheet
                            , icon = style.searchIcon
                            , text = label
                            }
                        ]

                    else if deviceClass == Phone then
                        [ Button.iconButton style.menuButton
                            { onPress = Just <| openTopSheet
                            , icon = style.searchIcon
                            , text = label
                            }
                        ]

                    else
                        []
                )
            |> Maybe.withDefault []
      , primaryActions
            |> List.map
                (if deviceClass == Phone then
                    Button.iconButton style.menuButton

                 else
                    Button.button
                        (style.menuButton
                            --FIX FOR ISSUE #30
                            |> Customize.elementButton [ Element.width Element.shrink ]
                        )
                )
      , if moreActions |> List.isEmpty then
            []

        else
            [ Button.iconButton style.menuButton
                { onPress = Just <| openRightSheet
                , icon = style.moreVerticalIcon
                , text = "More"
                }
            ]
      ]
        |> List.concat
        |> Element.row
            [ Element.alignRight
            , Element.width Element.shrink
            ]
    ]
        |> Element.row
            (style.header
                ++ [ Element.padding 0
                   , Element.centerX
                   , Element.spacing style.spacing
                   , Element.alignTop
                   , Element.width <| Element.fill
                   ]
            )


{-| Left sheet containing a title and a menu.
-}
leftSheet :
    { button : ItemStyle (ButtonStyle msg) msg
    , sheet : SideSheetStyle msg
    }
    ->
        { window : { height : Int, width : Int }
        , title : Element msg
        , menu : Select msg
        , onDismiss : msg
        }
    -> Modal msg
leftSheet style { title, onDismiss, menu } =
    { onDismiss = Just onDismiss
    , content =
        (title |> Item.asItem)
            :: (menu
                    |> Item.selectItem style.button
               )
            |> Sheet.sideSheet
                (style.sheet
                    |> Customize.element [ Element.alignLeft ]
                    |> Customize.mapContent
                        (Customize.elementColumn [ Element.width <| Element.fill ])
                )
    }


{-| Right sheet containg a simple list of buttons
-}
rightSheet :
    { sheet : SideSheetStyle msg
    , insetItem : ItemStyle (InsetItemStyle msg) msg
    }
    ->
        { onDismiss : msg
        , moreActions : List (Button msg)
        }
    -> Modal msg
rightSheet style { onDismiss, moreActions } =
    { onDismiss = Just onDismiss
    , content =
        moreActions
            |> List.map
                (\{ onPress, text, icon } ->
                    Item.insetItem
                        style.insetItem
                        { text = text
                        , onPress = onPress
                        , icon = icon
                        , content = always Element.none
                        }
                )
            |> Sheet.sideSheet
                (style.sheet
                    |> Customize.element [ Element.alignRight ]
                )
    }


{-| Top sheet containg a searchbar spaning the full witdh
-}
searchSheet :
    TextInputStyle msg
    ->
        { onDismiss : msg
        , search : TextInput msg
        }
    -> Modal msg
searchSheet style { onDismiss, search } =
    { onDismiss = Just onDismiss
    , content =
        search
            |> TextInput.textInput
                (style
                    |> Customize.elementRow
                        [ Element.width <| Element.fill
                        ]
                    |> Customize.mapContent
                        (\record ->
                            { record
                                | text =
                                    record.text
                            }
                        )
                )
            |> Element.el
                [ Element.alignTop
                , Element.width <| Element.fill
                ]
    }


{-| Material design only allows one element at a time to be visible as modal.

The order from most important to least important is as follows:
dialog -> top sheet -> bottom sheet -> left sheet -> right sheet

-}
orderModals :
    { dialog : Maybe (Modal msg)
    , topSheet : Maybe (Modal msg)
    , bottomSheet : Maybe (Modal msg)
    , leftSheet : Maybe (Modal msg)
    , rightSheet : Maybe (Modal msg)
    }
    -> List (Modal msg)
orderModals modals =
    [ modals.dialog
    , modals.leftSheet
    , modals.rightSheet
    , modals.topSheet
    ]
        |> List.filterMap identity


view :
    LayoutStyle msg
    ->
        { window : { height : Int, width : Int }
        , dialog : Maybe (Modal msg)
        , layout : Layout msg
        , title : Element msg
        , menu : Select msg
        , search : Maybe (TextInput msg)
        , actions : List (Button msg)
        , onChangedSidebar : Maybe Part -> msg
        }
    -> List (Attribute msg)
view style { search, title, onChangedSidebar, menu, actions, window, dialog, layout } =
    let
        deviceClass : DeviceClass
        deviceClass =
            getDeviceClass window

        { primaryActions, moreActions } =
            partitionActions actions

        nav : Element msg
        nav =
            if
                (deviceClass == Phone)
                    || (deviceClass == Tablet)
                    || ((menu.options |> List.length) > 5)
            then
                menuBar style
                    { title = title
                    , deviceClass = deviceClass
                    , openLeftSheet = onChangedSidebar <| Just LeftSheet
                    , openRightSheet = onChangedSidebar <| Just RightSheet
                    , openTopSheet = onChangedSidebar <| Just Search
                    , primaryActions = primaryActions
                    , moreActions = moreActions
                    , search = search
                    }

            else
                tabBar style
                    { title = title
                    , menu = menu
                    , deviceClass = deviceClass
                    , openRightSheet = onChangedSidebar <| Just RightSheet
                    , openTopSheet = onChangedSidebar <| Just Search
                    , primaryActions = primaryActions
                    , moreActions = moreActions
                    , search = search
                    }

        snackbar : Element msg
        snackbar =
            layout.snackbar
                |> Snackbar.view style.snackbar identity
                |> Maybe.map
                    (Element.el
                        [ Element.padding style.spacing
                        , Element.alignBottom
                        , Element.alignRight
                        ]
                    )
                |> Maybe.withDefault Element.none

        onDismiss =
            Nothing
                |> onChangedSidebar

        modals =
            orderModals
                { dialog = dialog
                , leftSheet =
                    if layout.active == Just LeftSheet then
                        leftSheet
                            { button = style.sheetButton
                            , sheet = style.sheet
                            }
                            { window = window
                            , title = title
                            , menu = menu
                            , onDismiss = onDismiss
                            }
                            |> Just

                    else
                        Nothing
                , rightSheet =
                    if layout.active == Just RightSheet then
                        rightSheet
                            { sheet = style.sheet
                            , insetItem = style.insetItem
                            }
                            { onDismiss = onDismiss
                            , moreActions = moreActions
                            }
                            |> Just

                    else
                        Nothing
                , topSheet =
                    if layout.active == Just Search then
                        search
                            |> Maybe.map
                                (\textInput ->
                                    searchSheet style.searchFill
                                        { search = textInput
                                        , onDismiss = onDismiss
                                        }
                                )

                    else
                        Nothing
                , bottomSheet = Nothing
                }
    in
    List.concat
        [ style.container
        , [ Element.inFront nav
          , Element.inFront snackbar
          ]
        , modals
            |> Modal.singleModal
        ]
