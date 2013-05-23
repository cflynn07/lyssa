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
          form:   '=form'
        replace: true
        link: ($scope, element, attrs) ->

          element.datetimepicker({
            showMeridian: true
            startDate:    new Date()
            autoclose:    true
            format:       'dd MM yyyy - HH:ii P'
          }).on 'changeDate', (e) ->
            $scope.$apply () ->
              $scope.model = e.date
              $scope.form.$pristine = false

            #console.log arguments
