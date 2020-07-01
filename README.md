# Elm-Ui-Widgets

This package contains **independent** widgets (no components) written for [Elm-Ui](https://dark.elm.dmy.fr/packages/mdgriffith/elm-ui/latest/). These widgets have no dependencies to other parts of this package. So you can just use as much as you need.

It also supports custom themes and has a material design theme already ready to use.

[Examples of all widgets can be found here](https://orasund.github.io/elm-ui-widgets/2.0.0/).

![Example using the Material Design style](https://orasund.github.io/elm-ui-widgets/assets/material-style.png)

## Concept

**Summary**

* Each widget comes with a _Widget Type_ and a _Style Type_. The Widget Type is an abstract representation of the widget and the Style Type has all styling attributes.
* Widget Types can be used as building Blocks for more complicated Widgets
   (Button -> Select Buttons -> Menu -> Layout)

**Example**

Let's look at the button widget.

```elm
button: ButtonStyle msg
    ->
        { text : String
        , icon : Element Never
        , onPress : Maybe msg
        }
    -> Element msg
```

In comparison to Elm-Ui's button, we see  that `List (Attribute msg)` has changed into a _Style Type_.
  ```
  type alias ButtonStyle msg =
      { container : List (Attribute msg)
      , labelRow : List (Attribute msg)
      , ifDisabled : List (Attribute msg)
      , ifActive : List (Attribute msg)
      }
  ```

For actually displaying the button we have a few different implementations:

``` elm
{-| Button with only an icon and no text -}
iconButton :
    ButtonStyle msg
    ->
        { text : String --for screen readers
        , icon : Element Never
        , onPress : Maybe msg
        }
    -> Element msg

{-| Button with a text but no icon -}
textButton :
    ButtonStyle msg
    ->
        { textButton
            | text : String
            , onPress : Maybe msg
        }
    -> Element msg

{-| Button with both icon and text -}
button :
    ButtonStyle msg
    ->
        { text : String
        , icon : Element Never
        , onPress : Maybe msg
        }
    -> Element msg
```

We also have a `Widget Type` for the button:

```
type alias Button msg =
    { text : String
    , icon : Element Never
    , onPress : Maybe msg
    }
```

We can use it to build more complex widgets, for example a select button:

```
type alias Select msg =
    { selected : Maybe Int
    , options :
        List
            { text : String
            , icon : Element Never
            }
    , onSelect : Int -> Maybe msg
    }

select :
    Select msg
    -> List ( Bool, Button msg )

selectButton :
    ButtonStyle msg
    -> ( Bool, Button msg )
    -> Element msg
```

## Reusable Views vs. Components

In Elm we like to use reusable views instead of components.
At first this packages had a few components, but they where so complicated to use in comparison, so they got slowly turned into reusable views one by one.

Most could be reduced even further into _view functions_: reusable views without a model.
Currently we have only three reusable views: `Widget.Layout`, `Widget.ScrollingNav` and `Widget.Snackbar`.

## Alternatives

For comparison, here are some alternative packages for creating UIs:

* **Using Elm-Ui**
    * [lucamug/style-framework](https://dark.elm.dmy.fr/packages/lucamug/style-framework/latest/) - Full customization requires the cloning of the package.
    * [jxxcarlson/elm-widget](https://dark.elm.dmy.fr/packages/jxxcarlson/elm-widget/latest/Widget-Button) -  Uses a Builder pattern. Has some redefined customizations.
    * [QiTASC/hatchinq](https://dark.elm.dmy.fr/packages/QiTASC/hatchinq/latest/) - Similar Arroach but still in experimental phase
* **Using Elm/Html**
    * [nathanjohnson320/elm-ui-components](https://dark.elm.dmy.fr/packages/nathanjohnson320/elm-ui-components/latest/) - Uses the elm/html way of styling.
    * [NoRedInk/noredink-ui](https://dark.elm.dmy.fr/packages/NoRedInk/noredink-ui/latest/) - Similar Approach but no customization options.
    * [peterszerzo/elm-natural-ui](https://dark.elm.dmy.fr/packages/peterszerzo/elm-natural-ui/latest) - Uses custom Attributes with some customization.
* **Ui Frameworks**
    * [aforemny/material-components-web-elm](https://dark.elm.dmy.fr/packages/aforemny/material-components-web-elm/latest/) - Wrapper of Material design using custom elements.
    * [afidegnum/elm-tailwind](https://dark.elm.dmy.fr/packages/afidegnum/elm-tailwind/latest/) - Wrapper of Tailwind by including the tailwind stylesheet.
    * [surprisetalk/elm-bulma](https://dark.elm.dmy.fr/packages/surprisetalk/elm-bulma/latest/) - Wrapper for Bulma by  including the bulma stylesheet.
    * [rundis/elm-bootstrap](https://dark.elm.dmy.fr/packages/rundis/elm-bootstrap/latest/) - Wrapper for Bootstrap by including the bootstrap stylesheet.

## Motivation

After looking at the current packages that implement various reusable views (and components) I noticed two things:

* There are (nearly) no widgets for Elm-Ui, and that's a problem because while going from `Element` to `Html` is easy, the opposite is not always possible (as a lot of styling in Elm-Ui would not be adapted to the `Html` element.)
* There is collection of widgets, all in one place. A lot of components get reimplemented over and over again. It's hard to keep track of what package is currently the best.

This package tries to solve both of these problems.

## Changelog

* **Version 2.0.0** - Complete rewrite of the package. Now including a material design implementation.
