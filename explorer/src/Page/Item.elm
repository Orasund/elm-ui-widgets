module Page.Item exposing (page)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}

import Browser
import Element exposing (Element)
import Element.Background as Background
import Material.Icons as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Page
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Tile, TileMsg)
import Widget exposing (ButtonStyle, ColumnStyle, HeaderStyle, InsetItemStyle, ItemStyle)
import Widget.Customize as Customize
import Widget.Icon as Icon
import Widget.Material as Material
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


{-| The title of this page
-}
title : String
title =
    "Item"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "Items can be composed into lists."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewDividerFunctions =
    let
        viewButton listStyle style { palette } () =
            [ Widget.divider (style palette)
            , Widget.fullBleedItem (Material.fullBleedItem palette)
                { text = "Placeholder"
                , onPress = Nothing
                , icon = always Element.none
                }
            , Widget.divider (style palette)
            , Widget.fullBleedItem (Material.fullBleedItem palette)
                { text = "Placeholder"
                , onPress = Nothing
                , icon = always Element.none
                }
            , Widget.divider (style palette)
            ]
                |> Widget.itemList (listStyle palette)
                --Don't forget to change the title
                |> Page.viewTile "Widget.divider"
    in
    [ viewButton ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


{-| Let's you play around with the options.
Note that the order of these stories must follow the order of the arguments from the view functions.
-}
dividerBook : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
dividerBook =
    Story.book (Just "Options")
        viewDividerFunctions
        --Adding a option for different styles.
        |> Story.addStory
            (Story.optionListStory "Column Style"
                ( "CardColumn", Material.cardColumn )
                [ ( "sideSheet", Material.sideSheet )
                , ( "bottomSheet", Material.bottomSheet )
                , ( "Column", always Material.column )
                ]
            )
        |> Story.addStory
            (Story.optionListStory "Style"
                ( "FullBleedDivider", Material.fullBleedDivider )
                [ ( "MiddleDivider", Material.middleDivider )
                , ( "InsetDivider", Material.insetDivider )
                ]
            )
        |> Story.build


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewHeaderFunctions =
    let
        viewButton listStyle style text { palette } () =
            [ text |> Widget.headerItem (style palette)
            , Widget.fullBleedItem (Material.fullBleedItem palette)
                { text = "Placeholder"
                , onPress = Nothing
                , icon = always Element.none
                }
            , text |> Widget.headerItem (style palette)
            , Widget.fullBleedItem (Material.fullBleedItem palette)
                { text = "Placeholder"
                , onPress = Nothing
                , icon = always Element.none
                }
            , text |> Widget.headerItem (style palette)
            ]
                |> Widget.itemList (listStyle palette)
                --Don't forget to change the title
                |> Page.viewTile "Widget.divider"
    in
    [ viewButton ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


{-| Let's you play around with the options.
Note that the order of these stories must follow the order of the arguments from the view functions.
-}
headerBook : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
headerBook =
    Story.book (Just "Options")
        viewHeaderFunctions
        --Adding a option for different styles.
        |> Story.addStory
            (Story.optionListStory "Column Style"
                ( "CardColumn", Material.cardColumn )
                [ ( "sideSheet", Material.sideSheet )
                , ( "bottomSheet", Material.bottomSheet )
                , ( "Column", always Material.column )
                ]
            )
        |> Story.addStory
            (Story.optionListStory "Style"
                ( "FullBleedHeader", Material.fullBleedHeader )
                [ ( "InsetHeader", Material.insetHeader )
                ]
            )
        |> Story.addStory
            (Story.textStory "Text"
                "Header"
            )
        |> Story.build


viewFullBleedItemFunctions =
    let
        viewFullBleedItem listStyle style text onPress icon { palette } () =
            [ Widget.fullBleedItem (style palette)
                { text = text
                , onPress = onPress
                , icon = icon
                }
            , Widget.fullBleedItem (style palette)
                { text = text
                , onPress = onPress
                , icon = icon
                }
            , Widget.fullBleedItem (style palette)
                { text = text
                , onPress = onPress
                , icon = icon
                }
            ]
                |> Widget.itemList (listStyle palette)
                --Don't forget to change the title
                |> Page.viewTile "Widget.fullBleedItem"
    in
    [ viewFullBleedItem ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


fullBleedItemBook : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
fullBleedItemBook =
    Story.book (Just "Options")
        viewFullBleedItemFunctions
        --Adding a option for different styles.
        |> Story.addStory
            (Story.optionListStory "Column Style"
                ( "CardColumn", Material.cardColumn )
                [ ( "sideSheet", Material.sideSheet )
                , ( "bottomSheet", Material.bottomSheet )
                , ( "Column", always Material.column )
                ]
            )
        |> Story.addStory
            (Story.optionListStory "Style"
                ( "FullBleedItem", Material.fullBleedItem )
                []
            )
        |> Story.addStory
            (Story.textStory "Text"
                "Item text"
            )
        |> Story.addStory
            (Story.boolStory "With event handler"
                ( Just (), Nothing )
                True
            )
        |> Story.addStory
            (Story.boolStory "With Icon"
                ( MaterialIcons.done
                    |> Icon.elmMaterialIcons Color
                , always Element.none
                )
                True
            )
        |> Story.build


viewInsetItemFunctions =
    let
        viewFullBleedItem listStyle style text onPress icon content { palette } () =
            [ Widget.insetItem (style palette)
                { text = text
                , onPress = onPress
                , icon = icon
                , content = content
                }
            , Widget.insetItem (style palette)
                { text = text
                , onPress = onPress
                , icon = icon
                , content = content
                }
            , Widget.insetItem (style palette)
                { text = text
                , onPress = onPress
                , icon = icon
                , content = content
                }
            ]
                |> Widget.itemList (listStyle palette)
                --Don't forget to change the title
                |> Page.viewTile "Widget.insetItem"
    in
    [ viewFullBleedItem ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


insetItemBook : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
insetItemBook =
    Story.book (Just "Options")
        viewInsetItemFunctions
        --Adding a option for different styles.
        |> Story.addStory
            (Story.optionListStory "Column Style"
                ( "CardColumn", Material.cardColumn )
                [ ( "sideSheet", Material.sideSheet )
                , ( "bottomSheet", Material.bottomSheet )
                , ( "Column", always Material.column )
                ]
            )
        |> Story.addStory
            (Story.optionListStory "Style"
                ( "InsetItem", Material.insetItem )
                []
            )
        |> Story.addStory
            (Story.textStory "Text"
                "Item text"
            )
        |> Story.addStory
            (Story.boolStory "With event handler"
                ( Just (), Nothing )
                True
            )
        |> Story.addStory
            (Story.boolStory "With Icon"
                ( MaterialIcons.done
                    |> Icon.elmMaterialIcons Color
                , always Element.none
                )
                True
            )
        |> Story.addStory
            (Story.boolStory "With Content"
                ( MaterialIcons.done
                    |> Icon.elmMaterialIcons Color
                , always Element.none
                )
                True
            )
        |> Story.build


viewMultiLineItemFunctions =
    let
        viewMultiLineItem listStyle style titleText text onPress icon content { palette } () =
            [ Widget.multiLineItem (style palette)
                { title = titleText
                , text = text
                , onPress = onPress
                , icon = icon
                , content = content
                }
            , Widget.multiLineItem (style palette)
                { title = titleText
                , text = text
                , onPress = onPress
                , icon = icon
                , content = content
                }
            , Widget.multiLineItem (style palette)
                { title = titleText
                , text = text
                , onPress = onPress
                , icon = icon
                , content = content
                }
            ]
                |> Widget.itemList (listStyle palette)
                --Don't forget to change the title
                |> Page.viewTile "Widget.multiLineItem"
    in
    [ viewMultiLineItem ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


multiLineItemBook : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
multiLineItemBook =
    Story.book (Just "Options")
        viewMultiLineItemFunctions
        --Adding a option for different styles.
        |> Story.addStory
            (Story.optionListStory "Column Style"
                ( "CardColumn", Material.cardColumn )
                [ ( "sideSheet", Material.sideSheet )
                , ( "bottomSheet", Material.bottomSheet )
                , ( "Column", always Material.column )
                ]
            )
        |> Story.addStory
            (Story.optionListStory "Style"
                ( "InsetItem", Material.multiLineItem )
                []
            )
        |> Story.addStory
            (Story.textStory "Title"
                "Title"
            )
        |> Story.addStory
            (Story.textStory "Text"
                "This text may span over multiple lines. But more then three should be avoided."
            )
        |> Story.addStory
            (Story.boolStory "With event handler"
                ( Just (), Nothing )
                True
            )
        |> Story.addStory
            (Story.boolStory "With Icon"
                ( MaterialIcons.done
                    |> Icon.elmMaterialIcons Color
                , always Element.none
                )
                True
            )
        |> Story.addStory
            (Story.boolStory "With Content"
                ( MaterialIcons.done
                    |> Icon.elmMaterialIcons Color
                , always Element.none
                )
                True
            )
        |> Story.build


viewMExpansionItemFunctions =
    let
        viewMultiLineItem listStyle style icon text isExpanded { palette } () =
            [ Widget.expansionItem (style palette)
                { icon = icon
                , text = text
                , onToggle = always ()
                , content =
                    [ Widget.fullBleedItem (Material.fullBleedItem palette)
                        { text = "Placeholder"
                        , onPress = Nothing
                        , icon = always Element.none
                        }
                    ]
                , isExpanded = isExpanded
                }
            , Widget.expansionItem (style palette)
                { icon = icon
                , text = text
                , onToggle = always ()
                , content =
                    [ Widget.fullBleedItem (Material.fullBleedItem palette)
                        { text = "Placeholder"
                        , onPress = Nothing
                        , icon = always Element.none
                        }
                    ]
                , isExpanded = isExpanded
                }
            , Widget.expansionItem (style palette)
                { icon = icon
                , text = text
                , onToggle = always ()
                , content =
                    [ Widget.fullBleedItem (Material.fullBleedItem palette)
                        { text = "Placeholder"
                        , onPress = Nothing
                        , icon = always Element.none
                        }
                    ]
                , isExpanded = isExpanded
                }
            ]
                |> List.concat
                |> Widget.itemList (listStyle palette)
                --Don't forget to change the title
                |> Page.viewTile "Widget.multiLineItem"
    in
    [ viewMultiLineItem ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


expansionItemBook : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
expansionItemBook =
    Story.book (Just "Options")
        viewMExpansionItemFunctions
        --Adding a option for different styles.
        |> Story.addStory
            (Story.optionListStory "Column Style"
                ( "CardColumn", Material.cardColumn )
                [ ( "sideSheet", Material.sideSheet )
                , ( "bottomSheet", Material.bottomSheet )
                , ( "Column", always Material.column )
                ]
            )
        |> Story.addStory
            (Story.optionListStory "Style"
                ( "InsetItem", Material.expansionItem )
                []
            )
        |> Story.addStory
            (Story.boolStory "With Icon"
                ( MaterialIcons.done
                    |> Icon.elmMaterialIcons Color
                , always Element.none
                )
                True
            )
        |> Story.addStory
            (Story.textStory "Text"
                "Item text"
            )
        |> Story.addStory
            (Story.boolStory "is Expanded"
                ( True, False )
                True
            )
        |> Story.build


viewSelectItemFunctions =
    let
        viewMultiLineItem listStyle style selected options onSelect { palette } () =
            [ Widget.selectItem (style palette)
                { selected = selected
                , options = options
                , onSelect = onSelect
                }
            ]
                |> List.concat
                |> Widget.itemList (listStyle palette)
                --Don't forget to change the title
                |> Page.viewTile "Widget.multiLineItem"
    in
    [ viewMultiLineItem ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


selectItemBook : Tile.Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
selectItemBook =
    Story.book (Just "Options")
        viewSelectItemFunctions
        --Adding a option for different styles.
        |> Story.addStory
            (Story.optionListStory "Column Style"
                ( "CardColumn", Material.cardColumn )
                [ ( "sideSheet", Material.sideSheet )
                , ( "bottomSheet", Material.bottomSheet )
                , ( "Column", always Material.column )
                ]
            )
        |> Story.addStory
            (Story.optionListStory "Style"
                ( "InsetItem", Material.selectItem )
                []
            )
        |> Story.addStory
            (Story.optionListStory "Selected"
                ( "Third", Just 2 )
                [ ( "Second", Just 1 )
                , ( "First", Just 0 )
                , ( "Nothing or Invalid", Nothing )
                ]
            )
        --Change the Icon
        |> Story.addStory
            (Story.optionListStory "Options"
                ( "3 Option"
                , [ { icon = always Element.none, text = "Submit" }
                  , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "" }
                  , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "Submit" }
                  ]
                )
                [ ( "2 Option"
                  , [ { icon = always Element.none, text = "Submit" }
                    , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "" }
                    ]
                  )
                , ( "1 Option", [ { icon = always Element.none, text = "Submit" } ] )
                ]
            )
        --Should an event be triggered when pressing the button?
        |> Story.addStory
            (Story.boolStory "With event handler"
                ( always <| Just (), always Nothing )
                True
            )
        |> Story.build



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


type Model
    = IsEnabled Bool


type Msg
    = ToggleModal Bool


init : ( Model, Cmd Msg )
init =
    ( IsEnabled True
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ToggleModal bool ->
            ( IsEnabled bool
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } (IsEnabled isEnabled) =
    Widget.button (Material.containedButton palette)
        { text = "Show Sheet"
        , icon = MaterialIcons.visibility |> Icon.elmMaterialIcons Color
        , onPress = ToggleModal True |> Just
        }
        |> Element.el
            ([ Element.height <| Element.minimum 200 <| Element.fill
             , Element.width <| Element.minimum 400 <| Element.fill
             ]
                ++ (if isEnabled then
                        { content =
                            [ "Menu"
                                |> Element.text
                                |> Element.el Typography.h6
                                |> Widget.asItem
                            , Widget.insetItem (Material.insetItem palette)
                                { onPress = Just <| ToggleModal False
                                , icon =
                                    MaterialIcons.change_history
                                        |> Icon.elmMaterialIcons Color
                                , text = "Home"
                                , content =
                                    \_ ->
                                        Element.none
                                }
                            , Widget.insetItem (Material.insetItem palette)
                                { onPress = Just <| ToggleModal False
                                , icon =
                                    MaterialIcons.change_history
                                        |> Icon.elmMaterialIcons Color
                                , text = "About"
                                , content =
                                    \_ ->
                                        Element.none
                                }
                            ]
                                |> Widget.itemList (Material.sideSheet palette)
                        , onDismiss = Just <| ToggleModal False
                        }
                            |> List.singleton
                            |> Widget.singleModal

                    else
                        []
                   )
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
    Tile.static []
        (\_ _ ->
            [ title |> Element.text |> Element.el Typography.h3
            , description |> Element.text |> List.singleton |> Element.paragraph []
            ]
                |> Element.column [ Element.spacing 32 ]
        )
        |> Tile.first
        |> Tile.nextGroup dividerBook
        |> Tile.nextGroup headerBook
        |> Tile.nextGroup fullBleedItemBook
        |> Tile.nextGroup insetItemBook
        |> Tile.nextGroup multiLineItemBook
        |> Tile.nextGroup expansionItemBook
        |> Tile.nextGroup selectItemBook
        |> Tile.next demo
        |> Tile.page
