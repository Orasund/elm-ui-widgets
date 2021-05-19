module Story exposing (..)

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Input exposing (Label, Option, labelAbove, option, radio)
import SelectList exposing (SelectList)
import Tooling
import UiExplorer exposing (PageSize)


type alias Story a =
    { label : String
    , options : List ( String, a )
    }


type alias BlocList view model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , titles : List (Maybe String)
    , views : List (List ( List String, view ))
    , subscriptions : model -> Sub msg
    }


type alias BookBuilder view model msg flags =
    { title : Maybe String
    , stories : List ( String, List String )
    , bloclist : BlocList view model msg flags
    }


book :
    Maybe String
    -> BlocList view model msg flags
    -> BookBuilder view model msg flags
book title bloclist =
    { title = title
    , stories = []
    , bloclist = bloclist
    }


addStory : Story a -> BookBuilder (a -> view) model msg flags -> BookBuilder view model msg flags
addStory story builder =
    { title = builder.title
    , stories =
        ( story.label
        , story.options |> List.map Tuple.first
        )
            :: builder.stories
    , bloclist =
        builder.bloclist
            |> addStoryToBlocList story
    }


addStoryToBlocList :
    Story a
    -> BlocList (a -> view) model msg flags
    -> BlocList view model msg flags
addStoryToBlocList story bloclist =
    { init = bloclist.init
    , update = bloclist.update
    , titles = bloclist.titles
    , views =
        List.map
            (List.concatMap
                (\( id, view ) ->
                    List.map
                        (\( name, a ) ->
                            ( name :: id, view a )
                        )
                        story.options
                )
            )
            bloclist.views
    , subscriptions = bloclist.subscriptions
    }


static : view -> BlocList view flags msg flags
static blocView =
    { init = \flags -> ( flags, Cmd.none )
    , titles = [ Nothing ]
    , update = \_ m -> ( m, Cmd.none )
    , views = [ [ ( [], blocView ) ] ]
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
        , views = List.append bloclist.views [ [ ( [], view ) ] ]
    }


type alias StorySelectorModel =
    List ( String, SelectList String )


selectedStory : StorySelectorModel -> String
selectedStory =
    List.map
        (Tuple.second >> SelectList.selected)
        >> String.join "/"


selectStory : String -> String -> StorySelectorModel -> StorySelectorModel
selectStory story value =
    List.map
        (\( label, options ) ->
            if label == story then
                ( label
                , options
                    |> SelectList.attempt (SelectList.selectBeforeIf <| (==) value)
                    |> SelectList.attempt (SelectList.selectAfterIf <| (==) value)
                )

            else
                ( label, options )
        )


type StorySelectorMsg
    = StorySelect String String


storyHelp : ( String, List String ) -> Maybe ( String, SelectList String )
storyHelp ( label, options ) =
    SelectList.fromList options
        |> Maybe.map (Tuple.pair label)


storyBloc : Maybe String -> List ( String, List String ) -> Tooling.BlocList StorySelectorModel StorySelectorMsg flags
storyBloc title stories =
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
                        |> List.map
                            (\( label, options ) ->
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
                            )
                        |> Element.column []
              }
            ]
    }


build :
    BookBuilder (PageSize -> model -> Element msg) model msg flags
    -> Tooling.BlocList ( StorySelectorModel, model ) (Tooling.BlocMsg StorySelectorMsg msg) flags
build builder =
    let
        views : List (Dict String (PageSize -> model -> Element msg))
        views =
            builder.bloclist.views
                |> List.map
                    (List.map
                        (\( id, view ) ->
                            ( String.join "/" (id |> List.reverse), view )
                        )
                        >> Dict.fromList
                    )
    in
    storyBloc builder.title builder.stories
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
                        (\viewsDict ->
                            { sidebloc = False
                            , body =
                                (Dict.get (selectedStory selectorModel) viewsDict
                                    |> Maybe.withDefault (\_ _ -> Element.none)
                                )
                                    pagesize
                                    model
                            }
                        )
                        views
            }
