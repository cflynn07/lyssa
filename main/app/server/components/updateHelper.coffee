async  = require 'async'
config = require '../config/config'
_      = require 'underscore'

module.exports = (resource, objects, res, app) ->
  async.map objects, (item, callback) ->
    resource.find(
      where:
        uid: item.uid
    ).success (resultResource) ->
      if resultResource
        resultResource.updateAttributes(item).success () ->

          console.log resultResource.uid
          if !_.isUndefined(app.io) and _.isFunction(app.io.room)
            app.io.room(resultResource.uid).broadcast 'resourcePut', JSON.parse(JSON.stringify(resultResource))

          callback()
      else
        callback()
  , () ->
    res.jsonAPIRespond config.response(202)

