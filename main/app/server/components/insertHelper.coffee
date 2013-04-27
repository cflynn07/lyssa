async  = require 'async'
_      = require 'underscore'
config = require '../config/config'
uuid   = require 'node-uuid'

module.exports = (apiCollectionName, clientUid, resource, objects, res, app) ->
  #Give everyone their own brand new uid
  for object, key in objects
    objects[key]['uid'] = uuid.v4()

  responseUids = []

  async.map objects, (item, callback) ->
    resource.create(item).success (createdItem) ->

      responseUids.push createdItem.uid

      if !_.isUndefined(app.io) and _.isFunction(app.io.room)

        roomName = clientUid + '-postResources'
        console.log 'broadcast to: ' + roomName

        app.io.room(roomName).broadcast 'resourcePost',
          apiCollectionName: apiCollectionName
          resourceName:      resource.name
          resource:          JSON.parse(JSON.stringify(createdItem))

      callback()
  , (err, results) ->
    res.jsonAPIRespond(code: 201, message: config.apiResponseCodes[201], uids: responseUids)
