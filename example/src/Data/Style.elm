module Data.Style exposing (style)

import Widget exposing (TextInputStyle)
import Widget.Button exposing (ButtonStyle)
import Style exposing (Style)
import Element exposing (Attribute)
import Element.Input as Input
import Element.Font as Font
import Element.Border as Border
import Framework
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Framework.Group as Group
import Framework.Heading as Heading
import Framework.Input as Input
import Framework.Tag as Tag
import Icons

textButton : ButtonStyle msg
textButton =
    { container = Button.simple
    , label = Grid.simple
    , disabled = Color.disabled
    , active = Color.primary
    }

simpleButton : ButtonStyle msg
simpleButton =
    { container = Button.simple ++ Color.primary
    , label = Grid.simple
    , disabled = Color.disabled
    , active = Color.primary
    }

buttonStyle : ButtonStyle msg
buttonStyle =
    { label = [ Element.spacing 8]
    , container = Button.simple
    , disabled = Color.disabled
    , active = Color.primary
    }

tabButtonStyle :ButtonStyle msg
tabButtonStyle=
    { label = [ Element.spacing 8]
    , container = Button.simple ++ Group.top
    , disabled = Color.disabled
    , active = Color.primary
    }

textInputStyle =
    { chip = chipButtonStyle
    , chipsRow = 
        [ Element.width <| Element.shrink
        , Element.spacing <| 4
        , Element.paddingEach
            { top = 8
            , left = 0
            , right = 0
            , bottom = 8
            }
        ]
    , containerRow = 
        Button.simple
        ++ Color.light
        ++ [ Border.color <| Element.rgb255 186 189 182
            , Font.alignLeft
            , Element.paddingXY 8 0
            , Element.height <| Element.px <|42
            ]
        ++ Grid.simple
    , input =
        Color.light
        ++ [ Element.padding 8
        ]
    }


chipButtonStyle : ButtonStyle msg
chipButtonStyle =
    { container = Tag.simple
    , disabled = []
    , label = Grid.simple
    , active = Color.primary
    }

style : Style
    { dialog :
        { containerColumn : List (Attribute msg)
        , title : List (Attribute msg)
        , buttonRow : List (Attribute msg)
        , accept : ButtonStyle msg
        , dismiss : ButtonStyle msg
        }
    , button : ButtonStyle msg
    , tabButton : ButtonStyle msg
    , textInput : TextInputStyle msg
    , chipButton : ButtonStyle msg
    } msg
style =
    { button = buttonStyle
    , tabButton = tabButtonStyle
    , textInput = textInputStyle
    , chipButton = chipButtonStyle
    , dialog =
        { containerColumn = 
            Card.simple
            ++ Grid.simple
            ++ [ Element.width <| Element.minimum 280 <| Element.maximum  560 <| Element.fill ]
        , title = Heading.h3
        , buttonRow = 
            Grid.simple ++
            [ Element.paddingEach
                { top = 28
                , bottom = 0
                , left = 0
                , right = 0
                }
            ]
        , accept = simpleButton
        , dismiss = textButton
        }
    , snackbar = 
        { row = 
            Card.simple 
            ++ Color.dark
            ++ Grid.simple
            ++ [ Element.paddingXY 8 6
                , Element.height <| Element.px <|54]
        , button = 
            { label = Grid.simple
            , container = Button.simple ++ Color.dark
            , disabled = Color.disabled
            , active = Color.primary
            }
        , text = [Element.paddingXY 8 0]
        }
    , layout = Framework.responsiveLayout
    {--\a w ->
        Html.div []
        [ Html.node "meta"
            [ Attributes.attribute "name" "viewport"
            , Attributes.attribute "content" "width=device-width, initial-scale=1.0"
            ]
            []
        , Element.layoutWith
            {options = (Element.focusStyle
                { borderColor = Nothing
                , backgroundColor = Nothing
                , shadow = Nothing
                }
                |> List.singleton)
            }
         (Framework.layoutAttributes ++ a) <| w
        ]--}
    , header =
        Framework.container
            ++ Color.dark
            ++ [ Element.padding <| 0
                , Element.height <| Element.px <| 42
                ]
    , menuButton =
        { label = Grid.simple
        , container = Button.simple ++ Group.center ++ Color.dark
        , disabled = Color.disabled
        , active = Color.primary
        }
    , sheetButton =
        { container = 
            Button.fill
            ++ Group.center 
            ++ Color.light
            ++ [Font.alignLeft]
        , label = Grid.simple
        , disabled = Color.disabled
        , active = Color.primary
        }
    , menuTabButton = 
        { container =
            [ Element.height <| Element.px <| 42
            , Border.widthEach 
                { top = 0,
                left = 0,
                right = 0,
                bottom = 4
                }
            , Element.paddingEach
                { top = 12
                , left = 8
                , right = 8
                , bottom = 4
                }
            , Border.color Color.black
            ]
        , label = Grid.simple
        , disabled = Color.disabled
        , active = [ Border.color Color.turquoise ]
        }
    , sheet =
        Color.light ++ [ Element.width <| Element.maximum 256 <| Element.fill]
    , menuIcon =
        Icons.menu |> Element.html |> Element.el []
    , moreVerticalIcon =
        Icons.moreVertical |> Element.html |> Element.el []
    , spacing = 8
    , title = Heading.h2
    , searchIcon =
        Icons.search |> Element.html |> Element.el []
    , search =
        Color.simple ++ 
        Card.large ++
        [Font.color <| Element.rgb255 0 0 0
        , Element.padding 6
        , Element.centerY
        , Element.alignRight
        ]
    , searchFill =
        Color.light
        ++ Group.center
    }