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



#
#
#  return io
#
#
#  connection = io.connect()
#
#  connection.on 'connect', () ->
#    console.log 'socket.io connected'

#  return connection