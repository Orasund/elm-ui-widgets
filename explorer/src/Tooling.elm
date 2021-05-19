module Tooling exposing (..)

import Dict exposing (Dict)
import Element exposing (Element)
import Markdown
import SelectList exposing (SelectList)
import UiExplorer exposing (Page, PageSize)
import Widget
import Widget.Material as Material
import Widget.Material.Typography as Typography


type alias BlocView msg =
    { body : Element msg
    , sidebloc : Bool
    }


mapBlocView : (a -> b) -> BlocView a -> BlocView b
mapBlocView map view =
    { body = Element.map map view.body
    , sidebloc = view.sidebloc
    }


mapBlocViewList : (a -> b) -> List (BlocView a) -> List (BlocView b)
mapBlocViewList map =
    List.map (mapBlocView map)


type alias Bloc model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , title : Maybe String
    , view : PageSize -> model -> BlocView msg
    , subscriptions : model -> Sub msg
    }


type alias BlocList model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , titles : List (Maybe String)
    , views : PageSize -> model -> List (BlocView msg)
    , subscriptions : model -> Sub msg
    }


type alias LinkedBlockList sharedModel model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> ( sharedModel, model ) -> ( model, Cmd msg )
    , titles : List (Maybe String)
    , views : PageSize -> ( sharedModel, model ) -> List (BlocView msg)
    , subscriptions : ( sharedModel, model ) -> Sub msg
    }


linkBlocList :
    LinkedBlockList sharedModel model msg flags
    -> BlocList sharedModel upMsg flags
    -> BlocList ( sharedModel, model ) (BlocMsg upMsg msg) flags
linkBlocList linked parent =
    let
        init_ : flags -> ( ( sharedModel, model ), Cmd (BlocMsg upMsg msg) )
        init_ flags =
            let
                ( parentModel, parentCmd ) =
                    parent.init flags

                ( model, cmd ) =
                    linked.init flags
            in
            ( ( parentModel, model ), Cmd.batch [ Cmd.map Previous parentCmd, Cmd.map Current cmd ] )

        update_ msg ( sharedModel, model ) =
            case msg of
                Previous parentMsg ->
                    let
                        ( newParentModel, parentCmd ) =
                            parent.update parentMsg sharedModel
                    in
                    ( ( newParentModel, model ), Cmd.map Previous parentCmd )

                Current currentMsg ->
                    let
                        ( newModel, cmd ) =
                            linked.update currentMsg ( sharedModel, model )
                    in
                    ( ( sharedModel, newModel ), Cmd.map Current cmd )

        titles_ =
            List.append parent.titles linked.titles

        subscriptions_ ( sharedModel, model ) =
            Sub.batch
                [ Sub.map Current (linked.subscriptions ( sharedModel, model ))
                , Sub.map Previous (parent.subscriptions sharedModel)
                ]

        views_ pageSize ( sharedModel, model ) =
            List.append
                (parent.views pageSize sharedModel |> mapBlocViewList Previous)
                (linked.views pageSize ( sharedModel, model ) |> mapBlocViewList Current)
    in
    { init = init_
    , update = update_
    , titles = titles_
    , views = views_
    , subscriptions = subscriptions_
    }



-- addLinkedBlocList :
-- LinkedBlockList sharedModel model msg flags
-- -> BlocList ( sharedModel, previousModel ) upMsg flags
-- -> BlocList ( sharedModel, ( model, previousModel ) ) (BlocMsg upMsg msg) flags


blocListSingleton : Bloc model msg flags -> BlocList model msg flags
blocListSingleton bloc =
    { init = bloc.init
    , update = bloc.update
    , titles = List.singleton bloc.title
    , views =
        \pagesize model ->
            List.singleton <| bloc.view pagesize model
    , subscriptions = bloc.subscriptions
    }


{-| -}
type BlocBuilder model msg flags
    = BlocBuilder
        { init : flags -> ( model, Cmd msg )
        , update : msg -> model -> ( model, Cmd msg )
        , views : PageSize -> model -> List (BlocView msg)
        , subscriptions : model -> Sub msg
        , meta : List { title : Maybe String }
        }


type BlocMsg previous current
    = Previous previous
    | Current current


firstBloc : Bloc model msg flags -> BlocBuilder ( (), model ) (BlocMsg () msg) flags
firstBloc config =
    BlocBuilder
        { init = always ( (), Cmd.none )
        , update = \_ m -> ( m, Cmd.none )
        , views =
            \_ _ ->
                []
        , subscriptions = always Sub.none
        , meta = []
        }
        |> nextBloc config


nextBloc :
    Bloc model msg flags
    -> BlocBuilder modelPrevious msgPrevious flags
    -> BlocBuilder ( modelPrevious, model ) (BlocMsg msgPrevious msg) flags
