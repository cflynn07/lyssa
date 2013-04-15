config                = require '../../../../config/config'
apiPostValidateFields = require config.appRoot + 'server/components/apiPostValidateFields'
apiAuth               = require config.appRoot + 'server/components/apiAuth'
async                 = require 'async'
uuid                  = require 'node-uuid'
ORM                   = require config.appRoot + 'server/components/oRM'
sequelize             = ORM.setup()
_                     = require 'underscore'
apiDeleteHelper       = require config.appRoot + 'server/components/apiDeleteHelper'

module.exports = (app) ->

  template = ORM.model 'template'

  app.delete config.apiSubDir + '/v1/templates/:id', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->


        userType  = req.session.user.type
        clientUid = req.session.user.clientUid
        uids      = req.params.id.split ','

        switch userType
          when 'superAdmin'

            apiDeleteHelper template, {uid: uids}, res


          when 'clientSuperAdmin', 'clientAdmin'

            console.log '2'


          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


