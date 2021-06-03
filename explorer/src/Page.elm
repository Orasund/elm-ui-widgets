module Page exposing (..)

import Element
import UIExplorer exposing (Page)
import UIExplorer.Story exposing (StorySelectorModel, StorySelectorMsg)
import UIExplorer.Tile as Tile exposing (Group, Tile, TileMsg)
import Widget.Material as Material
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
            , description |> Element.text |> Element.el []
            ]
                |> Element.column [ Element.spacing 32 ]
        )
        |> Tile.first
        |> Tile.nextGroup book
        |> Tile.next demo
        |> Tile.page
