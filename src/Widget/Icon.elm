module Widget.Icon exposing (Icon, antDesignIconsElm, elmFeather, elmFontawesome, elmHeroicons, elmIonicons, elmMaterialIcons, elmOcticons, elmZondicons, materialIcons)

import Color exposing (Color)
import Dict exposing (size)
import Element exposing (Element)
import Html exposing (Html)
import Svg exposing (Svg)
import Svg.Attributes


type alias Icon =
    { size : Int
    , color : Color
    }
    -> Element Never


{-| For using [icidasset/elm-material-icons](https://dark.elm.dmy.fr/packages/icidasset/elm-material-icons/latest/)

```
import Material.Icons exposing (offline_bolt)
import Material.Icons.Types exposing (Coloring(..))
import Widget.Icon exposing (Icon)

check : Widget.Icon
check =
  Material.Icons.done
  |> Widget.Icon.elmMaterialIcons Color
```

-}
elmMaterialIcons : (Color -> coloring) -> (Int -> coloring -> Html Never) -> Icon
elmMaterialIcons wrapper fun =
    \{ size, color } ->
        fun size (wrapper color)
            |> Element.html
            |> Element.el []


{-| For using [danmarcab/material-icons](https://dark.elm.dmy.fr/packages/danmarcab/material-icons/latest/)

```
import Material.Icons.Action
import Widget.Icon exposing (Icon)

check : Widget.Icon
check =
  Material.Icons.Action.done
  |> Widget.Icon.materialIcons
```

-}
materialIcons : (Color -> Int -> Svg Never) -> Icon
materialIcons fun =
    \{ size, color } ->
        fun color size
            |> List.singleton
            |> Svg.svg
                [ Svg.Attributes.width <| String.fromInt size
                , Svg.Attributes.height <| String.fromInt size
                ]
            |> Element.html
            |> Element.el []


{-| For using [feathericons/elm-feather](https://dark.elm.dmy.fr/packages/feathericons/elm-feather/latest/)

```
import FeatherIcons
import Widget.Icon exposing (Icon)

check : Widget.Icon
check =
  FeatherIcons.check
  |> Widget.Icon.elmFeather FeatherIcons.toHtml
```

-}
elmFeather : (List (Svg.Attribute Never) -> icon -> Html Never) -> icon -> Icon
elmFeather fun icon =
    \{ size, color } ->
        icon
            |> fun
                [ Svg.Attributes.width <| String.fromInt size
                , Svg.Attributes.height <| String.fromInt size
                , Svg.Attributes.stroke <| Color.toCssString color
                ]
            |> Element.html
            |> Element.el []


{-| For using [lattyware/elm-fontawesome](https://dark.elm.dmy.fr/packages/lattyware/elm-fontawesome/latest)

```
import FontAwesome.Icon
import FontAwesome.Solid
import FontAwesome.Svg
import Widget.Icon exposing (Icon)

check : Widget.Icon
check =
  FontAwesome.Solid.check
  |> Widget.Icon.elmFontawesome FontAwesome.Svg.viewIcon
```

-}
elmFontawesome : (icon -> Svg Never) -> icon -> Icon
elmFontawesome fun icon =
    \{ size, color } ->
        icon
            |> fun
            |> List.singleton
            |> Svg.svg
                [ Svg.Attributes.width <| String.fromInt size
                , Svg.Attributes.height <| String.fromInt size
                , Svg.Attributes.stroke <| Color.toCssString color
                , Svg.Attributes.viewBox ("0 0 " ++ String.fromInt 512 ++ " " ++ String.fromInt 512)
                ]
            |> Element.html
            |> Element.el []


{-| For using [j-panasiuk/elm-ionicons](https://dark.elm.dmy.fr/packages/j-panasiuk/elm-ionicons/latest/)

```
import Ionicon
import Widget.Icon exposing (Icon)

check : Widget.Icon
check =
  Ionicon.checkmark
  |> Widget.Icon.elmIonicons
```

-}
elmIonicons :
    (Int
     ->
        { red : Float
        , green : Float
        , blue : Float
        , alpha : Float
        }
     -> Html Never
    )
    -> Icon
elmIonicons fun =
    \{ size, color } ->
        fun size (Color.toRgba color)
            |> Element.html
            |> Element.el []


{-| For using [capitalist/elm-octicons](https://dark.elm.dmy.fr/packages/capitalist/elm-octicons/latest)

```
import Octicons
import Widget.Icon exposing (Icon)

check : Widget.Icon
check =
  Octicons.check
    |> Widget.Icon.elmOcticons
      { withSize = Octicons.size
      , withColor = Octicons.color
      , defaultOptions = Octicons.defaultOptions
      }
```

-}
elmOcticons :
    { withSize : Int -> options -> options
    , withColor : String -> options -> options
    , defaultOptions : options
    }
    -> (options -> Html Never)
    -> Icon
elmOcticons { withSize, withColor, defaultOptions } fun =
    \{ size, color } ->
        (defaultOptions
            |> withSize size
            |> withColor (Color.toCssString color)
        )
            |> fun
            |> Element.html
            |> Element.el []


{-| For using [jasonliang-dev/elm-heroicons](https://dark.elm.dmy.fr/packages/jasonliang-dev/elm-heroicons/latest)

```
import Heroicons.Solid
import Widget.Icon exposing (Icon)

check : Widget.Icon
check =
  Heroicons.Solid.check
    |> Widget.Icon.elmHeroicons
```

-}
elmHeroicons : (List (Svg.Attribute Never) -> Html Never) -> Icon
elmHeroicons fun =
    \{ size, color } ->
        fun
            [ Svg.Attributes.width <| String.fromInt size
            , Svg.Attributes.height <| String.fromInt size
            , Svg.Attributes.stroke <| Color.toCssString color
            ]
            |> Element.html
            |> Element.el []


{-| For using [lemol/ant-design-icons-elm](https://dark.elm.dmy.fr/packages/lemol/ant-design-icons-elm/latest)

```
import Ant.Icons.Svg
import Widget.Icon exposing (Icon)

check : Widget.Icon
check =
  Ant.Icons.Svg.checkOutlined
    |> Widget.Icon.antDesignIconsElm
```

-}
antDesignIconsElm : (List (Svg.Attribute Never) -> Html Never) -> Icon
antDesignIconsElm fun =
    \{ size, color } ->
        fun
            [ Svg.Attributes.width <| String.fromInt size
            , Svg.Attributes.height <| String.fromInt size
            , Svg.Attributes.fill <| Color.toCssString color
            ]
            |> Element.html
            |> Element.el []


{-| For using [pehota/elm-zondicons](https://dark.elm.dmy.fr/packages/pehota/elm-zondicons/latest)

```
import Zondicons
import Widget.Icon exposing (Icon)

check : Widget.Icon
check =
  Zondicons.checkmark
    |> Widget.Icon.elmZondicons
```

-}
elmZondicons : (List (Svg.Attribute Never) -> Html Never) -> Icon
elmZondicons fun =
    \{ size, color } ->
        fun
            [ Svg.Attributes.width <| String.fromInt size
            , Svg.Attributes.height <| String.fromInt size
            , Svg.Attributes.stroke <| Color.toCssString color
            ]
            |> Element.html
            |> Element.el []
