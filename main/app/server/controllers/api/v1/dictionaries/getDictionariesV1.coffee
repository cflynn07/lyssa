config    = require '../../../../config/config'
apiAuth   = require config.appRoot + 'server/components/apiAuth'
apiExpand = require config.appRoot + 'server/components/apiExpand'
ORM       = require config.appRoot + 'server/components/oRM'
sequelize = ORM.setup()
async     = require 'async'
_         = require 'underscore'

module.exports = (app) ->

  dictionary = ORM.model 'dictionary'

  app.get config.apiSubDir + '/v1/dictionaries', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->
        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        switch userType
          when 'superAdmin'

            params =
              method: 'findAll'
              find: {}
            apiExpand(req, res, dictionary, params)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            params =
              method: 'findAll'
              find:
                where:
                  clientUid: clientUid

            apiExpand(req, res, dictionary, params)

    ]



  app.get config.apiSubDir + '/v1/dictionaries/:id', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid
        uids      = req.params.id.split ','

        switch userType
          when 'superAdmin'

            params =
              method: 'findAll'
              find:
                where:
                  uid: uids

            apiExpand(req, res, dictionary, params)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            params =
              method: 'findAll'
              find:
                where:
                  uid: uids
                  clientUid: clientUid

            apiExpand(req, res, dictionary, params)
    ]
