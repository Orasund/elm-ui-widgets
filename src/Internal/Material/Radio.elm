module Internal.Material.Radio exposing (radio)

import Color
import Element exposing (Attribute, Decoration)
import Element.Background as Background
import Element.Border as Border
import Internal.Material.Palette as Palette exposing (Palette)
import Internal.Radio exposing (RadioStyle)
import Widget.Material.Color as MaterialColor


radio : Palette -> RadioStyle msg
radio palette =
    let
        rounded : Float -> Color.Color -> List Decoration
        rounded opacity color =
            let
                scaledColor =
                    MaterialColor.fromColor <|
                        MaterialColor.scaleOpacity opacity color
            in
            [ Border.shadow
                { offset = ( 0, 0 )
                , size = 10
                , blur = 0
                , color = scaledColor
                }
            , Background.color scaledColor
            ]
    in
    { elementButton =
        [ Element.width <| Element.px 20
        , Element.height <| Element.px 20
        , Border.rounded 10
        , Border.width 2
        , Element.focused <| rounded MaterialColor.buttonHoverOpacity palette.on.surface
        ]
    , ifDisabled =
        [ Border.color <|
            MaterialColor.fromColor <|
                MaterialColor.scaleOpacity MaterialColor.buttonDisabledOpacity palette.on.surface
        ]
    , ifSelected =
        [ Border.color <| MaterialColor.fromColor palette.primary
        , Element.mouseDown <| rounded MaterialColor.buttonPressedOpacity palette.primary
        , Element.focused <| rounded MaterialColor.buttonFocusOpacity palette.primary
        , Element.mouseOver <| rounded MaterialColor.buttonHoverOpacity palette.primary
        ]
    , ifDisabledSelected =
        [ Border.color <|
            MaterialColor.fromColor <|
                MaterialColor.scaleOpacity MaterialColor.buttonDisabledOpacity palette.on.surface
        ]
    , otherwise =
        [ Border.color <|
            MaterialColor.fromColor <|
                Palette.gray palette
        , Element.mouseDown <| rounded MaterialColor.buttonPressedOpacity palette.on.surface
        , Element.focused <| rounded MaterialColor.buttonFocusOpacity palette.on.surface
        , Element.mouseOver <| rounded MaterialColor.buttonHoverOpacity palette.on.surface
        ]
    , content =
        { element =
            [ Element.width <| Element.px 10
            , Element.height <| Element.px 10
            , Element.centerX
            , Element.centerY
            , Border.rounded 5
            ]
        , ifDisabled = []
        , ifSelected =
            [ Background.color <|
                MaterialColor.fromColor palette.primary
            ]
        , ifDisabledSelected =
            [ Background.color <|
                MaterialColor.fromColor <|
                    MaterialColor.scaleOpacity MaterialColor.buttonDisabledOpacity palette.on.surface
            ]
        , otherwise = []
        }
    }
