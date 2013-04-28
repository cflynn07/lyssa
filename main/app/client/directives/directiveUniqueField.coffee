define [], () ->

  (Module) ->

    #data-unique-field = "{resource: 'dictionary', property: 'name'}"

    Module.directive 'uniqueField', (apiRequest) ->

      directive =
        restrict: 'A'
        require:  'ngModel'
        scope:    true
        link: (scope, elm, attrs, ctrl) ->

          ctrl.$setValidity 'uniqueField', true
          attrData = JSON.parse attrs.uniqueField

          checkDuplicates = (viewValue) ->
            if viewValue
              apiRequest.get attrData.resource, [], {}, (response) ->
                isValid = true
                if response.code == 200
                  for uid, obj of response.response
                    if obj[attrData.property].toLowerCase() == viewValue.toLowerCase() and !obj.deletedAt
                      isValid = false
                      break
                  ctrl.$setValidity 'uniqueField', isValid
                else
                  ctrl.$setValidity 'uniqueField', true
            else
              ctrl.$setValidity 'uniqueField', true
            return viewValue

          ctrl.$formatters.unshift (viewValue) ->
            return checkDuplicates viewValue

          ctrl.$parsers.unshift (viewValue) ->
            return checkDuplicates viewValue
