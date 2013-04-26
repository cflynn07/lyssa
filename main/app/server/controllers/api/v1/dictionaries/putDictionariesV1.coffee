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

  client     = ORM.model 'client'
  dictionary = ORM.model 'dictionary'
  employee   = ORM.model 'employee'

  app.put config.apiSubDir + '/v1/dictionaries', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        switch userType
          when 'superAdmin'


            apiVerifyObjectProperties this, dictionary, req.body, req, res, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    dictionary.find(
                      where:
                        uid: val
                    ).success (resultDictionary) ->

                      if resultDictionary
                        mapObj = {}
                        mapObj[val] = resultDictionary
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

              #updateHelper objects, res
              updateHelper dictionary, objects, res, app


          when 'clientSuperAdmin', 'clientAdmin'


            apiVerifyObjectProperties this, dictionary, req.body, req, res, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    dictionary.find(
                      where:
                        clientUid: clientUid
                        uid: val
                    ).success (resultDictionary) ->

                      if resultDictionary
                        mapObj = {}
                        mapObj[val] = resultDictionary
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

              #updateHelper objects, res
              updateHelper dictionary, objects, res, app

          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


