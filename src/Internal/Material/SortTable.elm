module Internal.Material.SortTable exposing ( sortTable)

import Color
import Element
import Element.Background as Background
import Internal.Material.ExpansionPanel as ExpansionPanel
import Internal.SortTable exposing (SortTableStyle )
import Internal.List exposing (ItemStyle)
import Internal.Material.Icon as Icon
import Internal.Material.Palette exposing (Palette)
import Internal.Material.Button as Button
import Svg
import Svg.Attributes
import Widget.Icon as Icon exposing (Icon)
import Widget.Style.Customize as Customize
import Widget.Style.Material.Color as MaterialColor

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