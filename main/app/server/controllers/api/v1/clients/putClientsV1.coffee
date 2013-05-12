config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                     = require 'async'
uuid                      = require 'node-uuid'
ORM                       = require config.appRoot + 'server/components/oRM'
sequelize                 = ORM.setup()
_                         = require 'underscore'
updateHelper              = require config.appRoot + 'server/components/updateHelper'


module.exports = (app) ->

  client = ORM.model 'client'

  app.put config.apiSubDir + '/v1/clients', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, client, req.body, req, res, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    client.find(
                      where:
                        uid: val
                    ).success (resultClient) ->

                      if resultClient
                        mapObj = {}
                        mapObj[val] = resultClient
                        callback null,
                          success: true
                          uidMapping: mapObj
                      else
                        callback null,
                          success: false
                          message:
                            uid: 'unknown'

                'name': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'identifier': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'address1': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'address2': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'address3': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'city': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'stateProvince': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'country': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'telephone': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'fax': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

            }, (objects) ->

              #updateHelper objects, res
              updateHelper client, objects, req, res, app

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


