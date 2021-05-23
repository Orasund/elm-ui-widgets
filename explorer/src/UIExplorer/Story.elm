module UIExplorer.Story exposing (..)

import Dict exposing (Dict)
import Element exposing (Attribute, Element)
import Element.Input as Input exposing (Label, Option, labelAbove, option, radio)
import SelectList exposing (SelectList)
import UIExplorer.Tile as Tile
import UiExplorer exposing (PageSize)


type StoryInfo
    = RangeStory String { unit : String, min : Int, max : Int, default : Int }
    | TextStory String String
    | OptionListStory String (List String)
    | BoolStory String Bool


type alias Story a =
    { info : StoryInfo
    , toValue : String -> a
    }


optionListStory : String -> a -> List ( String, a ) -> Story a
optionListStory label default options =
    { info = OptionListStory label <| List.map Tuple.first options
    , toValue =
        \optLabel ->
            options
                |> List.foldl
                    (\( key, optvalue ) res ->
                        case ( res, optLabel == key ) of
                            ( Just x, _ ) ->
                                Just x

                            ( Nothing, True ) ->
                                Just optvalue

                            ( Nothing, False ) ->
                                Nothing
                    )
                    Nothing
                |> Maybe.withDefault default
    }


textStory : String -> String -> Story String
textStory label default =
    { info = TextStory label default
    , toValue = identity
    }


rangeStory :
    String
    -> { unit : String, min : Int, max : Int, default : Int }
    -> Story Int
rangeStory label cfg =
    { info = RangeStory label cfg
    , toValue = String.toInt >> Maybe.withDefault cfg.default
    }


boolStory : String -> ( a, a ) -> Bool -> Story a
boolStory label ( ifTrue, ifFalse ) default =
    { info = BoolStory label default
    , toValue =
        \s ->
            if s == "t" then
                ifTrue

            else
                ifFalse
    }


type alias Group view model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , views : List view
    , subscriptions : model -> Sub msg
    }


type alias GroupBuilder view model msg flags a =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , views : a -> List view
    , subscriptions : model -> Sub msg
    }


type alias BookBuilder view model msg flags a =
    { title : Maybe String
    , stories : List StoryInfo
    , storiesToValue : List String -> a
    , tilelist : GroupBuilder view model msg flags a
    }


book :
    Maybe String
    -> Group view model msg flags
    -> BookBuilder view model msg flags ()
book title tilelist =
    { title = title
    , stories = []
    , storiesToValue = always ()
    , tilelist =
        { init = tilelist.init
        , update = tilelist.update
        , subscriptions = tilelist.subscriptions
        , views = always tilelist.views
        }
    }


addStory : Story a -> BookBuilder (a -> view) model msg flags previous -> BookBuilder view model msg flags ( a, previous )
addStory { info, toValue } builder =
    let
        storiesToValue key =
            -- consume the first token and delegate the rest to the former 'tovalue'
            case key of
                head :: tail ->
                    ( toValue head, builder.storiesToValue tail )

                [] ->
                    ( toValue "", builder.storiesToValue [] )
    in
    { title = builder.title
    , stories = info :: builder.stories
    , storiesToValue = storiesToValue
    , tilelist = addStoryToGroup builder.tilelist
    }


addStoryToGroup : GroupBuilder (a -> view) model msg flags previous -> GroupBuilder view model msg flags ( a, previous )
addStoryToGroup builder =
    { init = builder.init
    , update = builder.update
    , subscriptions = builder.subscriptions
    , views =
        \( a, previous ) ->
            builder.views previous
                |> List.map
                    (\view ->
                        view a
                    )
    }


initTiles :
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    }
    -> Group view model msg flags
initTiles { init, update, subscriptions } =
    { init = init
    , update = update
    , views = []
    , subscriptions = subscriptions
    }


addTile :
    view
    -> Group view model msg flags
    -> Group view model msg flags
addTile view tilelist =
    { tilelist
        | views =
            List.append tilelist.views [ view ]
    }


initStaticTiles : Group view () () ()
initStaticTiles =
    { init = always ( (), Cmd.none )
    , update = \_ _ -> ( (), Cmd.none )
    , views = []
    , subscriptions = always Sub.none
    }


type StoryModel
    = RangeStoryModel String { unit : String, min : Int, max : Int, value : Int }
    | TextStoryModel String String
    | OptionListStoryModel String (SelectList String)
    | BoolStoryModel String Bool


type alias StorySelectorModel =
    List StoryModel


enforceRange : Int -> Int -> Int -> Int
enforceRange min max value =
    case ( value < min, value > max ) of
        ( True, True ) ->
            value

        ( True, False ) ->
            min

        ( False, True ) ->
            max

        ( False, False ) ->
            value


storyCurrentValue : StoryModel -> String
storyCurrentValue model =
    case model of
        RangeStoryModel _ { value } ->
            String.fromInt value

        TextStoryModel _ value ->
            value

        OptionListStoryModel _ select ->
            SelectList.selected select

        BoolStoryModel _ value ->
            if value then
                "t"

            else
                "f"


