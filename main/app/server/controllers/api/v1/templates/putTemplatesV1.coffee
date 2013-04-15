config                = require '../../../../config/config'
apiPostValidateFields = require config.appRoot + 'server/components/apiPostValidateFields'
apiAuth               = require config.appRoot + 'server/components/apiAuth'
async                 = require 'async'
uuid                  = require 'node-uuid'
ORM                   = require config.appRoot + 'server/components/oRM'
sequelize             = ORM.setup()
_                     = require 'underscore'

module.exports = (app) ->

  template = ORM.model 'template'
  employee = ORM.model 'employee'
  client   = ORM.model 'client'

  app.put config.apiSubDir + '/v1/templates', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->


        userType  = req.session.user.type
        clientUid = req.session.user.clientUid


        switch userType
          when 'superAdmin'

            console.log '1'


          when 'clientSuperAdmin', 'clientAdmin'

            console.log '2'


          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


