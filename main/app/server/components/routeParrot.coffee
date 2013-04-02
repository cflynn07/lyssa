config = require '../config/config'

module.exports.http = (req, res, next, router) ->
  req.requestType = 'http'

  if req.url.indexOf config.apiSubDir is 0
    #api auth
    #TODO
    res.jsonAPIRespond = (json) ->
      res.json json

    router(req, res, next)
  else
    router(req, res, next)


module.exports.socketio = (req, res, next, router) ->
  req.requestType = 'socketio'

  httpEmulatedRequest =
    method:   if req.data.method then req.data.method else 'get'
    url:      config.apiSubDir + (if req.data.url then req.data.url else '/')
    headers:  []

  res.jsonAPIRespond = (json) ->
    req.io.respond json

  #TODO api auth
  router httpEmulatedRequest, res, next
