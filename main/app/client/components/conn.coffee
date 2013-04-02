define [
 'io'
], (
  io
) ->

  initialize: (conn_callback) ->
    if @io
      return
    else
      @io = io.connect()
      if conn_callback
        @io.on 'connect', () ->
          conn_callback()
  io: false
  request: (method, url, data, response) ->
    @io.emit 'apiRequest', {
        method: method
        url: url
        data: data
      }, response

