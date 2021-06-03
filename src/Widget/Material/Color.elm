module Widget.Material.Color exposing
    ( buttonHoverOpacity, buttonFocusOpacity, buttonPressedOpacity, buttonDisabledOpacity, buttonSelectedOpacity
    , accessibleTextColor, accessibleWithTextColor
    , withShade, scaleOpacity
    , dark
    , toCIELCH, fromCIELCH, shadow, fromColor, textAndBackground
    , gray
    )

{-| This module contains functions to adapt color in various ways.

We use the CIELCH color space, while the material design on chrome uses sRGB.
CIELCH colors ensure that the result of mixing colors looks natural, where as
sRGB is optimized to mix images together.

In practice this means that in edge-cases our package will produce better results,
then the javascript material design implementation.


## Opacity Constants for Buttons

@docs buttonHoverOpacity, buttonFocusOpacity, buttonPressedOpacity, buttonDisabledOpacity, buttonSelectedOpacity


## Accessibility

@docs accessibleTextColor, accessibleWithTextColor


## Shades

@docs withShade, scaleOpacity


## Predefined Colors

@docs dark


## Utility Functions

@docs toCIELCH, fromCIELCH, shadow, fromColor, textAndBackground


## DEPRECATED

@docs gray

-}

import Color exposing (Color)
import Color.Accessibility as Accessibility
import Color.Convert as Convert
import Element
import Element.Background as Background
import Element.Font as Font


{-| Opacity value for hovering over a button
-}
buttonHoverOpacity : Float
buttonHoverOpacity =
    0.08


{-| Opacity value for a focused button
-}
buttonFocusOpacity : Float
buttonFocusOpacity =
    0.24


{-| Opacity value for a pressed button
-}
buttonPressedOpacity : Float
buttonPressedOpacity =
    0.32


{-| Opacity value for a disabled button
-}
buttonDisabledOpacity : Float
buttonDisabledOpacity =
    0.38


{-| Opacity value for a selected button
-}
buttonSelectedOpacity : Float
buttonSelectedOpacity =
    0.16


{-| Returns either Black or White, depending of the input color.
-}
accessibleTextColor : Color -> Color
accessibleTextColor color =
    let
        l : Float
        l =
            1
                + (color |> Color.toRgba |> .alpha)
                * (Accessibility.luminance color - 1)

        ratioBlack : Float
        ratioBlack =
            1.05 / (l + 0.05)

        ratioWhite : Float
        ratioWhite =
            (l + 0.05) / 0.05
    in
    if ratioBlack < ratioWhite then
        Color.rgb255 0 0 0

    else
        Color.rgb255 255 255 255


{-| Returns the first color, adapted to ensure accessibility rules.

    accessibleTextColor bgColor =
        accessibleWithTextColor (Color.rgb255 255 255 255) bgColor

-}
accessibleWithTextColor : Color -> Color -> Color
accessibleWithTextColor c color =
    let
        l1 : Float
        l1 =
            1
                + (c |> Color.toRgba |> .alpha)
                * (Accessibility.luminance c - 1)

        l2 : Float
        l2 =
            1
                + (color |> Color.toRgba |> .alpha)
                * (Accessibility.luminance color - 1)

        newConstrast : Float
        newConstrast =
            7

        lighterLuminance : Float
        lighterLuminance =
            newConstrast * (l2 + 0.05) - 0.05

        darkerLuminance : Float
        darkerLuminance =
            (l2 + 0.05) - 0.05 / newConstrast
    in
    c
        |> (if l1 > l2 then
                if ((l1 + 0.05) / (l2 + 0.05)) < 7 then
                    Convert.colorToLab
                        >> (\col ->
                                { col | l = 100 * lighterLuminance }
                           )
                        >> Convert.labToColor

                else
                    identity

            else if ((l2 + 0.05) / (l1 + 0.05)) < 7 then
                Convert.colorToLab
                    >> (\col ->
                            { col | l = 100 * darkerLuminance }
                       )
                    >> Convert.labToColor

            else
                identity
           )


{-| Utility function to convert a color to CIELCH color space
-}
toCIELCH : Color -> { l : Float, c : Float, h : Float }
toCIELCH =
    Convert.colorToLab
        >> (\{ l, a, b } ->
                { l = l
                , c = sqrt (a * a + b * b)
                , h = atan2 b a
                }
           )


{-| Utility function to convert CIELCH color space back to a color
-}
fromCIELCH : { l : Float, c : Float, h : Float } -> Color
fromCIELCH =
    (\{ l, c, h } ->
        { l = l
        , a = c * cos h
        , b = c * sin h
        }
    )
        >> Convert.labToColor


{-| Simulates adding a color in front (subtractive color mixing).

    --Darkens the color by 50%
    withShade (Color.rgb255 255 255 255) 0.5

    --Makes the color 50% more red
    withShade (Color.rgb255 255 0 0) 0.5

-}
withShade : Color -> Float -> Color -> Color
withShade c2 amount c1 =
    let
        alpha =
            c1
                |> Color.toRgba
                |> .alpha

        fun a b =
            { l = (a.l * (1 - amount) + b.l * amount) / 1
            , c = (a.c * (1 - amount) + b.c * amount) / 1
            , h = (a.h * (1 - amount) + b.h * amount) / 1
            }
    in
    fun (toCIELCH c1) (toCIELCH c2)
        |> fromCIELCH
        |> Color.toRgba
        |> (\color -> { color | alpha = alpha })
        |> Color.fromRgba


{-| Multiply the opacity value by a given value

    scaleOpacity (0.25 \* 2) ==
      scaleOpacity 0.25 >> scaleOpacity 2

-}
scaleOpacity : Float -> Color -> Color
scaleOpacity opacity =
    Color.toRgba
        >> (\color -> { color | alpha = color.alpha * opacity })
        >> Color.fromRgba


{-| DEPRECATED use Material.gray instead.
-}
gray : Color
gray =
    Color.rgb255 0x77 0x77 0x77


{-| dark gray
-}
dark : Color
dark =
    Color.rgb255 50 50 50


{-| Returns a Material Design shadow
-}
shadow :
    Float
    ->
        { offset : ( Float, Float )
        , size : Float
        , blur : Float
        , color : Element.Color
        }
shadow float =
    { color = Element.rgba255 0x00 0x00 0x00 0.2
    , offset = ( 0, float )
    , size = 0
    , blur = float
    }


{-| Utillity function to convert from Color to Element.Color
-}
fromColor : Color -> Element.Color
fromColor =
    Color.toRgba >> Element.fromRgb


{-| applies a color the background and ensures that the font color is accessible.
-}
textAndBackground : Color -> List (Element.Attr decorative msg)
textAndBackground color =
    [ color
        |> fromColor
        |> Background.color
    , color
        |> accessibleTextColor
        |> fromColor
        |> Font.color
    ]
