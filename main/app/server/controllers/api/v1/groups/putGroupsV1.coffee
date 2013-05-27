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

  group = ORM.model 'group'
  employee = ORM.model 'employee'


  app.put config.apiSubDir + '/v1/groups', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, group, req.body, req, res, false, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    group.find(
                      where:
                        uid: val
                    ).success (resultGroup) ->

                      if resultGroup
                        mapObj = {}
                        mapObj[val] = resultGroup
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
                'ordinal': (val, objectKey, object, callback) ->
                  callback null,
                    success: true
                'description': (val, objectKey, object, callback) ->
                  callback null,
                    success: true

            }, (objects) ->

              updateHelper group, objects, req, res, app


          when 'clientSuperAdmin', 'clientAdmin'

            apiVerifyObjectProperties this, group, req.body, req, res, false, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    group.find(
                      where:
                        uid: val
                        clientUid: clientUid
                    ).success (resultGroup) ->

                      if resultGroup
                        mapObj = {}
                        mapObj[val] = resultGroup
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
                'ordinal': (val, objectKey, object, callback) ->
                  callback null,
                    success: true
                'description': (val, objectKey, object, callback) ->
                  callback null,
                    success: true


            }, (objects) ->

              updateHelper group, objects, req, res, app


          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


