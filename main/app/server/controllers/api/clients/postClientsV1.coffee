config    = require '../../../config/config'
apiAuth   = require config.appRoot + '/server/components/apiAuth'


ORM       = require config.appRoot + '/server/components/orm'
sequelize = ORM.setup()
async     = require 'async'
_         = require 'underscore'
uuid      = require 'node-uuid'

module.exports = (app) ->

  client = ORM.model 'client'

  app.post config.apiSubDir + '/v1/clients', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->
        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        switch userType
          when 'superAdmin'

            console.log req.query
            console.log req.body

            body = req.body
            body.uid = uuid.v4()

            client.create(
              body
            ).success (resClient) ->
              res.jsonAPIRespond
                code: 201

            #res.jsonAPIRespond config.errorResponse(401)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


