define [
  'jquery'
  'jquery-ui'
], (
  $
  jqueryUi
) ->

  (Module) ->

    Module.directive 'datepicker', () ->
      directive =
        restrict:   'A'
        #transclude: false
        #template:   ''
        scope:
          months: '@months'
        replace: true
        link: (scope, iterStartElement, attrs) ->

          console.log 'scope.months'
          console.log scope.months

          iterStartElement.datepicker(
            dateFormat: 'yy-mm-dd'
            numberOfMonths: parseInt(scope.months || 1) #2 #scope.months
            #onSelect: (dateText, inst) ->
            #  scope.$apply (scope) ->
            #    return
          )
              #$parse()
