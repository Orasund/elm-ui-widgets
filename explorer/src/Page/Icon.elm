module Page.Icon exposing (page)

{-| This is an example Page. If you want to add your own pages, simple copy and modify this one.
-}

import Ant.Icons.Svg
import Element exposing (Element)
import FeatherIcons
import FontAwesome.Solid
import FontAwesome.Svg
import Heroicons.Solid
import Ionicon
import Material.Icons
import Material.Icons.Action
import Material.Icons.Types exposing (Coloring(..))
import Octicons
import Page
import UIExplorer.Tile as Tile exposing (Context, Tile)
import Widget
import Widget.Icon
import Widget.Material as Material
import Widget.Material.Typography as Typography
import Zondicons


{-| The title of this page
-}
title : String
title =
    "Icon"


{-| The description. I've taken this description directly from the [Material-UI-Specification](https://material.io/components/buttons)
-}
description : String
description =
    "Every icon package on elm-packages is supported."



{- This next section is essentially just a normal Elm program. -}
--------------------------------------------------------------------------------
-- Interactive Demonstration
--------------------------------------------------------------------------------


type alias Model =
    ()


type alias Msg =
    ()


init : ( Model, Cmd Msg )
init =
    ( ()
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        () ->
            ( ()
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : Context -> Model -> Element Msg
view { palette } () =
    [ ( Material.Icons.done
            |> Widget.Icon.elmMaterialIcons Color
      , "elm-material-icons"
      )
    , ( Material.Icons.Action.done
            |> Widget.Icon.materialIcons
      , "material-icons"
      )
    , ( FeatherIcons.check
            |> Widget.Icon.elmFeather FeatherIcons.toHtml
      , "elm-feather"
      )
    , ( FontAwesome.Solid.check
            |> Widget.Icon.elmFontawesome FontAwesome.Svg.viewIcon
      , "elm-fontawesome"
      )
    , ( Ionicon.checkmark
            |> Widget.Icon.elmIonicons
      , "elm-ionicons"
      )
    , ( Octicons.check
            |> Widget.Icon.elmOcticons
                { withSize = Octicons.size
                , withColor = Octicons.color
                , defaultOptions = Octicons.defaultOptions
                }
      , "elm-octicons"
      )
    , ( Heroicons.Solid.check
            |> Widget.Icon.elmHeroicons
      , "elm-heroicons"
      )
    , ( Ant.Icons.Svg.checkOutlined
            |> Widget.Icon.antDesignIconsElm
      , "ant-design-icons-elm"
      )
    , ( Zondicons.checkmark
            |> Widget.Icon.elmZondicons
      , "elm-zondicons"
      )
    ]
        |> List.map
            (\( icon, text ) ->
                Widget.button (Material.containedButton palette)
                    { text = text
                    , icon = icon
                    , onPress = Just ()
                    }
            )
        |> Element.wrappedRow [ Element.spacing 10 ]



--------------------------------------------------------------------------------
-- DO NOT MODIFY ANYTHING AFTER THIS LINE
--------------------------------------------------------------------------------


demo : Tile Model Msg ()
demo =
    { init = always init
    , update = update
    , view = Page.demo view
    , subscriptions = subscriptions
    }


page =
    Tile.static []
        (\_ _ ->
            [ title |> Element.text |> Element.el Typography.h3
            , description |> Element.text |> List.singleton |> Element.paragraph []
            ]
                |> Element.column [ Element.spacing 32 ]
        )
        |> Tile.first
        |> Tile.next demo
        |> Tile.page
