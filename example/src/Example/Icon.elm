module Example.Icon exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import FeatherIcons
import Widget
import Widget.Style exposing (ButtonStyle, RowStyle)
import Widget.Style.Material as Material
import Material.Icons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import Widget.Icon exposing (Icon)
import Material.Icons.Action
import Widget.Icon exposing (Icon)
import FeatherIcons
import Widget.Icon exposing (Icon)
import FontAwesome.Icon
import FontAwesome.Solid
import FontAwesome.Svg
import Widget.Icon exposing (Icon)
import Ionicon
import Widget.Icon exposing (Icon)
import Octicons
import Widget.Icon exposing (Icon)
import Heroicons.Solid
import Widget.Icon exposing (Icon)
import Ant.Icons.Svg
import Widget.Icon exposing (Icon)
import Zondicons
import Widget.Icon exposing (Icon)

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


type Model
    = ()


type Msg
    = ()


init : ( Model, Cmd Msg )
init =
    ( IsButtonEnabled True
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
view msgMapper style (IsButtonEnabled isButtonEnabled) =
    [ Material.Icons.done
      |> Widget.Icon.elmMaterialIcons Color
    , Material.Icons.Action.done
  |> Widget.Icon.materialIcons
  , FeatherIcons.check
  |> Widget.Icon.elmFeather FeatherIcons.toHtml
  , FontAwesome.Solid.check
  |> Widget.Icon.elmFontawesome FontAwesome.Svg.viewIcon
  , Ionicon.done
  |> Widget.Icon.elmIonicons
  , Octicons.check
    |> Widget.Icon.elmOcticons
      { withSize = Octicons.size
      , withColor = Octicons.color
      , defaultOptions = Octicons.defaultOptions
      }
      ,Heroicons.Solid.check
    |> Widget.Icon.elmHeroicons
    , Ant.Icons.Svg.checkOutlined
    |> Widget.Icon.antDesignIconsElm
    , Zondicons.checkmark
    |> Widget.Icon.elmZondicons
    ]
        |> List.map (\icon ->
            Widget.button style.primaryButton
              { text = "Done"
              , icon = icon
              , onPress =
                  if isButtonEnabled then
                      ChangedButtonStatus False
                          |> msgMapper
                          |> Just

                  else
                      Nothing
              }
          )
        |> Element.wrappedRow []


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
