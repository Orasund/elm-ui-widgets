module Internal.AppBar exposing (AppBarStyle, menuBar, tabBar)

import Element exposing (Attribute, DeviceClass(..), Element)
import Element.Input as Input
import Internal.Button as Button exposing (Button, ButtonStyle)
import Internal.Select as Select exposing (Select)
import Internal.TextInput as TextInput exposing (TextInput, TextInputStyle)
import Widget.Customize as Customize
import Widget.Icon exposing (Icon)


type alias AppBarStyle content msg =
    { elementRow : List (Attribute msg) --header
    , content :
        { menu :
            { elementRow : List (Attribute msg)
            , content : content
            }
        , search : TextInputStyle msg --search
        , actions :
            { elementRow : List (Attribute msg)
            , content :
                { button : ButtonStyle msg --menuButton
                , searchIcon : Icon msg
                , moreVerticalIcon : Icon msg
                }
            }
        }
    }


menuBar :
    AppBarStyle
        { menuIcon : Icon msg
        , title : List (Attribute msg)
        }
        msg
    ->
        { title : Element msg
        , deviceClass : DeviceClass
        , openLeftSheet : Maybe msg
        , openRightSheet : Maybe msg
        , openTopSheet : Maybe msg
        , primaryActions : List (Button msg)
        , search : Maybe (TextInput msg)
        }
    -> Element msg
menuBar style m =
    internalNav
        [ Button.iconButton style.content.actions.content.button
            { onPress = m.openLeftSheet
            , icon = style.content.menu.content.menuIcon
            , text = "Menu"
            }
        , m.title |> Element.el style.content.menu.content.title
        ]
        { elementRow = style.elementRow
        , content =
            { menu =
                { elementRow = style.content.menu.elementRow
                }
            , search = style.content.search
            , actions = style.content.actions
            }
        }
        m


{-| A top bar that displays the menu as tabs
-}
tabBar :
    AppBarStyle
        { menuTabButton : ButtonStyle msg
        , title : List (Attribute msg)
        }
        msg
    ->
        { title : Element msg
        , menu : Select msg
        , deviceClass : DeviceClass
        , openRightSheet : Maybe msg
        , openTopSheet : Maybe msg
        , primaryActions : List (Button msg)
        , search : Maybe (TextInput msg)
        }
    -> Element msg
tabBar style m =
    internalNav
        [ m.title |> Element.el style.content.menu.content.title
        , m.menu
            |> Select.select
            |> List.map (Select.selectButton style.content.menu.content.menuTabButton)
            |> Element.row
                [ Element.width <| Element.shrink
                ]
        ]
        { elementRow = style.elementRow
        , content =
            { menu =
                { elementRow = style.content.menu.elementRow
                }
            , search = style.content.search
            , actions = style.content.actions
            }
        }
        m


{-| -}
internalNav :
    List (Element msg)
    ->
        { elementRow : List (Attribute msg) --header
        , content :
            { menu :
                { elementRow : List (Attribute msg)
                }
            , search : TextInputStyle msg --search
            , actions :
                { elementRow : List (Attribute msg)
                , content :
                    { button : ButtonStyle msg --menuButton
                    , searchIcon : Icon msg
                    , moreVerticalIcon : Icon msg
                    }
                }
            }
        }
    ->
        { model
            | deviceClass : DeviceClass
            , openRightSheet : Maybe msg
            , openTopSheet : Maybe msg
            , primaryActions : List (Button msg)
            , search : Maybe (TextInput msg)
        }
    -> Element msg
internalNav menuElements style { deviceClass, openRightSheet, openTopSheet, primaryActions, search } =
    [ menuElements
        |> Element.row style.content.menu.elementRow
    , if deviceClass == Phone || deviceClass == Tablet then
        Element.none

      else
        search
            |> Maybe.map
                (\{ onChange, text, label } ->
                    TextInput.textInput style.content.search
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
                        [ Button.button
                            (style.content.actions.content.button
                                --FIX FOR ISSUE #30
                                |> Customize.elementButton [ Element.width Element.shrink ]
                            )
                            { onPress = openTopSheet
                            , icon = style.content.actions.content.searchIcon
                            , text = label
                            }
                        ]

                    else if deviceClass == Phone then
                        [ Button.iconButton style.content.actions.content.button
                            { onPress = openTopSheet
                            , icon = style.content.actions.content.searchIcon
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
                    Button.iconButton style.content.actions.content.button

                 else
                    Button.button
                        (style.content.actions.content.button
                            --FIX FOR ISSUE #30
                            |> Customize.elementButton [ Element.width Element.shrink ]
                        )
                )
      , case openRightSheet of
            Nothing ->
                []

            Just _ ->
                [ Button.iconButton style.content.actions.content.button
                    { onPress = openRightSheet
                    , icon = style.content.actions.content.moreVerticalIcon
                    , text = "More"
                    }
                ]
      ]
        |> List.concat
        |> Element.row style.content.actions.elementRow
    ]
        |> Element.row
            (style.elementRow
                ++ [ Element.alignTop
                   , Element.width <| Element.fill
                   ]
            )
