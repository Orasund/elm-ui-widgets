module Page exposing (create, demo, viewTile)

import Element exposing (Element)
import UIExplorer exposing (Page)
import UIExplorer.Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Context, Group, Position, Tile, TileMsg)
import Widget.Material.Typography as Typography


{-| Creates a Page.

  - `title` - Should match the name of the Page
  - `description` - Should match the first paragraph of the documentation.

-}
create :
    { title : String
    , description : String
    , book : Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) flags
    , demo : Tile model msg flags
    }
    -> Page ( ( ( (), () ), model ), ( StorySelectorModel, () ) ) (TileMsg (TileMsg (TileMsg () msg1) msg) (TileMsg StorySelectorMsg ())) flags
create config =
    Tile.static []
        (\_ _ ->
            [ config.title |> Element.text |> Element.el Typography.h3
            , config.description |> Element.text |> List.singleton |> Element.paragraph []
            ]
                |> Element.column [ Element.spacing 32 ]
        )
        |> Tile.first
        |> Tile.next config.demo
        |> Tile.nextGroup config.book
        |> Tile.page


viewTile :
    String
    -> Element msg
    ->
        { attributes : List (Element.Attribute msg)
        , body : Element msg
        , position : Tile.Position
        , title : Maybe String
        }
viewTile title content =
    { title = Nothing
    , position = Tile.LeftColumnTile
    , attributes = []
    , body =
        Element.column
            [ Element.width Element.fill
            , Element.spacing 8
            ]
            [ title
                |> Element.text
                |> Element.el Typography.caption
            , content
            ]
    }


demo :
    (Context -> model -> Element msg)
    ->
        (Context
         -> model
         -> { title : Maybe String, position : Position, attributes : List b, body : Element msg }
        )
demo fun context model =
    fun context model
        |> (\body ->
                { title = Just "Interactive Demo"
                , position = Tile.FullWidthTile
                , attributes = []
                , body = body
                }
           )
