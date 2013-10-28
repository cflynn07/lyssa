define [
  'app'
  'pubsub'
], (
  app
  PubSub
) ->

  app.factory 'pubsub', () ->
    PubSub
