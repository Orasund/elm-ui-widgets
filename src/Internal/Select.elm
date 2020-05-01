module Internal.Select exposing (multiSelect, select, selectButton)

import Element exposing (Element)
import Internal.Button as Button exposing (Button)
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
    b
        |> Button.button
            { style
                | container =
                    style.container
                        ++ (if selected then
                                style.active

                            else
                                []
                           )
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
