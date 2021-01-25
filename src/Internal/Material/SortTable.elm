module Internal.Material.SortTable exposing (sortTable)

import Element
import Internal.Material.Button as Button
import Internal.Material.ExpansionPanel as ExpansionPanel
import Internal.Material.Palette exposing (Palette)
import Internal.SortTable exposing (SortTableStyle)


sortTable : Palette -> SortTableStyle msg
sortTable palette =
    { elementTable = []
    , content =
        { header = Button.textButton palette
        , ascIcon = ExpansionPanel.expand_less
        , descIcon = ExpansionPanel.expand_more
        , defaultIcon = always Element.none
        }
    }
