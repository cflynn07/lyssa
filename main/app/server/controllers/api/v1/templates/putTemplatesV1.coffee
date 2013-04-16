config                = require '../../../../config/config'
apiPutValidateFields  = require config.appRoot + 'server/components/apiPutValidateFields'
apiAuth               = require config.appRoot + 'server/components/apiAuth'
async                 = require 'async'
uuid                  = require 'node-uuid'
ORM                   = require config.appRoot + 'server/components/oRM'
sequelize             = ORM.setup()
_                     = require 'underscore'

module.exports = (app) ->

  template = ORM.model 'template'

  app.put config.apiSubDir + '/v1/templates', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->


        userType  = req.session.user.type
        clientUid = req.session.user.clientUid


        switch userType
          when 'superAdmin'

            apiPutValidateFields this, template, req.body, req, res, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else
                    callback null,
                      success: true

                'name': (val, objectKey, object, callback) ->
                  callback null,
                    success: true
                'type': (val, objectKey, object, callback) ->
                  callback null,
                    success: true
                'employeeUid': (val, objectKey, object, callback) ->
                  callback null,
                    success: true
            }


          when 'clientSuperAdmin', 'clientAdmin'

            apiPutValidateFields


          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


