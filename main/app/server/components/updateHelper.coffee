async     = require 'async'
config    = require '../config/config'
_         = require 'underscore'
ORM       = require config.appRoot + 'server/components/oRM'
sequelize = ORM.setup()

module.exports = (resource, objects, req, res, app) ->
  async.map objects, (item, callback) ->

    followThrough = () ->
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

              if !silent
                if !_.isUndefined(app.io) and _.isFunction(app.io.room)
                  #console.log 'updateRP'
                  app.io.room(resultResource.uid).broadcast 'resourcePut',
                    apiCollectionName: ''
                    resourceName:      resource.name
                    resource:          resultResource.values #JSON.parse(JSON.stringify(resultResource))

              callback()
          catch err
            callback()

        else
          callback()


    if _.isNull(item.deletedAt)

      resource.find(
        where:
          uid: item.uid
      ).success (resultResource) ->
        sequelize.query("UPDATE `" + resource.tableName + "` SET `deletedAt` = NULL WHERE `id` = " + resultResource.id).success (result) ->
          followThrough()

    else
      followThrough()


  , () ->
    res.jsonAPIRespond config.response(202)

