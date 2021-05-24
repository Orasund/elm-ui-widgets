module UIExplorer.Tile exposing (..)

import Dict exposing (Dict)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Font as Font
import Markdown
import SelectList exposing (SelectList)
import UIExplorer exposing (Page, PageSize)
import Widget
import Widget.Customize as Customize
import Widget.Material as Material
import Widget.Material.Color as MaterialColor
import Widget.Material.Typography as Typography


type Position
    = FullWidthTile
    | RightColumnTile
    | NewRightColumnTile
    | LeftColumnTile
    | NewLeftColumnTile


type alias View msg =
    { title : Maybe String
    , position : Position
    , attributes : List (Attribute msg)
    , body : Element msg
    }


mapView : (a -> b) -> View a -> View b
mapView map view =
    { title = view.title
    , position = view.position
    , attributes = List.map (Element.mapAttribute map) view.attributes
    , body = Element.map map view.body
    }


mapViewList : (a -> b) -> List (View a) -> List (View b)
mapViewList map =
    List.map (mapView map)


type alias Tile model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , view : PageSize -> model -> View msg
    , subscriptions : model -> Sub msg
    }


type alias Group model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , views : PageSize -> model -> List (View msg)
    , subscriptions : model -> Sub msg
    }


type alias LinkedGroup sharedModel model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> ( sharedModel, model ) -> ( model, Cmd msg )
    , views : PageSize -> ( sharedModel, model ) -> List (View msg)
    , subscriptions : ( sharedModel, model ) -> Sub msg
    }


linkGroup :
    LinkedGroup sharedModel model msg flags
    -> Group sharedModel upMsg flags
    -> Group ( sharedModel, model ) (TileMsg upMsg msg) flags
linkGroup linked parent =
    let
        init_ : flags -> ( ( sharedModel, model ), Cmd (TileMsg upMsg msg) )
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

        subscriptions_ ( sharedModel, model ) =
            Sub.batch
                [ Sub.map Current (linked.subscriptions ( sharedModel, model ))
                , Sub.map Previous (parent.subscriptions sharedModel)
                ]

        views_ pageSize ( sharedModel, model ) =
            List.append
                (parent.views pageSize sharedModel |> mapViewList Previous)
                (linked.views pageSize ( sharedModel, model ) |> mapViewList Current)
    in
    { init = init_
    , update = update_
    , views = views_
    , subscriptions = subscriptions_
    }


groupSingleton : Tile model msg flags -> Group model msg flags
groupSingleton tile =
    { init = tile.init
    , update = tile.update
    , views =
        \pagesize model ->
            List.singleton <| tile.view pagesize model
    , subscriptions = tile.subscriptions
    }


{-| -}
type Builder model msg flags
    = Builder
        { init : flags -> ( model, Cmd msg )
        , update : msg -> model -> ( model, Cmd msg )
        , views : PageSize -> model -> List (View msg)
        , subscriptions : model -> Sub msg
        }


type TileMsg previous current
    = Previous previous
    | Current current


firstGroup : Group model msg flags -> Builder ( (), model ) (TileMsg () msg) flags
firstGroup config =
    Builder
        { init = always ( (), Cmd.none )
        , update = \_ m -> ( m, Cmd.none )
        , views =
            \_ _ ->
                []
        , subscriptions = always Sub.none
        }
        |> nextGroup config


first : Tile model msg flags -> Builder ( (), model ) (TileMsg () msg) flags
first =
    groupSingleton >> firstGroup


next :
    Tile model msg flags
    -> Builder modelPrevious msgPrevious flags
    -> Builder ( modelPrevious, model ) (TileMsg msgPrevious msg) flags
next =
    groupSingleton >> nextGroup


nextGroup :
    Group model msg flags
    -> Builder modelPrevious msgPrevious flags
    -> Builder ( modelPrevious, model ) (TileMsg msgPrevious msg) flags
nextGroup config (Builder previous) =
    let
        init_ : flags -> ( ( modelPrevious, model ), Cmd (TileMsg msgPrevious msg) )
        init_ flags =
            let
                ( previousModel, previousCmds ) =
                    previous.init flags

                ( model, cmds ) =
                    config.init flags
            in
            ( ( previousModel, model ), Cmd.batch [ Cmd.map Previous previousCmds, Cmd.map Current cmds ] )

        update_ :
            TileMsg msgPrevious msg
            -> ( modelPrevious, model )
            -> ( ( modelPrevious, model ), Cmd (TileMsg msgPrevious msg) )
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

        views_ : PageSize -> ( modelPrevious, model ) -> List (View (TileMsg msgPrevious msg))
        views_ windowSize ( previousModel, model ) =
            List.append
                (previous.views windowSize previousModel |> mapViewList Previous)
                (config.views windowSize model |> mapViewList Current)

        subscriptions_ ( previousModel, model ) =
            Sub.batch
                [ Sub.map Current (config.subscriptions model)
                , Sub.map Previous (previous.subscriptions previousModel)
                ]
    in
    Builder
        { init = init_
        , update = update_
        , views = views_
        , subscriptions = subscriptions_
        }


