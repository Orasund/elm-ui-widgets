module Widget.Layout exposing
    ( LayoutStyle, Layout, Part, init, timePassed
    , activate, queueMessage
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

## Sheets

@docs leftSheet, rightSheet, searchSheet


## Utility Functions

@docs getDeviceClass, partitionActions, orderModals

-}

import Array
import Element exposing (Attribute, DeviceClass(..), Element)
import Element.Input as Input
import Html exposing (Html)
import Internal.AppBar as AppBar exposing (AppBarStyle)
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
    , sheet : SideSheetStyle msg
    , sheetButton : ItemStyle (ButtonStyle msg) msg
    , spacing : Int
    , title : List (Attribute msg)
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


{-| Left sheet containing a title and a menu.
-}
leftSheet :
    { button : ItemStyle (ButtonStyle msg) msg
    , sheet : SideSheetStyle msg
    }
    ->
        { title : Element msg
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
                AppBar.menuBar style.menuBar
                    { title = title
                    , deviceClass = deviceClass
                    , openLeftSheet = Just <|onChangedSidebar <| Just LeftSheet
                    , openRightSheet = 
                        if moreActions |> List.isEmpty then
                            Nothing
                        else
                            Just <| onChangedSidebar <| Just RightSheet
                    , openTopSheet = Just <|onChangedSidebar <| Just Search
                    , primaryActions = primaryActions
                    , search = search
                    }

            else
                AppBar.tabBar style.tabBar
                    { title = title
                    , menu = menu
                    , deviceClass = deviceClass
                    , openRightSheet = 
                        if moreActions |> List.isEmpty then
                            Nothing
                        else
                            Just <| onChangedSidebar <| Just RightSheet
                    , openTopSheet = Just <| onChangedSidebar <| Just Search
                    , primaryActions = primaryActions
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
                            { title = title
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
