module Page.Item exposing (page, update)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}

import Element exposing (Element)
import Element.Font as Font
import Material.Icons as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Page
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Tile, TileMsg)
import Widget
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


type alias Model =
    { isEnabled : Bool
    , isExpanded : Bool
    }


type Msg
    = ToggleModal Bool
    | ToogleExpand Bool


init : ( Model, Cmd Msg )
init =
    ( { isEnabled = True
      , isExpanded = False
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleModal bool ->
            ( { model | isEnabled = bool }
            , Cmd.none
            )

        ToogleExpand bool ->
            ( { model | isExpanded = bool }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } model =
    Widget.button (Material.containedButton palette)
        { text = "Show Sheet"
        , icon = MaterialIcons.visibility |> Icon.elmMaterialIcons Color
        , onPress = ToggleModal True |> Just
        }
        |> Element.el
            ([ Element.height <| Element.minimum 800 <| Element.fill
             , Element.width <| Element.minimum 400 <| Element.fill
             ]
                ++ (if model.isEnabled then
                        { content =
                            [ [ "Section 1"
                                    |> Widget.headerItem (Material.fullBleedHeader palette)
                              , Widget.asItem <| Element.text <| "Custom Item"
                              , Widget.divider (Material.middleDivider palette)
                              , Widget.fullBleedItem (Material.fullBleedItem palette)
                                    { onPress = Nothing
                                    , icon =
                                        \_ ->
                                            Element.none
                                    , text = "Full Bleed Item"
                                    }
                              , "Section 2"
                                    |> Widget.headerItem (Material.fullBleedHeader palette)
                              , Widget.insetItem (Material.insetItem palette)
                                    { onPress = Nothing
                                    , icon =
                                        MaterialIcons.change_history
                                            |> Icon.elmMaterialIcons Color
                                    , text = "Item with Icon"
                                    , content =
                                        \_ ->
                                            Element.none
                                    }
                              , Widget.imageItem (Material.imageItem palette)
                                    { onPress = Nothing
                                    , image =
                                        Element.image [ Element.width <| Element.px <| 40, Element.height <| Element.px <| 40 ]
                                            { src = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Elm_logo.svg/1024px-Elm_logo.svg.png"
                                            , description = "Elm logo"
                                            }
                                    , text = "Item with Image"
                                    , content =
                                        \{ size, color } ->
                                            "1."
                                                |> Element.text
                                                |> Element.el
                                                    [ Font.color <| MaterialColor.fromColor color
                                                    , Font.size size
                                                    ]
                                    }
                              , Widget.divider (Material.insetDivider palette)
                              , Widget.insetItem (Material.insetItem palette)
                                    { onPress = not model.isExpanded |> ToogleExpand |> Just
                                    , icon = always Element.none
                                    , text = "Click Me"
                                    , content =
                                        \{ size, color } ->
                                            "2."
                                                |> Element.text
                                                |> Element.el
                                                    [ Font.color <| MaterialColor.fromColor color
                                                    , Font.size size
                                                    ]
                                    }
                              , Widget.multiLineItem (Material.multiLineItem palette)
                                    { title = "Item"
                                    , text = "Description. Description. Description. Description. Description. Description. Description. Description. Description. Description."
                                    , onPress = Nothing
                                    , icon = always Element.none
                                    , content = always Element.none
                                    }
                              , Widget.imageItem (Material.imageItem palette)
                                    { onPress = not model.isExpanded |> ToogleExpand |> Just
                                    , image = Element.none
                                    , text = "Clickable Item with Switch"
                                    , content =
                                        \_ ->
                                            Widget.switch (Material.switch palette)
                                                { description = "Click Me"
                                                , active = model.isExpanded
                                                , onPress =
                                                    not model.isExpanded
                                                        |> ToogleExpand
                                                        |> Just
                                                }
                                    }
                              , Widget.divider (Material.fullBleedDivider palette)
                              ]
                            , Widget.expansionItem (Material.expansionItem palette)
                                { onToggle = ToogleExpand
                                , isExpanded = model.isExpanded
                                , icon = always Element.none
                                , text = "Expandable Item"
                                , content =
                                    [ "Section 3"
                                        |> Widget.headerItem (Material.insetHeader palette)
                                    , Widget.insetItem (Material.insetItem palette)
                                        { onPress = Nothing
                                        , icon = always Element.none
                                        , text = "Item"
                                        , content =
                                            \{ size, color } ->
                                                "3."
                                                    |> Element.text
                                                    |> Element.el
                                                        [ Font.color <| MaterialColor.fromColor color
                                                        , Font.size size
                                                        ]
                                        }
                                    ]
                                }
                            , [ "Menu" |> Widget.headerItem (Material.fullBleedHeader palette) ]
                            , { selected =
                                    if model.isExpanded then
                                        Just 1

                                    else
                                        Just 0
                              , options =
                                    [ True, False ]
                                        |> List.map
                                            (\bool ->
                                                { text =
                                                    if bool then
                                                        "Expanded"

                                                    else
                                                        "Collapsed"
                                                , icon = always Element.none
                                                }
                                            )
                              , onSelect =
                                    \int ->
                                        (int == 1)
                                            |> ToogleExpand
                                            |> Just
                              }
                                |> Widget.selectItem (Material.selectItem palette)
                            ]
                                |> List.concat
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
        |> Tile.next demo
        |> Tile.nextGroup dividerBook
        |> Tile.nextGroup headerBook
        |> Tile.nextGroup fullBleedItemBook
        |> Tile.nextGroup insetItemBook
        |> Tile.nextGroup multiLineItemBook
        |> Tile.nextGroup expansionItemBook
        |> Tile.nextGroup selectItemBook
        |> Tile.page
