module Internal.Select exposing (MultiSelect, Select, multiSelect, select, selectButton, toggleButton)

import Element exposing (Element)
import Element.Input as Input
import Element.Region as Region
import Internal.Button exposing (Button, ButtonStyle)
import Set exposing (Set)
import Widget.Icon exposing (Icon)


type alias Select msg =
    { selected : Maybe Int
    , options :
        List
            { text : String
            , icon : Icon msg
            }
    , onSelect : Int -> Maybe msg
    }


type alias MultiSelect msg =
    { selected : Set Int
    , options :
        List
            { text : String
            , icon : Icon msg
            }
    , onSelect : Int -> Maybe msg
    }


selectButton :
    ButtonStyle msg
    -> ( Bool, Button msg )
    -> Element msg
selectButton style ( selected, b ) =
    Input.button
        (style.elementButton
            ++ (if b.onPress == Nothing then
                    style.ifDisabled

                else if selected then
                    style.ifActive

                else
                    style.otherwise
               )
            ++ [ Region.description b.text ]
        )
        { onPress = b.onPress
        , label =
            Element.row style.content.elementRow
                [ b.icon
                    (if b.onPress == Nothing then
                        style.content.content.icon.ifDisabled

                     else if selected then
                        style.content.content.icon.ifActive

                     else
                        style.content.content.icon.otherwise
                    )
                , Element.text b.text |> Element.el style.content.content.text.contentText
                ]
        }


toggleButton :
    ButtonStyle msg
    -> ( Bool, Button msg )
    -> Element msg
toggleButton style ( selected, b ) =
    Input.button
        (style.elementButton
            ++ (if b.onPress == Nothing then
                    style.ifDisabled

                else if selected then
                    style.ifActive

                else
                    style.otherwise
               )
            ++ [ Region.description b.text ]
        )
        { onPress = b.onPress
        , label =
            b.icon
                (if b.onPress == Nothing then
                    style.content.content.icon.ifDisabled

                 else if selected then
                    style.content.content.icon.ifActive

                 else
                    style.content.content.icon.otherwise
                )
                |> Element.el style.content.elementRow
        }


select :
    Select msg
    -> List ( Bool, Button msg )
select { selected, options, onSelect } =
    options
        |> List.indexedMap
            (\i a ->
                ( selected == Just i
                , { onPress = i |> onSelect
                  , text = a.text
                  , icon = a.icon
                  }
                )
            )


multiSelect :
    MultiSelect msg
    -> List ( Bool, Button msg )
multiSelect { selected, options, onSelect } =
    options
        |> List.indexedMap
            (\i a ->
                ( selected |> Set.member i
                , { onPress = i |> onSelect
                  , text = a.text
                  , icon = a.icon
                  }
                )
            )
