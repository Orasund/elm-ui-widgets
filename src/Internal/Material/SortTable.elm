module Internal.Material.SortTable exposing (sortTable)

import Element
import Internal.Material.Button as Button
import Internal.Material.Icon as Icon
import Internal.Material.Palette exposing (Palette)
import Internal.SortTable exposing (SortTableStyle)


sortTable : Palette -> SortTableStyle msg
sortTable palette =
    { elementTable = []
    , content =
        { header = Button.textButton palette
        , ascIcon = Icon.expand_less
        , descIcon = Icon.expand_more
        , defaultIcon = always Element.none
        }
    }
