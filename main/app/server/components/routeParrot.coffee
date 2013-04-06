config  = require '../config/config'
_       = require 'underscore'
#apiAuth = require config.appRoot + 'server/components/apiAuth'

defaultCode = 200

module.exports.http = (req, res, next) ->


  #Modify if this is an API HTTP request
  if req.url.indexOf(config.apiSubDir) is 0

    req.requestType = 'http'
    res.jsonAPIRespond = (json) ->
      if !json.code?
        json.code = defaultCode
      res.json json.code, json

  next()


module.exports.socketio = (req, res, callback) ->

  #Tweak the REQ object so that the app.router will treat it as
  #a regular HTTP request
  httpEmulatedRequest =
    requestType: 'socketio'
    method:   if req.data.method then req.data.method else 'get'
    url:      config.apiSubDir + (if req.data.url then req.data.url else '/')
    headers:  []

  _.extend req, httpEmulatedRequest

  res.jsonAPIRespond = (json) ->
    if !json.code?
      json.code = defaultCode
    req.io.respond json


  callback(req, res)
