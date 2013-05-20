define [
  'jquery'
  'jquery-ui'
  'underscore'
  'text!views/widgetEmployeeManager/viewPartialEmployeeManagerEditEmployeeEJS.html'
], (
  $
  jqueryUi
  _
) ->

  (Module) ->

    Module.directive 'editEmployee', () ->
      directive =
        restrict: 'A'
        template: viewPartialEmployeeManagerEditEmployeeEJS
        scope:
          employeeUid: '@employeeUid'
        link: ($scope, element, attrs) ->
