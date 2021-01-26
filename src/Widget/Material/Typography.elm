module Widget.Material.Typography exposing
    ( h1, h2, h3, h4, h5, h6
    , subtitle1, subtitle2
    , body1, body2
    , button, caption, overline
    )

{-| An implementation of the Material design typography.

It is optimized for the _Roboto_ font


## Headline

@docs h1, h2, h3, h4, h5, h6


## Subtitle

@docs subtitle1, subtitle2


## Body

@docs body1, body2


## Miscellaneous

@docs button, caption, overline

-}

import Element exposing (Attribute)
import Element.Font as Font
import Html.Attributes as Attributes


{-| Headline 1 for Material Design. Size: 96px
-}
h1 : List (Attribute msg)
h1 =
    [ Font.size 96
    , Font.extraLight --light
    , Font.letterSpacing -1.5
    ]


{-| Headline 2 for Material Design. Size: 60px
-}
h2 : List (Attribute msg)
h2 =
    [ Font.size 60
    , Font.extraLight --light
    , Font.letterSpacing -0.5
    ]


{-| Headline 3 for Material Design. Size: 48px
-}
h3 : List (Attribute msg)
h3 =
    [ Font.size 48
    ]


{-| Headline 3 for Material Design. Size: 34px
-}
h4 : List (Attribute msg)
h4 =
    [ Font.size 34
    , Font.letterSpacing 0.25
    ]


{-| Headline 3 for Material Design. Size: 24px
-}
h5 : List (Attribute msg)
h5 =
    [ Font.size 24
    ]


{-| Headline 3 for Material Design. Size: 20px
-}
h6 : List (Attribute msg)
h6 =
    [ Font.size 20
    , Font.semiBold --medium
    , Font.letterSpacing 0.15
    ]


{-| Variant 1 for subtitles for Material Design. Size: 16px
-}
subtitle1 : List (Attribute msg)
subtitle1 =
    [ Font.size 16
    , Font.letterSpacing 0.15
    ]


{-| Variant 2 for subtitles for Material Design. Size: 14px
-}
subtitle2 : List (Attribute msg)
subtitle2 =
    [ Font.size 14
    , Font.semiBold --medium
    , Font.letterSpacing 0.1
    ]


{-| Variant 1 for the default font size: 16px
-}
body1 : List (Attribute msg)
body1 =
    [ Font.size 16
    , Font.letterSpacing 0.5
    ]


{-| Variant 2 for the default font size: 14px
-}
body2 : List (Attribute msg)
body2 =
    [ Font.size 14
    , Font.letterSpacing 0.25
    ]


{-| Font for Material Design buttons. Size: 14px
-}
button : List (Attribute msg)
button =
    [ Element.htmlAttribute <| Attributes.style "text-transform" "uppercase"
    , Font.size 14
    , Font.semiBold --medium
    , Font.letterSpacing 1.25
    ]


{-| Captions for Material Design. Size: 12px
-}
caption : List (Attribute msg)
caption =
    [ Font.size 12
    , Font.letterSpacing 0.4
    ]


{-| overline for Material Design. Size: 10px
-}
overline : List (Attribute msg)
overline =
    [ Element.htmlAttribute <| Attributes.style "text-transform" "uppercase"
    , Font.size 10
    , Font.letterSpacing 1.5
    ]
