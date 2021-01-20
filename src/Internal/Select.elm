module Internal.Select exposing (MultiSelect, Select, multiSelect, select, selectButton)

import Element exposing (Element)
import Element.Input as Input
import Internal.Button exposing (Button)
import Set exposing (Set)
import Widget.Style exposing (ButtonStyle)


type alias Select msg =
    { selected : Maybe Int
    , options :
        List
            { text : String
            , icon : Element Never
            }
    , onSelect : Int -> Maybe msg
    }


type alias MultiSelect msg =
    { selected : Set Int
    , options :
        List
            { text : String
            , icon : Element Never
            }
    , onSelect : Int -> Maybe msg
    }


selectButton :
    ButtonStyle msg
    -> ( Bool, Button msg )
    -> Element msg
selectButton style ( selected, b ) =
    Input.button
        (style.containerButton
            ++ (if b.onPress == Nothing then
                    style.ifDisabled

                else if selected then
                    style.ifActive

                else
                    style.otherwise
               )
        )
        { onPress = b.onPress
        , label =
            Element.row style.content.containerRow
                [ b.icon |> Element.map never
                , Element.text b.text |> Element.el style.content.contentText
                ]
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
