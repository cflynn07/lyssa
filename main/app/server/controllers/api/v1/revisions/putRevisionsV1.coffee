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

  template = ORM.model 'template'
  revision = ORM.model 'revision'
  employee = ORM.model 'employee'


  app.put config.apiSubDir + '/v1/revisions', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType    = req.session.user.type
        clientUid   = req.session.user.clientUid
        employeeUid = req.session.user.uid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, template, req.body, req, res, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    revision.find(
                      where:
                        uid: val
                    ).success (resultRevision) ->

                      if resultRevision
                        mapObj = {}
                        mapObj[val] = resultRevision
                        callback null,
                          success: true
                          uidMapping: mapObj
                      else
                        callback null,
                          success: false
                          message:
                            uid: 'unknown'

                'changeSummary': (val, objectKey, object, callback) ->
                  callback null,
                    success: true
                'scope': (val, objectKey, object, callback) ->
                  callback null,
                    success: true
                'finalized': (val, objectKey, object, callback) ->
                  if val != 'true' && val != 'false'
                    callback null,
                      success: false
                      message:
                        finalized: 'invalid'
                    return

                  transVal = if (val == 'true') then true else false

                  callback null,
                    success: true
                    transform: [objectKey, 'finalized', transVal]

            }, (objects) ->

              updateHelper revision, objects, req, res, app


          when 'clientSuperAdmin', 'clientAdmin'

            apiVerifyObjectProperties this, template, req.body, req, res, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    revision.find(
                      where:
                        clientUid: clientUid
                        uid: val
                    ).success (resultRevision) ->

                      if resultRevision
                        mapObj = {}
                        mapObj[val] = resultRevision
                        callback null,
                          success: true
                          uidMapping: mapObj
                      else
                        callback null,
                          success: false
                          message:
                            uid: 'unknown'

                'changeSummary': (val, objectKey, object, callback) ->
                  callback null,
                    success: true
                'scope': (val, objectKey, object, callback) ->
                  callback null,
                    success: true
                'finalized': (val, objectKey, object, callback) ->

                  if val != 'true' && val != 'false'
                    callback null,
                      success: false
                      message:
                        finalized: 'invalid'
                    return

                  transVal = if (val == 'true') then true else false

                  callback null,
                    success: true
                    transform: [objectKey, 'finalized', transVal]

            }, (objects) ->

              updateHelper revision, objects, req, res, app

          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


