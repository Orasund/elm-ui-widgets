# Elm-Ui-Widgets

Usefull Widgets written for Elm-ui.
These include:

* Select
* Tab
* Multi Select
* Collapsable
* Dialog
* Carousel
* Snackbar
* Sort Table
* Filter Select
* Validated Input
* Scrolling Nav

Examples of all widgets can be found [here](https://orasund.github.io/elm-ui-widgets/). For styling, I used my own [Orasund/elm-ui-framework](https://package.elm-lang.org/packages/Orasund/elm-ui-framework/latest/).

## Why create such a package?

After looking at the current packages that implement various reusable views (and components) I noticed two things:

* There are (nearly) no widgets for Elm-Ui, and that's a problem because while going from `Element` to `Html` is easy, the opposite is not always possible (as a lot of styling in Elm-Ui would not be adapted to the `Html` element.)
* There is collection of widgets, all in one place. A lot of components get reimplemented over and over again. It's hard to keep track of what package is currently the best.

This package tries to solve both of these problems.

Here are some alternative packages for creating UIs:

* Using Elm-Ui
    * [lucamug/style-framework](https://dark.elm.dmy.fr/packages/lucamug/style-framework/latest/) - Full customization requires the cloning of the package.
    * [jxxcarlson/elm-widget](https://dark.elm.dmy.fr/packages/jxxcarlson/elm-widget/latest/Widget-Button) -  Uses a Builder pattern. Has some redefined customizations.
    * [QiTASC/hatchinq](https://dark.elm.dmy.fr/packages/QiTASC/hatchinq/latest/) - Similar Arroach, stillin experimental phase
* Using Elm/Html
    * [nathanjohnson320/elm-ui-components](https://dark.elm.dmy.fr/packages/nathanjohnson320/elm-ui-components/latest/) - Sticks with the elm/html way of styling.
    * [NoRedInk/noredink-ui](https://dark.elm.dmy.fr/packages/NoRedInk/noredink-ui/latest/) - Similar Approach but no customization options.
    * [peterszerzo/elm-natural-ui](https://dark.elm.dmy.fr/packages/peterszerzo/elm-natural-ui/latest) - Uses custom Attributes with some customization.
* Ui Frameworks
    * [aforemny/material-components-web-elm](https://dark.elm.dmy.fr/packages/aforemny/material-components-web-elm/latest/) - Wrapper of Material design using custom elements.
    * [afidegnum/elm-tailwind](https://dark.elm.dmy.fr/packages/afidegnum/elm-tailwind/latest/) - Wrapper of Tailwind by including the tailwind stylesheet.
    * [surprisetalk/elm-bulma](https://dark.elm.dmy.fr/packages/surprisetalk/elm-bulma/latest/) - Wrapper for Bulma by  including the bulma stylesheet.
    * [rundis/elm-bootstrap](https://dark.elm.dmy.fr/packages/rundis/elm-bootstrap/latest/) - Wrapper for Bootstrap by including the bootstrap stylesheet.




## Why does this package also include components?

I wrote a component whenever the boilerplate of a similar reusable view is less than just include the wiring in the package.

## Where will it go from here

I really would like to write a native material-design implementation in Elm. But after doing this package as a first step, (Which I already wrote while having the material.io docs as reference) I am not quite sure how I can avoid a lot of boilerplating. It seems like a [Master View Type](https://www.freecodecamp.org/news/scaling-elm-views-with-master-view-types/) would be the solution, but I'm not quite sure how I can ensure the customizability when my entire page can be described as a single type. (I don't want to know how many parameters such a type would need).