var componentRequireContext = require.context("app", true)
var ReactRailsUJS = require("react_ujs")
ReactRailsUJS.useContext(componentRequireContext)

global.__SERVER__ = false
global.__CLIENT__ = true
