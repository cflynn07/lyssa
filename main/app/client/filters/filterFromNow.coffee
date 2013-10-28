define [
  'app'
  'underscore'
  'moment'
], (
  app
  _
  moment
) ->

  #https://github.com/angular/angular.js/issues/1286
  app.filter 'fromNow', [
    () ->
      (dateString) ->
        if !dateString
          return ''

        moment(new Date(dateString)).fromNow()
  ]