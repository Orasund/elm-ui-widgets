module StoryTileWithSource exposing (..)

import Element exposing (Attribute, Element)
import Element.Font as Font
import Html
import Material.Icons as MaterialIcons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import Parser
import Set exposing (Set)
import SyntaxHighlight
import UIExplorer.Story as Story
import UIExplorer.Tile as Tile exposing (Context)
import Widget
import Widget.Icon as Icon exposing (Icon)
import Widget.Material as Material


css =
    """pre.elmsh {
    padding: 10px;
    margin: 0;
    text-align: left;
    overflow: auto;
    line-height: normal;
}
.elmsh {
    padding: 0;
}
.elmsh-line:before {
    content: attr(data-elmsh-lc);
    display: inline-block;
    text-align: right;
    width: 40px;
    padding: 0 20px 0 0;
    opacity: 0.3;
}"""


type alias Model =
    { expanded : Set Int }


type Msg
    = Noop
    | Toggle Int Bool


type alias Group view =
    Story.Group view Model Msg ()


type alias View =
    { title : Maybe String
    , position : Tile.Position
    , attributes : List (Attribute Msg)
    , demo : Element Msg
    , source : String
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        Toggle index expanded ->
            ( { model
                | expanded =
                    if expanded then
                        Set.insert index model.expanded

                    else
                        Set.remove index model.expanded
              }
            , Cmd.none
            )


init : Group view
init =
    { init = always ( { expanded = Set.empty }, Cmd.none )
    , update = update
    , views = []
    , subscriptions = always Sub.none
    }


addTile : view -> Group view -> Group view
addTile =
    Story.addTile


build :
    Story.BookBuilder (Context -> Model -> View) Model Msg flags a
    -> Tile.Group ( Story.StorySelectorModel, Model ) (Tile.TileMsg Story.StorySelectorMsg Msg) flags
build builder =
    let
        tilelist =
            builder.tilelist
    in
    Story.build
        { title = builder.title
        , stories = builder.stories
        , storiesToValue = builder.storiesToValue
        , tilelist =
            { init = builder.tilelist.init
            , update = builder.tilelist.update
            , subscriptions = builder.tilelist.subscriptions
            , views =
                \a ->
                    tilelist.views a
                        |> List.indexedMap
                            (\viewIndex view ->
                                \context model ->
                                    let
                                        v =
                                            view context model
                                    in
                                    { title = v.title
                                    , position = v.position
                                    , attributes =
                                        Element.width Element.fill :: v.attributes
                                    , body =
                                        Widget.itemList Material.column <|
                                            Widget.asItem v.demo
                                                :: Widget.expansionItem
                                                    (Material.expansionItem context.palette)
                                                    { icon =
                                                        MaterialIcons.code
                                                            |> Icon.elmMaterialIcons Color
                                                    , text = "view source"
                                                    , onToggle = Toggle viewIndex
                                                    , isExpanded = Set.member viewIndex model.expanded
                                                    , content =
                                                        [ Widget.asItem <|
                                                            case
                                                                v.source
                                                                    |> SyntaxHighlight.elm
                                                            of
                                                                Ok hcode ->
                                                                    Html.div []
                                                                        [ Html.node "style" [] [ Html.text css ]
                                                                        , SyntaxHighlight.useTheme
                                                                            SyntaxHighlight.monokai
                                                                        , hcode
                                                                            |> Debug.log "parsed"
                                                                            |> (SyntaxHighlight.toBlockHtml <|
                                                                                    Just 1
                                                                               )
                                                                        ]
                                                                        |> Element.html
                                                                        |> Element.el
                                                                            [ Element.width Element.fill
                                                                            , Font.size 11
                                                                            , Element.scrollbarX
                                                                            , Element.clipX
                                                                            ]

                                                                Err err ->
                                                                    Parser.deadEndsToString err
                                                                        |> Element.text
                                                        ]
                                                    }
                                    }
                            )
            }
        }
