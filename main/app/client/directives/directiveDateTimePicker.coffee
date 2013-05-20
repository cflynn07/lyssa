define [
  'jquery'
  'jquery-ui'
], (
  $
  jqueryUi
) ->

  (Module) ->

    Module.directive 'dateTimePicker', () ->
      directive =
        restrict:   'A'
        scope:
          model:  '=model'
        replace: true
        link: ($scope, element, attrs) ->

          element.datetimepicker({
            showTimezone: true
            format:       'mm/dd/yyyy hh:ii'
          }).on 'changeDate', (e) ->
            $scope.$apply () ->
              $scope.model = e.date

            console.log arguments
