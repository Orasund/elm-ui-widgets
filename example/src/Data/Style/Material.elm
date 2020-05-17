module Data.Style.Material exposing (Palette, defaultPalette, style)

import Color exposing (Color)
import Color.Accessibility as Accessibility
import Color.Convert as Convert
import Color.Manipulate as Manipulate
import Data.Style exposing (Style)
import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attributes
import Widget.Style
    exposing
        ( ButtonStyle
        , ColumnStyle
        , DialogStyle
        , ExpansionPanelStyle
        , RowStyle
        , SnackbarStyle
        , SortTableStyle
        , TabStyle
        , TextInputStyle
        )


type alias Palette =
    { primary : Color --Color.rgb255 0x62 0x00 0xEE
    , secondary : Color --Color.rgb255 0x03 0xda 0xc6
    , background : Color --Color.rgb255 0xFF 0xFF 0xFF
    , surface : Color --Color.rgb255 0xFF 0xFF 0xFF
    , error : Color --Color.rgb255 0xB0 0x00 0x20
    , on :
        { primary : Color --Color.rgb255 0xFF 0xFF 0xFF
        , secondary : Color --Color.rgb255 0x00 0x00 0x00
        , background : Color --Color.rgb255 0x00 0x00 0x00
        , surface : Color --Color.rgb255 0x00 0x00 0x00
        , error : Color --Color.rgb255 0xFF 0xFF 0xFF
        }
    }


defaultPalette : Palette
defaultPalette =
    { primary = Color.rgb255 0x62 0x00 0xEE
    , secondary = Color.rgb255 0x03 0xDA 0xC6
    , background = Color.rgb255 0xFF 0xFF 0xFF
    , surface = Color.rgb255 0xFF 0xFF 0xFF
    , error = Color.rgb255 0xB0 0x00 0x20
    , on =
        { primary = Color.rgb255 0xFF 0xFF 0xFF
        , secondary = Color.rgb255 0x00 0x00 0x00
        , background = Color.rgb255 0x00 0x00 0x00
        , surface = Color.rgb255 0x00 0x00 0x00
        , error = Color.rgb255 0xFF 0xFF 0xFF
        }
    }


accessibleTextColor : Color -> Color
accessibleTextColor color =
    if (0.05 / (Accessibility.luminance color + 0.05)) < 7 then
        Color.rgb 255 255 255

    else
        Color.rgb 0 0 0


{-| using noahzgordon/elm-color-extra for colors
-}
withShade : Color -> Float -> Color -> Color
withShade c2 amount c1 =
    let
        alpha = c1 
            |> Color.toRgba |> .alpha
        

        toCIELCH =
            Convert.colorToLab
                >> (\{ l, a, b } ->
                        { l = l
                        , c = sqrt (a * a + b * b)
                        , h = atan2 b a
                        }
                   )

        fromCIELCH =
            (\{ l, c, h } ->
                { l = l
                , a = c * cos h
                , b = c * sin h
                }
            )
                >> Convert.labToColor

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

scaleOpacity : Float -> Color -> Color
scaleOpacity opacity =
    Color.toRgba
        >> (\color -> { color | alpha = color.alpha * opacity})
        >> Color.fromRgba

{-| hsl 265 100 47 (0% onColor)
rgb 98 0 238
-}
primaryColor : Palette -> Color
primaryColor { primary } =
    primary


{-| hsl 265 75 59 (24% onColor)
rgb 136 61 242
-}
primaryColorFocused : Palette -> Color
primaryColorFocused {primary, on } =
    primary |> withShade on.primary 0.24



--Color.rgb255 0x87 0x3D 0xF2


{-| hsl 265 92 51 (08% onColor)
-}
primaryColorHover : Palette -> Color
primaryColorHover {primary, on } =
    primary |> withShade on.primary 0.08



--Color.rgb255 0x6E 0x14 0xEF


