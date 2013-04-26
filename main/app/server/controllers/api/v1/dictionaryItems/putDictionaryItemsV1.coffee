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

  client         = ORM.model 'client'
  dictionaryItem = ORM.model 'dictionaryItem'


  app.put config.apiSubDir + '/v1/dictionaryItems', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType    = req.session.user.type
        clientUid   = req.session.user.clientUid
        employeeUid = req.session.user.uid

        switch userType
          when 'superAdmin'


            apiVerifyObjectProperties this, dictionaryItem, req.body, req, res, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    dictionaryItem.find(
                      where:
                        uid: val
                    ).success (resultResource) ->

                      if resultResource
                        mapObj = {}
                        mapObj[val] = resultResource
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

                'clientUid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        clientUid: 'unknown'

            }, (objects) ->

              updateHelper dictionaryItem, objects, res, app



          when 'clientSuperAdmin', 'clientAdmin'


            apiVerifyObjectProperties this, dictionaryItem, req.body, req, res, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    dictionaryItem.find(
                      where:
                        clientUid: clientUid
                        uid: val
                    ).success (resultResource) ->

                      if resultResource
                        mapObj = {}
                        mapObj[val] = resultResource
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

                'clientUid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        clientUid: 'unknown'

            }, (objects) ->

              updateHelper dictionaryItem, objects, res, app


          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


