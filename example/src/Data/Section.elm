module Data.Section exposing (Section(..),asList,toString,fromString)

type Section
    = ComponentViews
    | ReusableViews
    | StatelessViews

asList : List Section
asList =
    [ StatelessViews, ReusableViews, ComponentViews ]

toString : Section -> String
toString section =
    case section of
        ComponentViews ->
            "Component"

        ReusableViews ->
            "Reusable"

        StatelessViews ->
            "Stateless"

fromString : String -> Maybe Section
fromString string =
    case string of
        "Component" ->
            Just ComponentViews

        "Reusable" ->
            Just ReusableViews

        "Stateless" ->
            Just StatelessViews

        _ ->
            Nothing