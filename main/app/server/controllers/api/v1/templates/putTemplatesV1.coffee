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
              'uid': (val, objectKey, object, callback) ->
                callback()
              'name': (val, objectKey, object, callback) ->
                callback()
              'type': (val, objectKey, object, callback) ->
                callback()
              'employeeUid': (val, objectKey, object, callback) ->
                callback()
            }


          when 'clientSuperAdmin', 'clientAdmin'

            apiPutValidateFields


          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


