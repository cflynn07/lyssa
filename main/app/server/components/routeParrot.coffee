config  = require '../config/config'
_       = require 'underscore'
#apiAuth = require config.appRoot + 'server/components/apiAuth'

defaultCode = 200

module.exports.http = (req, res, next) ->


  #Modify if this is an API HTTP request
  if req.url.indexOf(config.apiSubDir) is 0

    if req.query and req.query.expand
      req.apiExpand = req.query.expand


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
    query:    if !_.isUndefined(req.data.query) then req.data.query else {}

  _.extend req, httpEmulatedRequest

  console.log req.query
  if !_.isUndefined(req.query) and !_.isUndefined(req.query.expand)
    req.apiExpand = req.query.expand

  res.jsonAPIRespond = (json) ->
    if !json.code?
      json.code = defaultCode
    req.io.respond json

  callback(req, res)
