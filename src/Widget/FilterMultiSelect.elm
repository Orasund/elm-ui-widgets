module Widget.FilterMultiSelect exposing (Model, Msg(..), init, update, viewInput, viewOptions)

{-|

@docs Model, Msg, init, update, viewInput, viewOptions

-}

import Element.Input exposing (Placeholder)
import Set exposing (Set)
import Widget exposing (Button)


{-| The Model containing the raw value, the selected value and all the possible options.
-}
type alias Model =
    { raw : String
    , selected : Set String
    , options : Set String
    }


{-| The Msg is exposed by design. You can unselect by sending `Selected Nothing`.
-}
type Msg
    = ChangedRaw String
    | ToggleSelected String


{-| The initial state contains the set of possible options.
-}
init : Set String -> Model
init options =
    { raw = ""
    , selected = Set.empty
    , options = options
    }


{-| Updates the Model
-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangedRaw string ->
            { model
                | raw = string
            }

        ToggleSelected string ->
            if model.selected |> Set.member string then
                { model
                    | selected = model.selected |> Set.remove string
                }

            else
                { model
                    | selected = model.selected |> Set.insert string
                    , raw = ""
                }


{-| A wrapper around Input.text.
-}
viewInput :
    Model
    ->
        { msgMapper : Msg -> msg
        , placeholder : Maybe (Placeholder msg)
        , label : String
        , toChip : String -> Button msg
        }
    ->
        { chips : List (Button msg)
        , text : String
        , placeholder : Maybe (Placeholder msg)
        , label : String
        , onChange : String -> msg
        }
viewInput model { msgMapper, placeholder, label, toChip } =
    { chips =
        model.selected
            |> Set.toList
            |> List.map toChip
    , text = model.raw
    , placeholder = placeholder
    , label = label
    , onChange = ChangedRaw >> msgMapper
    }


{-| Returns a List of all options that matches the filter.
-}
viewOptions : Model -> List String
viewOptions { raw, options, selected } =
    if raw == "" then
        []

    else
        options
            |> Set.filter (String.toUpper >> String.contains (raw |> String.toUpper))
            |> Set.filter
                (\string ->
                    selected
                        |> Set.member string
                        |> not
                )
            |> Set.toList
