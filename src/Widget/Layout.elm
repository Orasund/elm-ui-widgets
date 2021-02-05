module Widget.Layout exposing
    ( leftSheet, rightSheet, searchSheet
    , getDeviceClass, partitionActions, orderModals
    )

{-| Combines multiple concepts from the [material design specification](https://material.io/components/), namely:

  - Top App Bar
  - Navigation Draw
  - Side Panel
  - Dialog
  - Snackbar

It is responsive and changes view to apply to the [material design guidelines](https://material.io/components/app-bars-top).


# Sheets

@docs leftSheet, rightSheet, searchSheet


# Utility Functions

@docs getDeviceClass, partitionActions, orderModals

-}

import Element exposing (DeviceClass(..), Element)
import Internal.Button exposing (Button, ButtonStyle)
import Internal.Item as Item exposing (InsetItemStyle, ItemStyle)
import Internal.List as List exposing (ColumnStyle)
import Internal.Modal exposing (Modal)
import Internal.Select exposing (Select)
import Internal.TextInput as TextInput exposing (TextInput, TextInputStyle)
import Widget.Customize as Customize


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
    , sheet : ColumnStyle msg
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
            |> List.itemList
                (style.sheet
                    |> Customize.elementColumn [ Element.alignLeft ]
                )
    }


{-| Right sheet containg a simple list of buttons
-}
rightSheet :
    { sheet : ColumnStyle msg
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
            |> List.itemList
                (style.sheet
                    |> Customize.elementColumn [ Element.alignRight ]
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