nextBloc =
    blocListSingleton >> nextBlocList


nextBlocList :
    BlocList model msg flags
    -> BlocBuilder modelPrevious msgPrevious flags
    -> BlocBuilder ( modelPrevious, model ) (BlocMsg msgPrevious msg) flags
nextBlocList config (BlocBuilder previous) =
    let
        init_ : flags -> ( ( modelPrevious, model ), Cmd (BlocMsg msgPrevious msg) )
        init_ flags =
            let
                ( previousModel, previousCmds ) =
                    previous.init flags

                ( model, cmds ) =
                    config.init flags
            in
            ( ( previousModel, model ), Cmd.batch [ Cmd.map Previous previousCmds, Cmd.map Current cmds ] )

        update_ :
            BlocMsg msgPrevious msg
            -> ( modelPrevious, model )
            -> ( ( modelPrevious, model ), Cmd (BlocMsg msgPrevious msg) )
        update_ msg ( previousModel, model ) =
            case msg of
                Previous previousMsg ->
                    let
                        ( newPreviousModel, previousCmds ) =
                            previous.update previousMsg previousModel
                    in
                    ( ( newPreviousModel, model ), Cmd.map Previous previousCmds )

                Current currentMsg ->
                    let
                        ( newModel, cmds ) =
                            config.update currentMsg model
                    in
                    ( ( previousModel, newModel ), Cmd.map Current cmds )

        views_ : PageSize -> ( modelPrevious, model ) -> List (BlocView (BlocMsg msgPrevious msg))
        views_ windowSize ( previousModel, model ) =
            List.append
                (previous.views windowSize previousModel |> mapBlocViewList Previous)
                (config.views windowSize model |> mapBlocViewList Current)

        subscriptions_ ( previousModel, model ) =
            Sub.batch
                [ Sub.map Current (config.subscriptions model)
                , Sub.map Previous (previous.subscriptions previousModel)
                ]
    in
    BlocBuilder
        { init = init_
        , update = update_
        , views = views_
        , subscriptions = subscriptions_
        , meta =
            List.append
                previous.meta
                (List.map (\title -> { title = title }) config.titles)
        }


page : BlocBuilder model msg flags -> Page model msg flags
page (BlocBuilder config) =
    { init = config.init
    , update = config.update
    , view =
        \pagesize model ->
            let
                ( sideblocs, blocs ) =
                    config.views pagesize model
                        |> List.map2
                            (\meta view ->
                                ( view.sidebloc
                                , Widget.column (Material.cardColumn Material.defaultPalette) <|
                                    List.filterMap identity
                                        [ meta.title
                                            |> Maybe.map Element.text
                                            |> Maybe.map (Element.el Typography.h3)
                                        , Just view.body
                                        ]
                                )
                            )
                            config.meta
                        |> List.partition Tuple.first
                        |> Tuple.mapBoth (List.map Tuple.second) (List.map Tuple.second)
            in
            Element.row
                [ Element.width Element.shrink
                , Element.centerX
                , Element.spacing 10
                ]
                [ Element.column
                    [ Element.padding 10
                    , Element.spacing 10
                    , Element.px 800 |> Element.width
                    ]
                    blocs
                , Element.column
                    [ Element.padding 10
                    , Element.spacing 10
                    , Element.px 400 |> Element.width
                    ]
                    sideblocs
                ]
    , subscriptions = config.subscriptions
    }


{-| render a markdown text into a simple panel
-}
markdown : String -> Bloc () () ()
markdown text =
    static
        (\_ _ ->
            Markdown.toHtml [] text
                |> Element.html
        )


static : (PageSize -> flags -> Element msg) -> Bloc flags msg flags
static blocView =
    { init = \flags -> ( flags, Cmd.none )
    , title = Nothing
    , update = \_ m -> ( m, Cmd.none )
    , view = \pagesize flags -> { body = blocView pagesize flags, sidebloc = False }
    , subscriptions = \_ -> Sub.none
    }


withBlocTitle : String -> Bloc model msg flags -> Bloc model msg flags
withBlocTitle title bloc =
    { bloc | title = Just title }


canvas : Element msg -> Element msg
canvas view =
    Element.el
        [ Element.padding 30
        , Element.width Element.fill
        ]
    <|
        Element.el
            [ Element.centerX
            , Element.width Element.shrink
            ]
            view


assidebloc : Bloc model msg flags -> Bloc model msg flags
assidebloc bloc =
    { bloc
        | view =
            \pagesize model ->
                let
                    sidebloc =
                        bloc.view pagesize model
                in
                { sidebloc | sidebloc = True }
    }
