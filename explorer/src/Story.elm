module Story exposing (..)

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Input as Input exposing (Label, Option, labelAbove, option, radio)
import SelectList exposing (SelectList)
import Tooling
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


type alias BlocList view model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , titles : List (Maybe String)
    , views : List view
    , subscriptions : model -> Sub msg
    }


type alias BlocListBuilder view model msg flags a =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , titles : List (Maybe String)
    , views : a -> List view
    , subscriptions : model -> Sub msg
    }


type alias BookBuilder view model msg flags a =
    { title : Maybe String
    , stories : List StoryInfo
    , storiesToValue : List String -> a
    , bloclist : BlocListBuilder view model msg flags a
    }


book :
    Maybe String
    -> BlocList view model msg flags
    -> BookBuilder view model msg flags ()
book title bloclist =
    { title = title
    , stories = []
    , storiesToValue = always ()
    , bloclist =
        { init = bloclist.init
        , update = bloclist.update
        , titles = bloclist.titles
        , subscriptions = bloclist.subscriptions
        , views = always bloclist.views
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
    , bloclist = addStoryToBlocList builder.bloclist
    }


addStoryToBlocList : BlocListBuilder (a -> view) model msg flags previous -> BlocListBuilder view model msg flags ( a, previous )
addStoryToBlocList builder =
    { init = builder.init
    , update = builder.update
    , titles = builder.titles
    , subscriptions = builder.subscriptions
    , views =
        \( a, previous ) ->
            builder.views previous
                |> List.map (\view -> view a)
    }


static : view -> BlocList view flags msg flags
static blocView =
    { init = \flags -> ( flags, Cmd.none )
    , titles = [ Nothing ]
    , update = \_ m -> ( m, Cmd.none )
    , views = [ blocView ]
    , subscriptions = \_ -> Sub.none
    }


initBlocs :
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    }
    -> BlocList view model msg flags
initBlocs { init, update, subscriptions } =
    { init = init
    , titles = []
    , update = update
    , views = []
    , subscriptions = subscriptions
    }


addBloc : Maybe String -> view -> BlocList view model msg flags -> BlocList view model msg flags
addBloc title view bloclist =
    { bloclist
        | titles = List.append bloclist.titles [ title ]
        , views = List.append bloclist.views [ view ]
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


storyBloc : Maybe String -> List StoryInfo -> (List String -> a) -> Tooling.BlocList StorySelectorModel StorySelectorMsg flags
storyBloc title stories storiesToValue =
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
    , titles = [ title ]
    , subscriptions = always Sub.none
    , views =
        \_ model ->
            [ { sidebloc = True
              , body =
                    model
                        |> List.map storyView
                        |> Element.column []
              }
            ]
    }


build :
    BookBuilder (PageSize -> model -> Element msg) model msg flags a
    -> Tooling.BlocList ( StorySelectorModel, model ) (Tooling.BlocMsg StorySelectorMsg msg) flags
build builder =
    storyBloc builder.title builder.stories builder.storiesToValue
        |> Tooling.linkBlocList
            { init = builder.bloclist.init
            , update =
                \msg ( selectorModel, model ) ->
                    builder.bloclist.update msg model
            , titles = builder.bloclist.titles
            , subscriptions = Tuple.second >> builder.bloclist.subscriptions
            , views =
                \pagesize ( selectorModel, model ) ->
                    List.map
                        (\view ->
                            { sidebloc = False
                            , body = view pagesize model
                            }
                        )
                        (selectorModel
                            |> selectedStories
                            |> List.reverse
                            |> builder.storiesToValue
                            |> builder.bloclist.views
                        )
            }