type LayoutRow msg
    = OneColumn (List (View msg))
    | TwoColumn (List (View msg)) (List (View msg))


type alias Layout msg =
    List (LayoutRow msg)


layoutAddTile : View msg -> Layout msg -> Layout msg
layoutAddTile view layout =
    case view.position of
        FullWidthTile ->
            case layout of
                (OneColumn items) :: tail ->
                    OneColumn (view :: items) :: tail

                _ ->
                    OneColumn [ view ] :: layout

        LeftColumnTile ->
            case layout of
                (TwoColumn left right) :: tail ->
                    TwoColumn (view :: left) right :: tail

                _ ->
                    TwoColumn [ view ] [] :: layout

        NewLeftColumnTile ->
            TwoColumn [ view ] [] :: layout

        RightColumnTile ->
            case layout of
                (TwoColumn left right) :: tail ->
                    TwoColumn left (view :: right) :: tail

                _ ->
                    TwoColumn [] [ view ] :: layout

        NewRightColumnTile ->
            TwoColumn [] [ view ] :: layout


layoutView : Material.Palette -> List (Attribute msg) -> View msg -> Element msg
layoutView palette attributes view =
    Widget.column
        (Material.cardColumn palette
            |> Customize.elementColumn attributes
            |> Customize.mapContent (Customize.element <| Element.height Element.fill :: view.attributes)
        )
    <|
        List.filterMap identity
            [ view.title
                |> Maybe.map Element.text
                |> Maybe.map (Element.el Typography.h3)
            , Just view.body
            ]


layoutRowView : Material.Palette -> LayoutRow msg -> List (Element msg)
layoutRowView palette row =
    case row of
        OneColumn items ->
            items
                |> List.reverse
                |> List.map (layoutView palette [])

        TwoColumn left right ->
            Element.row
                [ Element.width Element.fill
                , Element.spacing 10
                ]
                [ Element.column
                    [ Element.width <| Element.fillPortion 2
                    , Element.height Element.fill
                    , Element.spacing 10
                    ]
                  <|
                    List.map
                        (layoutView palette
                            [ Element.height Element.fill ]
                        )
                    <|
                        List.reverse left
                , Element.column
                    [ Element.width <| Element.fillPortion 1
                    , Element.height Element.fill
                    , Element.spacing 10
                    ]
                  <|
                    List.map
                        (layoutView palette
                            [ Element.height Element.fill ]
                        )
                    <|
                        List.reverse right
                ]
                |> List.singleton


page : Builder model msg flags -> Page model msg flags
page (Builder config) =
    { init = config.init
    , update = config.update
    , view =
        \pagesize dark model ->
            let
                palette =
                    if dark then
                        Material.darkPalette

                    else
                        Material.defaultPalette
            in
            config.views pagesize model
                |> List.foldl layoutAddTile []
                |> List.reverse
                |> List.concatMap (layoutRowView palette)
                |> Element.column
                    ([ Element.padding 10
                     , Element.spacing 10
                     , Element.px 800 |> Element.width
                     , Element.centerX
                     , Font.family
                        [ Font.typeface "Roboto"
                        , Font.sansSerif
                        ]
                     , Font.size 16
                     , Font.letterSpacing 0.5
                     ]
                        ++ (palette.background |> MaterialColor.textAndBackground)
                    )
    , subscriptions = config.subscriptions
    }


{-| render a markdown text into a simple panel
-}
markdown : List (Attribute ()) -> String -> Tile () () ()
markdown attributes text =
    static attributes
        (\_ _ ->
            Markdown.toHtml [] text
                |> Element.html
        )


static : List (Attribute msg) -> (PageSize -> flags -> Element msg) -> Tile flags msg flags
static attributes tileView =
    { init = \flags -> ( flags, Cmd.none )
    , update = \_ m -> ( m, Cmd.none )
    , view =
        \pagesize flags ->
            { title = Nothing
            , body = tileView pagesize flags
            , position = FullWidthTile
            , attributes = attributes
            }
    , subscriptions = \_ -> Sub.none
    }


withTitle : String -> Tile model msg flags -> Tile model msg flags
withTitle title tile =
    let
        settitle t v =
            { v | title = Just t }
    in
    { tile
        | view =
            \pagesize flags ->
                tile.view pagesize flags |> settitle title
    }


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


sourceCode : String -> Element msg
sourceCode code =
    ("```\n" ++ code ++ "\n```")
        |> Markdown.toHtml []
        |> Element.html
