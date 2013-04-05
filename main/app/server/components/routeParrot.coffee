config  = require '../config/config'
#apiAuth = require config.appRoot + 'server/components/apiAuth'

defaultCode = 200

module.exports.http = (req, res, next) ->
  req.requestType = 'http'



  if req.url.indexOf config.apiSubDir is 0

    res.jsonAPIRespond = (json) ->
      if !json.code?
        json.code = defaultCode
      res.json json.code, json

    #Pass through authentication module
    apiAuth req, res, next, () ->
      router req, res, next



  else
    router(req, res, next)


module.exports.socketio = (req, res) ->
  req.requestType = 'socketio'



  httpEmulatedRequest =
    method:   if req.data.method then req.data.method else 'get'
    url:      config.apiSubDir + (if req.data.url then req.data.url else '/')
    headers:  []

  res.jsonAPIRespond = (json) ->
    if !json.code?
      json.code = defaultCode
    req.io.respond json

  #Pass through authentication module
  apiAuth req, res, next, () ->
    router httpEmulatedRequest, res, next
