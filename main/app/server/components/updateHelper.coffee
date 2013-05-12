async  = require 'async'
config = require '../config/config'
_      = require 'underscore'

module.exports = (resource, objects, req, res, app) ->
  async.map objects, (item, callback) ->
    resource.find(
      where:
        uid: item.uid
    ).success (resultResource) ->
      if resultResource

        try
          resultResource.updateAttributes(item).success () ->

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
              if !_.isUndefined(app.io) and _.isFunction(app.io.room)
                app.io.room(resultResource.uid).broadcast 'resourcePut', JSON.parse(JSON.stringify(resultResource))


            callback()
        catch err
          callback()

      else
        callback()
  , () ->
    res.jsonAPIRespond config.response(202)