{-| hsl 265 66 64 (32% onColor)
-}
primaryColorPressed : Palette -> Color
primaryColorPressed {primary, on } =
    primary |> withShade on.primary 0.32



--Color.rgb255 0x94 0x52 0xF3


primaryColorDisabled : Palette ->Color
primaryColorDisabled {primary,on}=
    Color.rgb255 0x77 0x77 0x77 |> scaleOpacity 0.38

disabledFontColor : Color
disabledFontColor =
    Color.rgb255 0x77 0x77 0x77--0x85 0x85 0x85


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


primaryButton : Palette -> ButtonStyle msg
primaryButton palette =
    { container =
        [ Element.height <| Element.px 36
        , Element.width <| Element.minimum 64 <| Element.shrink
        , Border.rounded <| 4
        , Border.shadow <| shadow 2
        , Font.size 14
        , Font.medium
        , Font.letterSpacing 1.25
        , Element.htmlAttribute <| Attributes.style "text-transform" "uppercase"
        , Element.paddingXY 16 8
        , Element.mouseDown
            [ Background.color <| Element.fromRgb <| Color.toRgba <| primaryColorPressed palette
            , Font.color <| Element.fromRgb <| Color.toRgba <| accessibleTextColor <| primaryColorPressed palette
            , Border.shadow <| shadow 12
            ]
        , Element.mouseOver
            [ Background.color <| Element.fromRgb <| Color.toRgba <| primaryColorHover palette
            , Font.color <| Element.fromRgb <| Color.toRgba <| accessibleTextColor <| primaryColorHover palette
            , Border.shadow <| shadow 6
            ]
        , Element.focused
            [ Background.color <| Element.fromRgb <| Color.toRgba <| primaryColorFocused palette
            , Font.color <| Element.fromRgb <| Color.toRgba <| accessibleTextColor <| primaryColorFocused palette
            , Border.shadow <| shadow 6
            ]
        ]
    , labelRow =
        [ Element.spacing <| 8
        ]
    , ifDisabled =
        [ Background.color <| Element.fromRgb <| Color.toRgba <| primaryColorDisabled palette
        , Font.color <| Element.fromRgb <| Color.toRgba <| disabledFontColor
        , Element.htmlAttribute <| Attributes.style "cursor" "not-allowed"
        , Element.mouseDown []
        , Element.mouseOver []
        , Element.focused []
        , Border.shadow <| shadow 0
        ]
    , ifActive =
        [ Background.color <| Element.fromRgb <| Color.toRgba <| primaryColorFocused palette
        , Font.color <| Element.fromRgb <| Color.toRgba <| accessibleTextColor <| primaryColorHover palette
        ]
    , otherwise =
        [ Background.color <| Element.fromRgb <| Color.toRgba <| primaryColor palette
        , Font.color <| Element.fromRgb <| Color.toRgba <| accessibleTextColor <| primaryColor palette
        
        ]
    }



{-------------------------------------------------------------------------------
- Template
-------------------------------------------------------------------------------}


fontSize : Int
fontSize =
    10


box : String -> List (Attribute msg)
box string =
    [ Border.width 1
    , Background.color <| Element.rgba 1 1 1 0.5
    , Element.padding 10
    , Element.spacing 10
    , Element.above <|
        Element.el [ Font.size <| fontSize ] <|
            Element.text string
    ]


decoration : String -> List (Attribute msg)
decoration string =
    [ Element.below <|
        Element.el [ Font.size <| fontSize ] <|
            Element.text string
    , Background.color <| Element.rgb 0.66 0.66 0.66
    ]


icon : String -> Element msg
icon string =
    Element.none
        |> Element.el
            [ Element.width <| Element.px 12
            , Element.height <| Element.px 12
            , Border.rounded 6
            , Border.width 1
            , Element.above <|
                Element.el [ Font.size <| fontSize ] <|
                    Element.text string
            ]


