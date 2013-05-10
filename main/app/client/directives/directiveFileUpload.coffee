define [
  'jquery'
  'jquery-ui'
  'jqueryFileUpload'
], (
  $
  jqueryUi
  jqueryFileUpload
) ->

  (Module) ->

    Module.directive 'fileUpload', ($parse) ->
      directive =
        restrict:   'A'
        scope:
          filename: '=ngModel'
          done:     '=done'
          url:      '@url'
        link: (scope, elm, attrs) ->

          doneCallback = $parse(attrs.done)

          $(elm).fileupload
            url:       attrs.url
            dataType:  'json'
            paramName: 'files[]'
            success_action_status: 200
            error: () ->
              console.log 'error'
              console.log arguments
            complete: (e, status) ->
              scope.$apply () ->
                #doneCallback(e, status)
                scope.done(e, status)

            progressall: (e, data) ->
              progress = parseInt(data.loaded / data.total * 100, 10)
              console.log 'progress ' + progress

              scope.$apply () ->
                scope.progress = progress

            done: (e, data) ->
              console.log 'done'
