config                = require '../../../../config/config'
apiAuth               = require config.appRoot + 'server/components/apiAuth'
async                 = require 'async'
uuid                  = require 'node-uuid'
ORM                   = require config.appRoot + 'server/components/oRM'
sequelize             = ORM.setup()
_                     = require 'underscore'
apiDelete             = require config.appRoot + 'server/components/apiDelete'

module.exports = (app) ->

  client = ORM.model 'client'

  app.delete config.apiSubDir + '/v1/clients', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        if !_.isArray req.body
          uids = [req.body]
        else
          uids = req.body

        switch userType
          when 'superAdmin'

            apiDelete client, {uid: uids}, res

          when 'clientSuperAdmin', 'clientAdmin'

            #apiDelete template, {uid: uids, clientUid: clientUid}, res
            res.jsonAPIRespond config.errorResponse(401)

          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


