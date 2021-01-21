module Example.Icon exposing (Model, Msg, init, subscriptions, update, view)

import Ant.Icons.Svg
import Browser
import Element exposing (Element)
import FeatherIcons
import FontAwesome.Icon
import FontAwesome.Solid
import FontAwesome.Svg
import Heroicons.Solid
import Ionicon
import Material.Icons exposing (offline_bolt)
import Material.Icons.Action
import Material.Icons.Types exposing (Coloring(..))
import Octicons
import Widget
import Widget.Icon exposing (Icon)
import Widget.Style exposing (ButtonStyle, RowStyle)
import Widget.Style.Material as Material
import Zondicons


type alias Style style msg =
    { style
        | primaryButton : ButtonStyle msg
        , button : ButtonStyle msg
        , row : RowStyle msg
    }


materialStyle : Style {} msg
materialStyle =
    { primaryButton = Material.containedButton Material.defaultPalette
    , button = Material.outlinedButton Material.defaultPalette
    , row = Material.row
    }


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
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style () =
    [ "Every icon package on elm-packages is supported."
        |> Element.text
        |> List.singleton
        |> Element.paragraph []
    , [ Material.Icons.done
            |> Widget.Icon.elmMaterialIcons Color
      , Material.Icons.Action.done
            |> Widget.Icon.materialIcons
      , FeatherIcons.check
            |> Widget.Icon.elmFeather FeatherIcons.toHtml
      , FontAwesome.Solid.check
            |> Widget.Icon.elmFontawesome FontAwesome.Svg.viewIcon
      , Ionicon.checkmark
            |> Widget.Icon.elmIonicons
      , Octicons.check
            |> Widget.Icon.elmOcticons
                { withSize = Octicons.size
                , withColor = Octicons.color
                , defaultOptions = Octicons.defaultOptions
                }
      , Heroicons.Solid.check
            |> Widget.Icon.elmHeroicons
      , Ant.Icons.Svg.checkOutlined
            |> Widget.Icon.antDesignIconsElm
      , Zondicons.checkmark
            |> Widget.Icon.elmZondicons
      ]
        |> List.map
            (\icon ->
                Widget.button style.primaryButton
                    { text = "Done"
                    , icon = icon
                    , onPress = Just <| msgMapper <| ()
                    }
            )
        |> Element.wrappedRow [ Element.spacing 10 ]
    ]
        |> Element.column [ Element.spacing 10 ]


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
