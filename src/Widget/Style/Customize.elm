module Widget.Style.Customize exposing
    ( container, mapContainer
    , containerButton, mapContainerButton
    , containerColumn, mapContainerColumn
    , containerRow, mapContainerRow
    , containerTable, mapContainerTable
    , content, mapContent
    , contentText, mapContentText
    , contentInFront, mapContentInFront
    )

{-| Each and every widget can be customized by modifing the Style Type.

```
{- Make a button fill the full width -}
Widget.textButton
  ( Material.containedButton
    |> (\record ->
         { record
         | container = record.container ++ [Element.width Element.fill]
         }
       )
  )
  { onPress = Just PressedButton
  , text = "Press Button"
  }
```

This module will contain helpfull functions to make customization easier.

```
{- Make a button fill the full width -}
Widget.textButton
  ( Material.containedButton
    |> Customize.container [Element.width Element.fill]
  )
  { onPress = Just PressedButton
  , text = "Press Button"
  }
```


# Container

@docs container, mapContainer

@docs containerButton, mapContainerButton

@docs containerColumn, mapContainerColumn

@docs containerRow, mapContainerRow

@docs containerTable, mapContainerTable

@docs containerTextInput, mapContainerTextInput


# Content

@docs content, mapContent

@docs contentText, mapContentText

@docs contentInFront, mapContentInFront


# Conditional Styling

@docs otherwise, mapOtherwise

@docs ifActive, mapIfActive

@docs ifDisabled, mapIfDisabled

@docs ifFirst, mapIfFirst

@docs ifLast, mapIfLast

-}

--------------------------------------------------------------------------------
-- Container
--------------------------------------------------------------------------------


container : List b -> { a | container : List b } -> { a | container : List b }
container list a =
    a
        |> mapContainer (\b -> b ++ list)


mapContainer : (b -> b) -> { a | container : b } -> { a | container : b }
mapContainer fun a =
    { a
        | container = fun a.container
    }


containerButton : List b -> { a | containerButton : List b } -> { a | containerButton : List b }
containerButton list a =
    a
        |> mapContainerButton (\b -> b ++ list)


mapContainerButton : (b -> b) -> { a | containerButton : b } -> { a | containerButton : b }
mapContainerButton fun a =
    { a
        | containerButton = fun a.containerButton
    }


containerColumn : List b -> { a | containerColumn : List b } -> { a | containerColumn : List b }
containerColumn list a =
    a
        |> mapContainerColumn (\b -> b ++ list)


mapContainerColumn : (b -> b) -> { a | containerColumn : b } -> { a | containerColumn : b }
mapContainerColumn fun a =
    { a
        | containerColumn = fun a.containerColumn
    }


containerRow : List b -> { a | containerRow : List b } -> { a | containerRow : List b }
containerRow list a =
    a
        |> mapContainerRow (\b -> b ++ list)


mapContainerRow : (b -> b) -> { a | containerRow : b } -> { a | containerRow : b }
mapContainerRow fun a =
    { a
        | containerRow = fun a.containerRow
    }


containerTable : List b -> { a | containerTable : List b } -> { a | containerTable : List b }
containerTable list a =
    a
        |> mapContainerTable (\b -> b ++ list)


mapContainerTable : (b -> b) -> { a | containerTable : b } -> { a | containerTable : b }
mapContainerTable fun a =
    { a
        | containerTable = fun a.containerTable
    }


containerTextInput : List b -> { a | containerTextInput : List b } -> { a | containerTextInput : List b }
containerTextInput list a =
    a
        |> mapContainerTextInput (\b -> b ++ list)


mapContainerTextInput : (b -> b) -> { a | containerTextInput : b } -> { a | containerTextInput : b }
mapContainerTextInput fun a =
    { a
        | containerTextInput = fun a.containerTextInput
    }



--------------------------------------------------------------------------------
-- Content
--------------------------------------------------------------------------------


content : List b -> { a | content : List b } -> { a | content : List b }
content list a =
    a
        |> mapContent (\b -> b ++ list)


mapContent : (b -> b) -> { a | content : b } -> { a | content : b }
mapContent fun a =
    { a
        | content = fun a.content
    }


contentText : List b -> { a | contentText : List b } -> { a | contentText : List b }
contentText list a =
    a
        |> mapContentText (\b -> b ++ list)


mapContentText : (b -> b) -> { a | contentText : b } -> { a | contentText : b }
mapContentText fun a =
    { a
        | contentText = fun a.contentText
    }


contentInFront : List b -> { a | contentInFront : List b } -> { a | contentInFront : List b }
contentInFront list a =
    a
        |> mapContentInFront (\b -> b ++ list)


mapContentInFront : (b -> b) -> { a | contentInFront : b } -> { a | contentInFront : b }
mapContentInFront fun a =
    { a
        | contentInFront = fun a.contentInFront
    }



--------------------------------------------------------------------------------
-- Conditional Styling
--------------------------------------------------------------------------------


otherwise : List b -> { a | otherwise : List b } -> { a | otherwise : List b }
otherwise list a =
    a
        |> mapOtherwise (\b -> b ++ list)


mapOtherwise : (b -> b) -> { a | otherwise : b } -> { a | otherwise : b }
mapOtherwise fun a =
    { a
        | otherwise = fun a.otherwise
    }


ifActive : List b -> { a | ifActive : List b } -> { a | ifActive : List b }
ifActive list a =
    a
        |> mapIfActive (\b -> b ++ list)


mapIfActive : (b -> b) -> { a | ifActive : b } -> { a | ifActive : b }
mapIfActive fun a =
    { a
        | ifActive = fun a.ifActive
    }


ifDisabled : List b -> { a | ifDisabled : List b } -> { a | ifDisabled : List b }
ifDisabled list a =
    a
        |> mapIfDisabled (\b -> b ++ list)


mapIfDisabled : (b -> b) -> { a | ifDisabled : b } -> { a | ifDisabled : b }
mapIfDisabled fun a =
    { a
        | ifDisabled = fun a.ifDisabled
    }


ifFirst : List b -> { a | ifFirst : List b } -> { a | ifFirst : List b }
ifFirst list a =
    a
        |> mapIfFirst (\b -> b ++ list)


mapIfFirst : (b -> b) -> { a | ifFirst : b } -> { a | ifFirst : b }
mapIfFirst fun a =
    { a
        | ifFirst = fun a.ifFirst
    }


ifLast : List b -> { a | ifLast : List b } -> { a | ifLast : List b }
ifLast list a =
    a
        |> mapIfLast (\b -> b ++ list)


mapIfLast : (b -> b) -> { a | ifLast : b } -> { a | ifLast : b }
mapIfLast fun a =
    { a
        | ifLast = fun a.ifLast
    }
