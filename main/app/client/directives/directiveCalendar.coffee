define [
  'jquery'
  'jquery-ui'
  'underscore'
], (
  $
  jqueryUi
  _
) ->

  (Module) ->

    Module.directive 'calendar', () ->
      directive =
        restrict: 'A'
        template: '<div class="calendar"></div>'
        scope:
          options: '=options'
        link: ($scope, element, attrs) ->

          calendarElem = element.find('.calendar')
          calendarElem.fullCalendar $scope.options
