define [
  'underscore'
  'moment'
], (
  _
  moment
) ->

  #https://github.com/angular/angular.js/issues/1286
  (Module) ->

    Module.filter 'fromNow', () ->
      (dateString) ->
        moment(new Date(dateString)).fromNow()
