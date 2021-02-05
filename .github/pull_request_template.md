# Description

_Please add a detailed description what you did._

**Pull request solving issue #[your issue].**

_Please only open Pull Requests for existing issues._

# Checklist for new Widget

* [ ] Checked out the Material design specification of the widget
* [ ] Added constructors, Widgets Type and Style Type in `src/Internal/[Your Widget].elm`
* [ ] Added styles in `src/Internal/Material/[Your Widget].elm`
* [ ] In `src/Widget.Material.elm`:
  * [ ] Linked each style to its representative in `src/Internal/Material/[Your Widget].elm`
  * [ ] Added Documentation
* [ ] In `src/Widget.elm`:
  * [ ] Added a copy of the Widget Type
  * [ ] Added a copy of the Style Type
  * [ ] Linked each constructor to its representative in `src/Internal/[You Widget].elm`
  * [ ] Replaced the Widget Type in the type signiture of each constructor with its definition
  * [ ] Added Documentation with a small example
  * [ ] run `elm-verify-examples && elm-test` to test the example

**Optional:**
* [ ] Added an Example in `example/src/Example/[Your Widget].elm`
