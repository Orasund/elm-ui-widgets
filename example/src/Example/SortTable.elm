module Example.SortTable exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import Widget exposing (SortTableStyle)
import Widget.Style.Material as Material


type alias Style style msg =
    { style
        | sortTable : SortTableStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { sortTable = Material.sortTable Material.defaultPalette
    }


type alias Model =
    { title : String
    , asc : Bool
    }


type Msg
    = ChangedSorting String


init : ( Model, Cmd Msg )
init =
    ( { title = "Name", asc = True }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedSorting string ->
            ( { title = string
              , asc =
                    if model.title == string then
                        not model.asc

                    else
                        True
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
    Widget.sortTable style.sortTable
        { content =
            [ { id = 1, name = "Antonio", rating = 2.456, hash = Nothing }
            , { id = 2, name = "Ana", rating = 1.34, hash = Just "45jf" }
            , { id = 3, name = "Alfred", rating = 4.22, hash = Just "6fs1" }
            , { id = 4, name = "Thomas", rating = 3, hash = Just "k52f" }
            ]
        , columns =
            [ Widget.intColumn
                { title = "Id"
                , value = .id
                , toString = \int -> "#" ++ String.fromInt int
                , width = Element.fill
                }
            , Widget.stringColumn
                { title = "Name"
                , value = .name
                , toString = identity
                , width = Element.fill
                }
            , Widget.floatColumn
                { title = "Rating"
                , value = .rating
                , toString = String.fromFloat
                , width = Element.fill
                }
            , Widget.unsortableColumn
                { title = "Hash"
                , toString = .hash >> Maybe.withDefault "None"
                , width = Element.fill
                }
            ]
        , asc = model.asc
        , sortBy = model.title
        , onChange = ChangedSorting >> msgMapper
        }


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
