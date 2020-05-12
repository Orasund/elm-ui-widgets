module Data.Example exposing (Model, Msg, init, subscriptions, toCardList, update, view)

import Data.Style exposing (Style)
import Element exposing (Element)
import Example.Button as Button
import Example.ExpansionPanel as ExpansionPanel
import Example.MultiSelect as MultiSelect
import Example.Select as Select
import Example.Tab as Tab
import Framework.Grid as Grid
import View.Test as Test


type Msg
    = Button Button.Msg
    | Select Select.Msg
    | MultiSelect MultiSelect.Msg
    | ExpansionPanel ExpansionPanel.Msg
    | Tab Tab.Msg


type alias Model =
    { button : Button.Model
    , select : Select.Model
    , multiSelect : MultiSelect.Model
    , expansionPanel : ExpansionPanel.Model
    , tab : Tab.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( buttonModel, buttonMsg ) =
            Button.init

        ( selectModel, selectMsg ) =
            Select.init

        ( multiSelectModel, multiSelectMsg ) =
            MultiSelect.init

        ( expansionPanelModel, expansionPanelMsg ) =
            ExpansionPanel.init

        ( tabModel, tabMsg ) =
            Tab.init
    in
    ( { button = buttonModel
      , select = selectModel
      , multiSelect = multiSelectModel
      , expansionPanel = expansionPanelModel
      , tab = tabModel
      }
    , [ Cmd.map Button buttonMsg
      , Cmd.map Select selectMsg
      , Cmd.map MultiSelect multiSelectMsg
      , Cmd.map Tab tabMsg
      ]
        |> Cmd.batch
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Button buttonMsg ->
            Button.update buttonMsg model.button
                |> Tuple.mapBoth
                    (\a -> { model | button = a })
                    (Cmd.map Button)

        Select selectMsg ->
            Select.update selectMsg model.select
                |> Tuple.mapBoth
                    (\a -> { model | select = a })
                    (Cmd.map Select)

        MultiSelect multiSelectMsg ->
            MultiSelect.update multiSelectMsg model.multiSelect
                |> Tuple.mapBoth
                    (\a -> { model | multiSelect = a })
                    (Cmd.map MultiSelect)

        ExpansionPanel expansionPanelMsg ->
            ExpansionPanel.update expansionPanelMsg model.expansionPanel
                |> Tuple.mapBoth
                    (\a -> { model | expansionPanel = a })
                    (Cmd.map ExpansionPanel)

        Tab tabMsg ->
            Tab.update tabMsg model.tab
                |> Tuple.mapBoth
                    (\a -> { model | tab = a })
                    (Cmd.map Tab)


subscriptions : Model -> Sub Msg
subscriptions model =
    [ Button.subscriptions model.button |> Sub.map Button
    , Select.subscriptions model.select |> Sub.map Select
    , MultiSelect.subscriptions model.multiSelect |> Sub.map MultiSelect
    , ExpansionPanel.subscriptions model.expansionPanel |> Sub.map ExpansionPanel
    , Tab.subscriptions model.tab |> Sub.map Tab
    ]
        |> Sub.batch


view :
    (Msg -> msg)
    -> Style msg
    -> Model
    ->
        { button : Element msg
        , select : Element msg
        , multiSelect : Element msg
        , expansionPanel : Element msg
        , tab : Element msg
        }
view msgMapper style model =
    { button =
        Button.view
            (Button >> msgMapper)
            style
            model.button
    , select =
        Select.view
            (Select >> msgMapper)
            style
            model.select
    , multiSelect =
        MultiSelect.view
            (MultiSelect >> msgMapper)
            style
            model.multiSelect
    , expansionPanel =
        ExpansionPanel.view
            (ExpansionPanel >> msgMapper)
            style
            model.expansionPanel
    , tab =
        Tab.view
            (Tab >> msgMapper)
            style
            model.tab
    }


toCardList :
    { idle : msg
    , msgMapper : Msg -> msg
    , style : Style msg
    , model : Model
    }
    -> List ( String, Element msg, Element msg )
toCardList { idle, msgMapper, style, model } =
    [ { title = "Icon Button"
      , example = .button
      , test = Test.iconButton
      }
    , { title = "Select"
      , example = .select
      , test = Test.select
      }
    , { title = "Multi Select"
      , example = .multiSelect
      , test = Test.multiSelect
      }
    , { title = "Expansion Panel"
      , example = .expansionPanel
      , test = Test.expansionPanel
      }
    , { title = "Tab"
      , example = .tab
      , test = Test.tab
      }
    ]
        |> List.map
            (\{ title, example, test } ->
                ( title
                , model
                    |> view msgMapper style
                    |> example
                , test idle style
                    |> Element.column Grid.simple
                )
            )
