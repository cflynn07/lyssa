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
            showMeridian: true
            startDate:    new Date()
            autoClose:    true
            format:       'dd MM yyyy - HH:ii P'
          }).on 'changeDate', (e) ->
            $scope.$apply () ->
              $scope.model = e.date

            console.log arguments
