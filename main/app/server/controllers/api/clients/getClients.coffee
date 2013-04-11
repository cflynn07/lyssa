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

        switch userType
          when 'superAdmin'

            params =
              method: 'findAll'
              find: {}
              #  where:
              #    id: '*'
            apiExpand(req, res, client, params)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            params =
              method: 'findAll'
              find:
                where:
                  uid: clientUid

            apiExpand(req, res, client, params)

            #apiExpand(req, res, client, params)
            #client.find(clientId).success (client) ->
            #  res.jsonAPIRespond
            #    code: 200
            #    response: client

    ]

  app.get config.apiSubDir + '/v1/clients/:id', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid
        uids      = req.params.id.split ','

        #console.log req.params.id
        #console.log req.params.id.split(',')
        #console.log parseInt req.params.id
        #console.log _.isNumber req.params.id
        #console.log '----'
        #return


        ###
        params =
          method: 'findAll'
          find:
            where:
              uid: uids
        apiExpand(req, res, client, params)
        return
        ###

        switch userType
          when 'superAdmin'

            params =
              method: 'findAll'
              find:
                where:
                  uid: uids

            apiExpand(req, res, client, params)


            ###
            client.find(req.params.id).success (client) ->
              if !client
                res.jsonAPIRespond
                  code: 404
                  error: 'Not Found'
              else
                res.jsonAPIRespond
                  code: 200
                  response: client
            ###


          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            if (req.params.id + '') != (clientId + '')
              res.jsonAPIRespond config.errorResponse(401)

            else
              client.find(req.params.id).success (client) ->
                if !client
                  res.jsonAPIRespond
                    code: 404
                    error: 'Not Found'
                else
                  res.jsonAPIRespond
                    code: 200
                    response: client
    ]

