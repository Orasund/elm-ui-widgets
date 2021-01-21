module Widget.Style.Customize exposing
    ( element, mapElement
    , elementButton, mapElementButton
    , elementColumn, mapElementColumn
    , elementRow, mapElementRow
    , elementTable, mapElementTable
    , content, mapContent
    , contentText, mapContentText
    , contentInFront, mapContentInFront
    )

{-| Each and every widget can be customized by modifing the Style Type.

    {- Make a button fill the full width -}
    Widget.textButton
      ( Material.containedButton
        |> (\record ->
             { record
             | element = record.element ++ [Element.width Element.fill]
             }
           )
      )
      { onPress = Just PressedButton
      , text = "Press Button"
      }

This module will contain helpfull functions to make customization easier.

    {- Make a button fill the full width -}
    Widget.textButton
      ( Material.containedButton
        |> Customize.element [Element.width Element.fill]
      )
      { onPress = Just PressedButton
      , text = "Press Button"
      }


# Element

@docs element, mapElement

@docs elementButton, mapElementButton

@docs elementColumn, mapElementColumn

@docs elementRow, mapElementRow

@docs elementTable, mapElementTable

@docs elementTextInput, mapElementTextInput


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
-- Element
--------------------------------------------------------------------------------


element : List b -> { a | element : List b } -> { a | element : List b }
element list a =
    a
        |> mapElement (\b -> b ++ list)


mapElement : (b -> b) -> { a | element : b } -> { a | element : b }
mapElement fun a =
    { a
        | element = fun a.element
    }


elementButton : List b -> { a | elementButton : List b } -> { a | elementButton : List b }
elementButton list a =
    a
        |> mapElementButton (\b -> b ++ list)


mapElementButton : (b -> b) -> { a | elementButton : b } -> { a | elementButton : b }
mapElementButton fun a =
    { a
        | elementButton = fun a.elementButton
    }


elementColumn : List b -> { a | elementColumn : List b } -> { a | elementColumn : List b }
elementColumn list a =
    a
        |> mapElementColumn (\b -> b ++ list)


mapElementColumn : (b -> b) -> { a | elementColumn : b } -> { a | elementColumn : b }
mapElementColumn fun a =
    { a
        | elementColumn = fun a.elementColumn
    }


elementRow : List b -> { a | elementRow : List b } -> { a | elementRow : List b }
elementRow list a =
    a
        |> mapElementRow (\b -> b ++ list)


mapElementRow : (b -> b) -> { a | elementRow : b } -> { a | elementRow : b }
mapElementRow fun a =
    { a
        | elementRow = fun a.elementRow
    }


elementTable : List b -> { a | elementTable : List b } -> { a | elementTable : List b }
elementTable list a =
    a
        |> mapElementTable (\b -> b ++ list)


mapElementTable : (b -> b) -> { a | elementTable : b } -> { a | elementTable : b }
mapElementTable fun a =
    { a
        | elementTable = fun a.elementTable
    }


elementTextInput : List b -> { a | elementTextInput : List b } -> { a | elementTextInput : List b }
elementTextInput list a =
    a
        |> mapElementTextInput (\b -> b ++ list)


mapElementTextInput : (b -> b) -> { a | elementTextInput : b } -> { a | elementTextInput : b }
mapElementTextInput fun a =
    { a
        | elementTextInput = fun a.elementTextInput
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
