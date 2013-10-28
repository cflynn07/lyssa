define [
  'app'
  'underscore'
], (
  app
  _
) ->

  #https://github.com/angular/angular.js/issues/1286
  app.filter 'deleted', [
    () ->
      (arr) ->
        return _.filter arr, (item) ->
          !item.deletedAt
  ]