storyLabelIs : String -> StoryModel -> Bool
storyLabelIs label model =
    case model of
        RangeStoryModel storyLabel _ ->
            label == storyLabel

        TextStoryModel storyLabel _ ->
            label == storyLabel

        OptionListStoryModel storyLabel _ ->
            label == storyLabel

        BoolStoryModel storyLabel _ ->
            label == storyLabel


storySetValue : String -> StoryModel -> StoryModel
storySetValue value model =
    case model of
        RangeStoryModel storyLabel state ->
            case String.toInt value of
                Nothing ->
                    model

                Just intValue ->
                    RangeStoryModel storyLabel
                        { state
                            | value = enforceRange state.min state.max intValue
                        }

        TextStoryModel storyLabel oldValue ->
            TextStoryModel storyLabel value

        OptionListStoryModel storyLabel select ->
            select
                |> SelectList.attempt (SelectList.selectBeforeIf <| (==) value)
                |> SelectList.attempt (SelectList.selectAfterIf <| (==) value)
                |> OptionListStoryModel storyLabel

        BoolStoryModel storyLabel _ ->
            BoolStoryModel storyLabel <| value == "t"


selectedStories : StorySelectorModel -> List String
selectedStories =
    List.map
        storyCurrentValue


selectStory : String -> String -> StorySelectorModel -> StorySelectorModel
selectStory label value =
    List.map
        (\story ->
            if storyLabelIs label story then
                storySetValue value story

            else
                story
        )


type StorySelectorMsg
    = StorySelect String String


storyHelp : StoryInfo -> Maybe StoryModel
storyHelp info =
    case info of
        RangeStory label { unit, min, max, default } ->
            Just <| RangeStoryModel label { unit = unit, min = min, max = max, value = default }

        TextStory label default ->
            Just <| TextStoryModel label default

        OptionListStory label options ->
            SelectList.fromList
                options
                |> Maybe.map (OptionListStoryModel label)

        BoolStory label default ->
            Just <| BoolStoryModel label default


storyView : StoryModel -> Element StorySelectorMsg
storyView model =
    case model of
        RangeStoryModel label { unit, min, max, value } ->
            Input.slider []
                { onChange = round >> String.fromInt >> StorySelect label
                , label = Input.labelAbove [] <| Element.text <| label ++ " (" ++ String.fromInt value ++ unit ++ ")"
                , min = toFloat min
                , max = toFloat max
                , value = toFloat value
                , thumb = Input.defaultThumb
                , step = Just 1.0
                }

        TextStoryModel label value ->
            Input.text []
                { onChange = StorySelect label
                , label = Input.labelAbove [] <| Element.text label
                , placeholder = Nothing
                , text = value
                }

        OptionListStoryModel label options ->
            radio []
                { label = labelAbove [] <| Element.text label
                , onChange = StorySelect label
                , options =
                    options
                        |> SelectList.toList
                        |> List.map
                            (\value ->
                                option value <| Element.text value
                            )
                , selected = Just <| SelectList.selected options
                }

        BoolStoryModel label value ->
            Input.checkbox []
                { label = Input.labelRight [] <| Element.text label
                , onChange =
                    \v ->
                        StorySelect label
                            (if v then
                                "t"

                             else
                                "f"
                            )
                , icon = Input.defaultCheckbox
                , checked = value
                }


storyTile : Maybe String -> List StoryInfo -> (List String -> a) -> Tile.Group StorySelectorModel StorySelectorMsg flags
storyTile title stories storiesToValue =
    { init =
        \_ ->
            ( stories
                |> List.reverse
                |> List.filterMap storyHelp
            , Cmd.none
            )
    , update =
        \msg model ->
            case msg of
                StorySelect story value ->
                    ( selectStory story value model, Cmd.none )
    , subscriptions = always Sub.none
    , views =
        \_ model ->
            [ { title = title
              , position = Tile.NewRightColumnTile
              , attributes = []
              , body =
                    model
                        |> List.map storyView
                        |> Element.column []
              }
            ]
    }


build :
    BookBuilder (PageSize -> model -> Tile.View msg) model msg flags a
    -> Tile.Group ( StorySelectorModel, model ) (Tile.TileMsg StorySelectorMsg msg) flags
build builder =
    storyTile builder.title builder.stories builder.storiesToValue
        |> Tile.linkGroup
            { init = builder.tilelist.init
            , update =
                \msg ( selectorModel, model ) ->
                    builder.tilelist.update msg model
            , subscriptions = Tuple.second >> builder.tilelist.subscriptions
            , views =
                \pagesize ( selectorModel, model ) ->
                    selectorModel
                        |> selectedStories
                        |> List.reverse
                        |> builder.storiesToValue
                        |> builder.tilelist.views
                        |> List.map
                            (\view ->
                                view pagesize model
                            )
            }
