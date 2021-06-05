module Page.TextInput exposing (Model, Msg, init, page, subscriptions, update, view)

import Element exposing (Element)
import Element.Input as Input
import Material.Icons as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Page
import Set exposing (Set)
import UIExplorer.Story as Story
import UIExplorer.Tile exposing (Context, Tile)
import Widget
import Widget.Icon as Icon exposing (Icon)
import Widget.Material as Material
    exposing
        ( darkPalette
        , defaultPalette
        )


{-| The title of this page
-}
title : String
title =
    "Text Input"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "Text fields let users enter and edit text."


{-| List of view functions. Essentially, anything that takes a Button as input.
-}
viewFunctions =
    let
        viewInput chips text placeholder label { palette } () =
            Widget.textInput (Material.textInput palette)
                { chips = chips
                , text = text
                , placeholder = placeholder
                , label = label
                , onChange = always ()
                }
                --Don't forget to change the title
                |> Page.viewTile "Widget.currentPasswordInput"
    in
    [ viewInput ]
        |> List.foldl Story.addTile
            Story.initStaticTiles


book =
    Story.book (Just "Options")
        viewFunctions
        |> Story.addStory
            (Story.optionListStory "Chips"
                ( "3 Chips"
                , [ { icon = always Element.none, text = "Apples", onPress = Nothing }
                  , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "", onPress = Just () }
                  , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "Oranges", onPress = Just () }
                  ]
                )
                [ ( "2 Chips"
                  , [ { icon = always Element.none, text = "Apples", onPress = Nothing }
                    , { icon = MaterialIcons.done |> Icon.elmMaterialIcons Color, text = "", onPress = Just () }
                    ]
                  )
                , ( "1 Chips"
                  , [ { icon = always Element.none, text = "Apples", onPress = Nothing } ]
                  )
                , ( "None", [] )
                ]
            )
        |> Story.addStory
            (Story.textStory "Text"
                "123456789"
            )
        |> Story.addStory
            (Story.boolStory "Placeholder"
                ( "password"
                    |> Element.text
                    |> Input.placeholder []
                    |> Just
                , Nothing
                )
                True
            )
        |> Story.addStory
            (Story.textStory "Label"
                "Name"
            )
        |> Story.build



---{- This next section is essentially just a normal Elm program. -}
-----------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


type alias Model =
    { chipTextInput : Set String
    , textInput : String
    }


type Msg
    = ToggleTextInputChip String
    | SetTextInput String


init : ( Model, Cmd Msg )
init =
    ( { chipTextInput = Set.empty
      , textInput = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleTextInputChip string ->
            ( { model
                | chipTextInput =
                    model.chipTextInput
                        |> (if model.chipTextInput |> Set.member string then
                                Set.remove string

                            else
                                Set.insert string
                           )
              }
            , Cmd.none
            )

        SetTextInput string ->
            ( { model | textInput = string }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Context -> Model -> Element Msg
view { palette } model =
    [ { chips =
            model.chipTextInput
                |> Set.toList
                |> List.map
                    (\string ->
                        { icon = always Element.none
                        , text = string
                        , onPress =
                            string
                                |> ToggleTextInputChip
                                |> Just
                        }
                    )
      , text = model.textInput
      , placeholder = Nothing
      , label = "Chips"
      , onChange = SetTextInput
      }
        |> Widget.textInput (Material.textInput palette)
    , model.chipTextInput
        |> Set.diff
            ([ "A", "B", "C" ]
                |> Set.fromList
            )
        |> Set.toList
        |> List.map
            (\string ->
                Widget.button (Material.textInput palette).content.chips.content
                    { onPress =
                        string
                            |> ToggleTextInputChip
                            |> Just
                    , text = string
                    , icon = always Element.none
                    }
            )
        |> Element.wrappedRow [ Element.spacing 10 ]
    ]
        |> Widget.column Material.column



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
    Page.create
        { title = title
        , description = description
        , book = book
        , demo = demo
        }
