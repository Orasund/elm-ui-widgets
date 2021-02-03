module Example.Sheet exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Element exposing (Element)
import FeatherIcons
import Widget exposing (ButtonStyle, SideSheetStyle,ItemStyle,HeaderStyle,InsetItemStyle)
import Widget.Icon as Icon
import Widget.Material as Material
import Widget.Material.Typography as Typography

type alias Style style msg =
    { style
        | sideSheet : SideSheetStyle msg
        , primaryButton : ButtonStyle msg
        , fullBleedHeader : ItemStyle (HeaderStyle msg) msg
        , insetItem : ItemStyle (InsetItemStyle msg) msg
    }


materialStyle : Style {} msg
materialStyle =
    { sideSheet = Material.sideSheet Material.defaultPalette
    , primaryButton = Material.containedButton Material.defaultPalette
    , fullBleedHeader = Material.fullBleedHeader Material.defaultPalette
    , insetItem = Material.insetItem Material.defaultPalette
    }


type Model
    = IsEnabled Bool


type Msg
    = ToggleModal Bool


init : ( Model, Cmd Msg )
init =
    ( IsEnabled True
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        ToggleModal bool ->
            ( IsEnabled bool
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Style style msg -> Model -> Element msg
view msgMapper style (IsEnabled isEnabled) =
    Widget.button style.primaryButton
        { text = "Show Sheet"
        , icon =
            FeatherIcons.eye
                |> Icon.elmFeather FeatherIcons.toHtml
        , onPress =
            ToggleModal True
                |> msgMapper
                |> Just
        }
        |> Element.el
            ([ Element.height <| Element.minimum 200 <| Element.fill
             , Element.width <| Element.minimum 400 <| Element.fill
             ]
                ++ (if isEnabled then
                        { content =
                            [ "Menu"
                              |> Element.text
                              |> Element.el Typography.h6
                              |> Widget.asItem
                            , Widget.insetItem style.insetItem
                                { onPress = Just <| msgMapper <| ToggleModal False
                                , icon =
                                    FeatherIcons.triangle
                                        |> Icon.elmFeather FeatherIcons.toHtml
                                , text = "Home"
                                , content =
                                    \{ size, color } ->
                                        Element.none
                                }
                            , Widget.insetItem style.insetItem
                                { onPress = Just <| msgMapper <| ToggleModal False
                                , icon =
                                    FeatherIcons.triangle
                                        |> Icon.elmFeather FeatherIcons.toHtml
                                , text = "About"
                                , content =
                                    \{ size, color } ->
                                        Element.none
                                }
                            ] 
                            |> Widget.sideSheet style.sideSheet
                        , onDismiss = Just <| msgMapper <| ToggleModal False
                        }
                        |> List.singleton
                        |> Widget.singleModal
                            

                    else
                        []
                   )
            )


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , view = \model -> model |> view identity materialStyle |> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }