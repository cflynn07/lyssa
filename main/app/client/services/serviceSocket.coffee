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

        emit: (eventName, data, callback) ->
          socket.emit eventName, data, () ->
            args = arguments
            $rootScope.$apply () ->
              callback.apply socket, args

        apiRequest: (method, url, query, data, callback) ->
          url = '/' + apiVersion + url

          socket.emit 'apiRequest', {
              method: method
              url:    url
              data:   data
              query:  query
            }, () ->
              args = arguments
              $rootScope.$apply () ->
                callback.apply socket, args
