# Description

_Please add a detailed description what you did._

**Pull request solving issue #[your issue].**

_Please only open Pull Requests for existing issues._

# Checklist for new Widget

* [ ] Checked out the Material design specification of the widget
* [ ] Added constructors and Widgets Type in `src/Internal/[Your Widget].elm`
* [ ] Added Style Type in `src/Widget/Style.elm`
* [ ] In `src/Widget.elm`:
  * [ ] Added a copy of the Widget Type
  * [ ] Added a copy of each constructor
  * [ ] Linked each constructor to its representative in `src/Internal/[You Widget].elm`
  * [ ] Replaced the Style Type in the type signiture of each constructor with its definition
  * [ ] Added Documentation
* [ ] Added a Template style in `src/Widget/Style/Template.elm`

**Optional:**
* [ ] Added a Material design style in `src/Widget/Style/Material.elm`
* [ ] Added an Example in `example/src/Example/[Your Widget].elm`
