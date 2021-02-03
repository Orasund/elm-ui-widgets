module Widget.Layout exposing
    ( LayoutStyle, Layout, Part(..), init, timePassed, view
    , activate, queueMessage
    , getDeviceClass, partitionActions, getModals
    )

{-| Combines multiple concepts from the [material design specification](https://material.io/components/), namely:

  - Top App Bar
  - Navigation Draw
  - Side Panel
  - Dialog
  - Snackbar

It is responsive and changes view to apply to the [material design guidelines](https://material.io/components/app-bars-top).


# Basics

@docs LayoutStyle, Layout, Part, init, timePassed, view


# Actions

@docs activate, queueMessage


# Views

@docs getDeviceClass, partitionActions, getModals

-}

import Array
import Element exposing (Attribute, DeviceClass(..), Element)
import Element.Input as Input
import Html exposing (Html)
import Internal.Button as Button exposing (Button, ButtonStyle)
import Internal.Dialog as Dialog
import Internal.Item as Item exposing (ItemStyle, InsetItemStyle)
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
    , layout : List (Attribute msg) -> Element msg -> Html msg
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


viewNav :
    LayoutStyle msg
    ->
        { title : Element msg
        , menu : Select msg
        , deviceClass : DeviceClass
        , onChangedSidebar : Maybe Part -> msg
        , primaryActions : List (Button msg)
        , moreActions : List (Button msg)
        , search : Maybe (TextInput msg)
        }
    -> Element msg
viewNav style { title, menu, deviceClass, onChangedSidebar, primaryActions, moreActions, search } =
    [ (if
        (deviceClass == Phone)
            || (deviceClass == Tablet)
            || ((menu.options |> List.length) > 5)
       then
        [ Button.iconButton style.menuButton
            { onPress = Just <| onChangedSidebar <| Just LeftSheet
            , icon = style.menuIcon
            , text = "Menu"
            }
        , menu.selected
            |> Maybe.andThen
                (\option ->
                    menu.options
                        |> Array.fromList
                        |> Array.get option
                )
            |> Maybe.map (.text >> Element.text)
            |> Maybe.withDefault title
            |> Element.el style.title
        ]

       else
        [ title |> Element.el style.title
        , menu
            |> Select.select
            |> List.map (Select.selectButton style.menuTabButton)
            |> Element.row
                [ Element.width <| Element.shrink
                ]
        ]
      )
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
                            { onPress = Just <| onChangedSidebar <| Just Search
                            , icon = style.searchIcon
                            , text = label
                            }
                        ]

                    else if deviceClass == Phone then
                        [ Button.iconButton style.menuButton
                            { onPress = Just <| onChangedSidebar <| Just Search
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
                { onPress = Just <| onChangedSidebar <| Just RightSheet
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


{-| Material design only allows one element at a time to be visible as modal.

The order from most important to least important is as follows:
dialog -> top sheet -> bottom sheet -> left sheet -> right sheet

-}
getModals :
    { button : ItemStyle (ButtonStyle msg) msg
    , sheet : SideSheetStyle msg
    , searchFill : TextInputStyle msg
    , insetItem : ItemStyle (InsetItemStyle msg) msg
    }
    ->
        { window : { height : Int, width : Int }
        , dialog : Maybe (Modal msg)
        , active : Maybe Part
        , title : Element msg
        , search : Maybe (TextInput msg)
        , menu : Select msg
        , onChangedSidebar : Maybe Part -> msg
        , moreActions : List (Button msg)
        }
    -> List (Modal msg)
getModals style { search, title, onChangedSidebar, menu, moreActions, dialog, active } =
    let
        asModal sheet =
            { onDismiss =
                Nothing
                    |> onChangedSidebar
                    |> Just
            , content = sheet
            }
    in
    [ dialog
    , active
        |> Maybe.andThen
            (\part ->
                case part of
                    LeftSheet ->
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
                            |> asModal
                            |> Just

                    RightSheet ->
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
                            |> asModal
                            |> Just

                    Search ->
                        search
                            |> Maybe.map
                                (TextInput.textInput
                                    (style.searchFill
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
                                    >> Element.el
                                        [ Element.alignTop
                                        , Element.width <| Element.fill
                                        ]
                                    >> asModal
                                )
            )
    ]
        |> List.filterMap identity


{-| View the layout.
-}
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
    -> Element msg
    -> Html msg
view style { search, title, onChangedSidebar, menu, actions, window, dialog, layout } content =
    let
        deviceClass : DeviceClass
        deviceClass =
            getDeviceClass window

        { primaryActions, moreActions } =
            partitionActions actions

        nav : Element msg
        nav =
            viewNav style
                { title = title
                , menu = menu
                , deviceClass = deviceClass
                , onChangedSidebar = onChangedSidebar
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
    in
    content
        |> style.layout
            (List.concat
                [ style.container
                , [ Element.inFront nav
                  , Element.inFront snackbar
                  ]
                , getModals
                    { button = style.sheetButton
                    , sheet = style.sheet
                    , searchFill = style.searchFill
                    , insetItem = style.insetItem
                    }
                    { window = window
                    , dialog = dialog
                    , active = layout.active
                    , title = title
                    , menu = menu
                    , onChangedSidebar = onChangedSidebar
                    , moreActions = moreActions
                    , search = search
                    }
                    |> Modal.singleModal
                ]
            )
