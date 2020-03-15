module Widget.ValidatedInput exposing
    ( Model, Msg, init, update, view
    , getError, getRaw, getValue
    )

{-| The validated Input is a wrapper around `Input.text`.
They can validate the input and return an error if nessarry.


# Basics

@docs Model, Msg, init, update, view


# Access the Model

@docs getError, getRaw, getValue

-}

import Element exposing (Attribute, Element)
import Element.Events as Events
import Element.Input as Input exposing (Placeholder)


{-| -}
type Model err a
    = Model
        { raw : Maybe String
        , value : a
        , err : Maybe err
        , validator : String -> Result err a
        , toString : a -> String
        }


{-| -}
getRaw : Model err a -> String
getRaw (Model { raw, value, toString }) =
    case raw of
        Just string ->
            string

        Nothing ->
            value |> toString


{-| -}
getValue : Model err a -> a
getValue (Model { value }) =
    value


{-| -}
getError : Model err a -> Maybe err
getError (Model { err }) =
    err


{-| -}
type Msg
    = ChangedRaw String
    | LostFocus
    | StartEditing


{-| -}
init : { value : a, validator : String -> Result err a, toString : a -> String } -> Model err a
init { validator, toString, value } =
    Model
        { raw = Nothing
        , value = value
        , err = Nothing
        , validator = validator
        , toString = toString
        }


{-| -}
update : Msg -> Model err a -> Model err a
update msg (Model model) =
    case msg of
        StartEditing ->
            Model
                { model
                    | raw = model.value |> model.toString |> Just
                }

        ChangedRaw string ->
            Model
                { model
                    | raw = Just string
                    , err = Nothing
                }

        LostFocus ->
            case model.raw of
                Just string ->
                    case model.validator string of
                        Ok value ->
                            Model
                                { model
                                    | value = value
                                    , raw = Nothing
                                    , err = Nothing
                                }

                        Err err ->
                            Model
                                { model
                                    | raw = Nothing
                                    , err = Just err
                                }

                Nothing ->
                    Model model


{-| -}
view :
    List (Attribute msg)
    -> Model err a
    ->
        { msgMapper : Msg -> msg
        , placeholder : Maybe (Placeholder msg)
        , label : String
        , readOnly : a -> Element msg
        }
    -> Element msg
view attributes (Model model) { msgMapper, placeholder, label, readOnly } =
    case model.raw of
        Just string ->
            Input.text (attributes ++ [ Events.onLoseFocus <| msgMapper <| LostFocus ])
                { onChange = ChangedRaw >> msgMapper
                , text = string
                , placeholder = placeholder
                , label = Input.labelHidden label
                }

        Nothing ->
            Input.button []
                { onPress = Just (StartEditing |> msgMapper)
                , label = model.value |> readOnly
                }
