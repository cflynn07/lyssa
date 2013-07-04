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
              config.apiBroadcastPut(resource, resultResource, app, req, res)

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

