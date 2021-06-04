module Page exposing (create, viewTile)

import Element exposing (Element)
import UIExplorer exposing (Page)
import UIExplorer.Story as Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Group, Tile, TileMsg)
import Widget.Material as Material exposing (Palette)
import Widget.Material.Typography as Typography


{-| Creates a Page.

  - `title` - Should match the name of the Page
  - `description` - Should match the first paragraph of the documentation.

-}
create :
    { title : String
    , description : String
    , book : Group ( StorySelectorModel, () ) (TileMsg StorySelectorMsg ()) ()
    , demo : Tile model msg ()
    }
    -> Page ( ( ( (), () ), ( StorySelectorModel, () ) ), model ) (TileMsg (TileMsg (TileMsg () msg1) (TileMsg StorySelectorMsg ())) msg) ()
create { title, description, book, demo } =
    Tile.static []
        (\_ _ ->
            [ title |> Element.text |> Element.el Typography.h3
            , description |> Element.text |> List.singleton |> Element.paragraph []
            ]
                |> Element.column [ Element.spacing 32 ]
        )
        |> Tile.first
        |> Tile.nextGroup book
        |> Tile.next demo
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
