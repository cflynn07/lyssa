define [
  'io'
], (
  io
) ->

  apiVersion = 'v1'

  (Module) ->
    Module.factory 'socket', ($rootScope) ->
      socket = io.connect()

      factory =
        on: (eventName, callback) ->

        emit: (eventName, callback) ->

        apiRequest: (method, url, query, data, response) ->
          url = '/' + apiVersion + url

          socket.emit 'apiRequest', {
              method: method
              url:    url
              data:   data
              query:  query
            }, response