button : String -> ButtonStyle msg
button string =
    { container = box <| string ++ ":container"
    , labelRow = box <| string ++ ":labelRow"
    , ifDisabled = decoration <| string ++ ":ifDisabled"
    , ifActive = decoration <| string ++ ":ifActive"
    , otherwise = box <| string ++ ":otherwise"
    }


snackbar : String -> SnackbarStyle msg
snackbar string =
    { containerRow = box <| string ++ ":containerRow"
    , button = button <| string ++ ":button"
    , text = box <| string ++ ":text"
    }


dialog : String -> DialogStyle msg
dialog string =
    { containerColumn = box <| string ++ ":containerColumn"
    , title = box <| string ++ ":title"
    , buttonRow = box <| string ++ ":buttonRow"
    , acceptButton = button <| string ++ ":acceptButton"
    , dismissButton = button <| string ++ ":dismissButton"
    }


expansionPanel : String -> ExpansionPanelStyle msg
expansionPanel string =
    { containerColumn = box <| string ++ ":containerColumn"
    , panelRow = box <| string ++ ":panelRow"
    , labelRow = box <| string ++ ":labelRow"
    , content = box <| string ++ ":content"
    , expandIcon = icon <| string ++ ":expandIcon"
    , collapseIcon = icon <| string ++ ":collapseIcon"
    }


textInput : String -> TextInputStyle msg
textInput string =
    { chipButton = button <| string ++ ":chipButton"
    , chipsRow = box <| string ++ ":chipsRow"
    , containerRow = box <| string ++ ":containerRow"
    , input = box <| string ++ ":input"
    }


tab : String -> TabStyle msg
tab string =
    { button = button <| string ++ ":button"
    , optionRow = box <| string ++ ":optionRow"
    , containerColumn = box <| string ++ ":containerColumn"
    , content = box <| string ++ ":content"
    }


row : String -> RowStyle msg
row string =
    { containerRow = box <| string ++ ":containerRow"
    , element = box <| string ++ ":element"
    , ifFirst = box <| string ++ ":ifFirst"
    , ifLast = box <| string ++ ":ifLast"
    , otherwise = box <| string ++ ":otherwise"
    }


column : String -> ColumnStyle msg
column string =
    { containerColumn = box <| string ++ ":containerColumn"
    , element = box <| string ++ ":element"
    , ifFirst = box <| string ++ ":ifFirst"
    , ifLast = box <| string ++ ":ifLast"
    , otherwise = box <| string ++ ":otherwise"
    }


sortTable : String -> SortTableStyle msg
sortTable string =
    { containerTable = box <| string ++ ":containerTable"
    , headerButton = button <| string ++ ":headerButton"
    , ascIcon = icon <| string ++ ":ascIcon"
    , descIcon = icon <| string ++ ":descIcon"
    , defaultIcon = icon <| string ++ ":defaultIcon"
    }


style : Palette -> Style msg
style palette =
    { sortTable = sortTable <| "sortTable"
    , row = row <| "row"
    , cardColumn = column <| "cardRow"
    , column = column <| "column"
    , button = button <| "button"
    , primaryButton = primaryButton palette
    , tab = tab <| "tab"
    , textInput = textInput <| "textInput"
    , chipButton = button <| "chipButton"
    , expansionPanel = expansionPanel "expansionPanel"
    , dialog = dialog "dialog"
    , snackbar = snackbar "snackbar"
    , layout = Element.layout
    , header = box "header"
    , menuButton = button "menuButton"
    , sheetButton = button "sheetButton"
    , menuTabButton = button "menuTabButton"
    , sheet = box "sheet"
    , menuIcon = icon "menuIcon"
    , moreVerticalIcon = icon "moreVerticalIcon"
    , spacing = 8
    , title = box "title"
    , searchIcon = icon "searchIcon"
    , search = box "search"
    , searchFill = box "searchFill"
    }
