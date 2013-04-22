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

          origElem   = transclusionFunc scope
          content    = origElem.text()
          scope.orig = content
          #scope.obj = my_custom_parsing(content)
          scope.obj  = content
