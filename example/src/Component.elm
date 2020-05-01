module Component exposing (Model, Msg(..), init, update, view)

import Browser
import Element exposing (Color, Element)
import Element.Background as Background
import Element.Input as Input
import Element.Border as Border
import Element.Font as Font
import Framework
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Framework.Group as Group
import Framework.Heading as Heading
import Framework.Input as Input
import Framework.Tag as Tag
import Heroicons.Solid as Heroicons
import Html exposing (Html)
import Html.Attributes as Attributes
import Set exposing (Set)
import Time
import Widget
import Widget.Style exposing (ButtonStyle)
import Widget.FilterSelect as FilterSelect
import Widget.FilterMultiSelect as FilterMultiSelect
import Widget.ScrollingNav as ScrollingNav
import Widget.Snackbar as Snackbar
import Widget.ValidatedInput as ValidatedInput
import Data.Style exposing (style)

type alias Model =
    { filterSelect : FilterSelect.Model
    , filterMultiSelect : FilterMultiSelect.Model
    , validatedInput : ValidatedInput.Model () ( String, String )
    }


type Msg
    = FilterSelectSpecific FilterSelect.Msg
    | FilterMultiSelectSpecific FilterMultiSelect.Msg
    | ValidatedInputSpecific ValidatedInput.Msg



init : Model
init =
    { filterSelect =
        [ "Apple"
        , "Kiwi"
        , "Strawberry"
        , "Pineapple"
        , "Mango"
        , "Grapes"
        , "Watermelon"
        , "Orange"
        , "Lemon"
        , "Blueberry"
        , "Grapefruit"
        , "Coconut"
        , "Cherry"
        , "Banana"
        ]
            |> Set.fromList
            |> FilterSelect.init
    , filterMultiSelect =
        [ "Apple"
        , "Kiwi"
        , "Strawberry"
        , "Pineapple"
        , "Mango"
        , "Grapes"
        , "Watermelon"
        , "Orange"
        , "Lemon"
        , "Blueberry"
        , "Grapefruit"
        , "Coconut"
        , "Cherry"
        , "Banana"
        ]
            |> Set.fromList
            |> FilterMultiSelect.init
    , validatedInput =
        ValidatedInput.init
            { value = ( "John", "Doe" )
            , validator =
                \string ->
                    case string |> String.split " " of
                        [ first, second ] ->
                            Ok ( first, second )

                        _ ->
                            Err ()
            , toString =
                \( first, second ) -> first ++ " " ++ second
            }
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FilterSelectSpecific m ->
            ( { model
                | filterSelect = model.filterSelect |> FilterSelect.update m
              }
            , Cmd.none
            )

        FilterMultiSelectSpecific m ->
            ( { model
                | filterMultiSelect = model.filterMultiSelect |> FilterMultiSelect.update m
              }
            , Cmd.none
            )

        ValidatedInputSpecific m ->
            ( { model
                | validatedInput = model.validatedInput |> ValidatedInput.update m
              }
            , Cmd.none
            )


filterSelect : FilterSelect.Model -> (String,Element Msg)
filterSelect model =
    ( "Filter Select"
        , case model.selected of
            Just selected ->
                Element.row Grid.compact
                    [ Element.el (Tag.simple ++ Group.left) <| Element.text <| selected
                    , Input.button (Tag.simple ++ Group.right ++ Color.danger)
                        { onPress = Just <| FilterSelectSpecific <| FilterSelect.Selected Nothing
                        , label = Element.html <| Heroicons.x [ Attributes.width 16 ]
                        }
                    ]

            Nothing ->
                Element.column Grid.simple
                    [ FilterSelect.viewInput Input.simple
                        model
                        { msgMapper = FilterSelectSpecific
                        , placeholder =
                            Just <|
                                Input.placeholder [] <|
                                    Element.text <|
                                        "Fruit"
                        , label = "Fruit"
                        }
                    , model
                        |> FilterSelect.viewOptions
                        |> List.map
                            (\string ->
                                Input.button (Button.simple ++ Tag.simple)
                                    { onPress = Just <| FilterSelectSpecific <| FilterSelect.Selected <| Just <| string
                                    , label = Element.text string
                                    }
                            )
                        |> Element.wrappedRow [ Element.spacing 10 ]
                    ]
    )

filterMultiSelect : FilterMultiSelect.Model -> (String,Element Msg)
filterMultiSelect model =
    ( "Filter Multi Select"
    ,   [ FilterMultiSelect.viewInput model
            { msgMapper = FilterMultiSelectSpecific
            , placeholder =
                Just <|
                    Input.placeholder [] <|
                        Element.text <|
                            "Fruit"
            , label = "Fruit"
            , toChip = \string ->
                { text = string
                , onPress = Just <| FilterMultiSelectSpecific <| FilterMultiSelect.ToggleSelected <| string
                , icon = Element.none
                }
            }
            |> Widget.textInput style.textInput

        , model
            |> FilterMultiSelect.viewOptions
            |> List.map
                (\string ->
                    Input.button (Button.simple ++ Tag.simple)
                        { onPress = Just <| FilterMultiSelectSpecific <| FilterMultiSelect.ToggleSelected <| string
                        , label = Element.text string
                        }
                )
            |> Element.wrappedRow [ Element.spacing 10 ]
        ]
            |> Element.column Grid.simple
    )

validatedInput : ValidatedInput.Model () ( String, String ) -> (String,Element Msg)
validatedInput model =
    ( "Validated Input"
        , ValidatedInput.view Input.simple
            model
            { label = "First Name, Sir Name"
            , msgMapper = ValidatedInputSpecific
            , placeholder = Nothing
            , readOnly =
                \maybeTuple ->
                    Element.row Grid.compact
                        [ maybeTuple
                            |> (\( a, b ) -> a ++ " " ++ b)
                            |> Element.text
                            |> Element.el (Tag.simple ++ Group.left)
                        , Heroicons.pencil [ Attributes.width 16 ]
                            |> Element.html
                            |> Element.el (Tag.simple ++ Group.right ++ Color.primary)
                        ]
            }
    )

view : (Msg -> msg) -> Model -> 
    { title : String
    , description : String
    , items : List (String,Element msg)
    }
view msgMapper model =
    { title = "Components"
    , description = "Components have a Model, an Update- and sometimes even a Subscription-function. It takes some time to set them up correctly."
    , items =
        [ filterSelect model.filterSelect
        , filterMultiSelect model.filterMultiSelect
        , validatedInput model.validatedInput 
        ]
            |> List.map (Tuple.mapSecond (Element.map msgMapper) )
    }
