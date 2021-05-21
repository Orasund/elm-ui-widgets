module Tooling exposing (..)

import Dict exposing (Dict)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Markdown
import SelectList exposing (SelectList)
import UiExplorer exposing (Page, PageSize)
import Widget
import Widget.Customize as Customize
import Widget.Material as Material
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


type BlocPosition
    = FullWidthBloc
    | RightColumnBloc
    | NewRightColumnBloc
    | LeftColumnBloc
    | NewLeftColumnBloc


type alias BlocView msg =
    { body : Element msg
    , position : BlocPosition
    , attributes : List (Attribute msg)
    }


mapBlocView : (a -> b) -> BlocView a -> BlocView b
mapBlocView map view =
    { body = Element.map map view.body
    , position = view.position
    , attributes = List.map (Element.mapAttribute map) view.attributes
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


type alias BlocMeta =
    { title : Maybe String }


{-| -}
type BlocBuilder model msg flags
    = BlocBuilder
        { init : flags -> ( model, Cmd msg )
        , update : msg -> model -> ( model, Cmd msg )
        , views : PageSize -> model -> List (BlocView msg)
        , subscriptions : model -> Sub msg
        , meta : List BlocMeta
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


type LayoutRow msg
    = OneColumn (List ( BlocMeta, BlocView msg ))
    | TwoColumn (List ( BlocMeta, BlocView msg )) (List ( BlocMeta, BlocView msg ))


type alias Layout msg =
    List (LayoutRow msg)


layoutAddBloc : ( BlocMeta, BlocView msg ) -> Layout msg -> Layout msg
layoutAddBloc ( meta, view ) layout =
    case view.position of
        FullWidthBloc ->
            case layout of
                (OneColumn items) :: tail ->
                    OneColumn (( meta, view ) :: items) :: tail

                _ ->
                    OneColumn [ ( meta, view ) ] :: layout

        LeftColumnBloc ->
            case layout of
                (TwoColumn left right) :: tail ->
                    TwoColumn (( meta, view ) :: left) right :: tail

                _ ->
                    TwoColumn [ ( meta, view ) ] [] :: layout

        NewLeftColumnBloc ->
            TwoColumn [ ( meta, view ) ] [] :: layout

        RightColumnBloc ->
            case layout of
                (TwoColumn left right) :: tail ->
                    TwoColumn left (( meta, view ) :: right) :: tail

                _ ->
                    TwoColumn [] [ ( meta, view ) ] :: layout

        NewRightColumnBloc ->
            TwoColumn [] [ ( meta, view ) ] :: layout


layoutBlocView : List (Attribute msg) -> ( BlocMeta, BlocView msg ) -> Element msg
layoutBlocView attributes ( meta, view ) =
    Widget.column
        (Material.cardColumn Material.defaultPalette
            |> Customize.elementColumn attributes
            |> Customize.mapContent (Customize.element <| Element.height Element.fill :: view.attributes)
        )
    <|
        List.filterMap identity
            [ meta.title
                |> Maybe.map Element.text
                |> Maybe.map (Element.el Typography.h3)
            , Just view.body
            ]


layoutRowView : LayoutRow msg -> List (Element msg)
layoutRowView row =
    case row of
        OneColumn items ->
            items
                |> List.reverse
                |> List.map (layoutBlocView [])

        TwoColumn left right ->
            Element.row
                [ Element.width Element.fill
                , Element.spacing 10
                ]
                [ Element.column
                    [ Element.width <| Element.fillPortion 2
                    , Element.height Element.fill
                    ]
                  <|
                    List.map
                        (layoutBlocView
                            [ Element.height Element.fill ]
                        )
                    <|
                        List.reverse left
                , Element.column
                    [ Element.width <| Element.fillPortion 1
                    , Element.height Element.fill
                    ]
                  <|
                    List.map
                        (layoutBlocView
                            [ Element.height Element.fill ]
                        )
                    <|
                        List.reverse right
                ]
                |> List.singleton


page : BlocBuilder model msg flags -> Page model msg flags
page (BlocBuilder config) =
    { init = config.init
    , update = config.update
    , view =
        \pagesize model ->
            config.views pagesize model
                |> List.map2 Tuple.pair config.meta
                |> List.foldl layoutAddBloc []
                |> List.reverse
                |> List.concatMap layoutRowView
                |> Element.column
                    [ Element.padding 10
                    , Element.spacing 10
                    , Element.px 800 |> Element.width
                    , Element.centerX
                    ]
    , subscriptions = config.subscriptions
    }


{-| render a markdown text into a simple panel
-}
markdown : List (Attribute ()) -> String -> Bloc () () ()
markdown attributes text =
    static attributes
        (\_ _ ->
            Markdown.toHtml [] text
                |> Element.html
        )


static : List (Attribute msg) -> (PageSize -> flags -> Element msg) -> Bloc flags msg flags
static attributes blocView =
    { init = \flags -> ( flags, Cmd.none )
    , title = Nothing
    , update = \_ m -> ( m, Cmd.none )
    , view =
        \pagesize flags ->
            { body = blocView pagesize flags
            , position = FullWidthBloc
            , attributes = attributes
            }
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
        , Background.color <| MaterialColor.fromColor <| MaterialColor.gray
        ]
    <|
        Element.el
            [ Element.centerX
            , Element.centerY
            ]
            view
