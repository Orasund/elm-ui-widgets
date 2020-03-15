module Widget.FilterSelect exposing (Model, Msg(..), init, update, viewInput, viewOptions)

{-|

@docs Model, Msg, init, update, viewInput, viewOptions

-}

import Element exposing (Attribute, Element)
import Element.Input as Input exposing (Placeholder)
import Set exposing (Set)


{-| The Model
-}
type alias Model =
    { raw : String
    , selected : Maybe String
    , options : Set String
    }


{-| The Msg is exposed by design. You can unselect by sending `Selected Nothing`.
-}
type Msg
    = ChangedRaw String
    | Selected (Maybe String)


{-| The initial state contains the set of possible options.
-}
init : Set String -> Model
init options =
    { raw = ""
    , selected = Nothing
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

        Selected maybe ->
            { model
                | selected = maybe
            }
                |> (case maybe of
                        Just string ->
                            \m -> { m | raw = string }

                        Nothing ->
                            identity
                   )


{-| A wrapper around Input.text.
-}
viewInput :
    List (Attribute msg)
    -> Model
    ->
        { msgMapper : Msg -> msg
        , placeholder : Maybe (Placeholder msg)
        , label : String
        }
    -> Element msg
viewInput attributes model { msgMapper, placeholder, label } =
    Input.text attributes
        { onChange = ChangedRaw >> msgMapper
        , text = model.raw
        , placeholder = placeholder
        , label = Input.labelHidden label
        }


{-| Returns a List of all options that matches the filter.
-}
viewOptions : Model -> List String
viewOptions { raw, options } =
    if raw == "" then
        []

    else
        options
            |> Set.filter (String.toUpper >> String.contains (raw |> String.toUpper))
            |> Set.toList
