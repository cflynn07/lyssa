define [
  'text!config/clientOrmShare.json'
], (
  clientOrmShare
) ->

  clientOrmShare = JSON.parse clientOrmShare
  console.log clientOrmShare

  #Hash of all ORM resources
  resourcePool = {}

  (Module) ->
    Module.factory 'apiRequest', (socket, $rootScope) ->

      for modelName, modelValue of clientOrmShare
        console.log modelName
        console.log modelValue

      factory =
        foo: 'bar'
