module Data.Section exposing (Section(..), asList, fromString, toString)


type Section
    = ReusableViews
    | StatelessViews


asList : List Section
asList =
    [ StatelessViews, ReusableViews ]


toString : Section -> String
toString section =
    case section of

        ReusableViews ->
            "Reusable"

        StatelessViews ->
            "Stateless"


fromString : String -> Maybe Section
fromString string =
    case string of

        "Reusable" ->
            Just ReusableViews

        "Stateless" ->
            Just StatelessViews

        _ ->
            Nothing
