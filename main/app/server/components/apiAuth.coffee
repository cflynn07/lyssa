#authentication.coffee
###
module.exports = (req, callback) ->

  #Determine if this is HTTP or websockets
  if req.requestType is 'http'
    #HTTP check session auth or token

    if !req.user? or !req.user.clientID?
      req.
    else
      callback(req)

  else if req.requestType is 'socket.io'
    #Socket.io only allows session auth


  callback(req)
###
