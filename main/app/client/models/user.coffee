define [
  'backbone'
  'underscore'
], (
  Backbone
  _
) ->

  user = Backbone.Model.extend
    initialize: () ->
    defaults: {}

  user = _.extend user, Backbone.Events

  new user()
