async  = require 'async'
_      = require 'underscore'
config = require '../config/config'
uuid   = require 'node-uuid'

module.exports = (apiCollectionName, clientUid, resource, objects, req, res, app) ->
  #Give everyone their own brand new uid
  for object, key in objects
    objects[key]['uid'] = uuid.v4()

  responseUids = []

  async.map objects, (item, callback) ->
    resource.create(item).success (createdItem) ->

      responseUids.push createdItem.uid

      if !_.isUndefined(app.io) and _.isFunction(app.io.room)

        roomName = clientUid + '-postResources'
        #console.log 'broadcast to: ' + roomName

        if !_.isUndefined req.query.silent
          if req.query.silent == 'true'
            silent = true
          else
            silent = false
        else
          if req.requestType == 'http'
            silent = true
          else
            silent = false

        #broadcast update if silent == false
        #SIO DEFAULT == false
        #HTTP DEFAULT == true
        if !silent
          app.io.room(roomName).broadcast 'resourcePost',
            apiCollectionName: apiCollectionName
            resourceName:      resource.name
            resource:          JSON.parse(JSON.stringify(createdItem))


        if !_.isUndefined(req.io) and _.isFunction(req.io.join)
          if !_.isUndefined(req.session) and !_.isUndefined(req.session.user) and !_.isUndefined(req.session.user.clientUid)
            for uid in responseUids
              req.io.join(uid)



      callback()
  , (err, results) ->
    res.jsonAPIRespond(code: 201, message: config.apiResponseCodes[201], uids: responseUids)
