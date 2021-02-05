module Example.AppBar exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Attribute, DeviceClass(..), Element)
import Material.Icons
import Material.Icons.Types exposing (Coloring(..))
import Widget exposing (AppBarStyle, ButtonStyle)
import Widget.Icon as Icon exposing (Icon)
import Widget.Material as Material
import Widget.Material.Typography as Typography


type alias Style style msg =
    { style
        | menuBar :
            AppBarStyle
                { menuIcon : Icon msg
                , title : List (Attribute msg)
                }
                msg
        , tabBar :
            AppBarStyle
                { menuTabButton : ButtonStyle msg
                , title : List (Attribute msg)
                }
                msg
    }


materialStyle : Style {} msg
materialStyle =
    { menuBar = Material.menuBar Material.defaultPalette
    , tabBar = Material.tabBar Material.defaultPalette
    }


type alias Model =
    { isMenuBar : Bool
    , selected : Int
    , search : String
    }


type Msg
    = SetDesign Bool
    | SetSelected Int
    | SetSearch String


init : ( Model, Cmd Msg )
init =
    ( { isMenuBar = True
      , selected = 0
      , search = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg menu =
    case msg of
        SetDesign bool ->
            ( { menu | isMenuBar = bool }
            , Cmd.none
            )

        SetSelected int ->
            ( { menu | selected = int }
            , Cmd.none
            )

        SetSearch string ->
            ( { menu | search = string }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style model =
    let
        primaryActions =
            [ { icon =
                    Material.Icons.change_history
                        |> Icon.elmMaterialIcons Color
              , text = "Action"
              , onPress = Just <| msgMapper <| SetDesign (not model.isMenuBar)
              }
            ]

        search =
            { chips = []
            , text = model.search
            , placeholder = Nothing
            , label = "Search"
            , onChange = SetSearch >> msgMapper
            }
    in
    (if model.isMenuBar then
        Widget.menuBar style.menuBar
            { title =
                "Title"
                    |> Element.text
                    |> Element.el Typography.h6
            , deviceClass = Tablet
            , openLeftSheet = Just <| msgMapper <| SetDesign (not model.isMenuBar)
            , openRightSheet = Just <| msgMapper <| SetDesign (not model.isMenuBar)
            , openTopSheet = Just <| msgMapper <| SetDesign (not model.isMenuBar)
            , primaryActions = primaryActions
            , search = Just search
            }

     else
        Widget.tabBar style.tabBar
            { title =
                "Title"
                    |> Element.text
                    |> Element.el Typography.h6
            , menu =
                { selected = Just model.selected
                , options =
                    [ "Home", "About" ]
                        |> List.map
                            (\string ->
                                { text = string
                                , icon = always Element.none
                                }
                            )
                , onSelect = SetSelected >> msgMapper >> Just
                }
            , deviceClass = Phone
            , openRightSheet = Just <| msgMapper <| SetDesign (not model.isMenuBar)
            , openTopSheet = Just <| msgMapper <| SetDesign (not model.isMenuBar)
            , primaryActions = primaryActions
            , search = Just search
            }
    )
        |> Element.el [ Element.width <| Element.minimum 400 <| Element.fill ]


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
