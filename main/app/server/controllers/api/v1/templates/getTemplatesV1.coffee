_         = require 'underscore'
async     = require 'async'
config    = require GLOBAL.appRoot + 'config/config'
apiAuth   = require GLOBAL.appRoot + 'components/apiAuth'
apiExpand = require GLOBAL.appRoot + 'components/apiExpand'
ORM       = require GLOBAL.appRoot + 'components/oRM'
sequelize = ORM.setup()

module.exports = (app) ->

  template = ORM.model 'template'

  app.get config.apiSubDir + '/v1/templates', (req, res) ->
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
            apiExpand(req, res, template, params)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            params =
              method: 'findAll'
              find:
                where:
                  clientUid: clientUid

            apiExpand(req, res, template, params)

    ]



  app.get config.apiSubDir + '/v1/templates/:id', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->


        console.log '939393993939393939933'

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

            apiExpand(req, res, template, params)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            params =
              method: 'findAll'
              find:
                where:
                  uid: uids
                  clientUid: clientUid

            apiExpand(req, res, template, params)
    ]


