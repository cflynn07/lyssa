config    = require '../../../config/config'
apiAuth   = require config.appRoot + '/server/components/apiAuth'
apiExpand = require config.appRoot + '/server/components/apiExpand'
ORM       = require config.appRoot + '/server/components/orm'
sequelize = ORM.setup()
async     = require 'async'
_         = require 'underscore'

module.exports = (app) ->

  client = ORM.model 'client'

  app.get config.apiSubDir + '/v1/clients', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        ###
          Will return all clients for super-admin, or just current client for all other user types
          searchExpectsMultiple, always wrap result in array even if only 1 result returned since
          this is a collection resource request
        ###

        switch userType
          when 'superAdmin'

            params =
              searchExpectsMultiple: true
              method:                'findAll'
              find:                  {}
            apiExpand(req, res, client, params)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            params =
              searchExpectsMultiple: true
              method:                'findAll'
              find:
                where:
                  uid: clientUid
            apiExpand(req, res, client, params)

    ]

  app.get config.apiSubDir + '/v1/clients/:id', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid
        uids      = req.params.id.split ','

        ###
          Will return that are specified in URL for super-admin, or just current client for
          all other user types.
          searchExpectsMultiple, always wrap result in array even if only 1 result returned
        ###

        params =
          method: 'findAll'
          find:
            where:
              uid: uids

        switch userType
          when 'superAdmin'

            apiExpand(req, res, client, params)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            if uids.length > 1
              res.jsonAPIRespond config.errorResponse(401)

            else if (uids[0] + '') is not (clientUid + '')
              res.jsonAPIRespond config.errorResponse(401)

            else
              apiExpand(req, res, client, params)

    ]

