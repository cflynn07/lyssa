config    = require '../../../config/config'
apiAuth   = require config.appRoot + '/server/components/apiAuth'
apiExpand = require config.appRoot + '/server/components/apiExpand'
ORM       = require config.appRoot + '/server/components/orm'
sequelize = ORM.setup()
async     = require 'async'
_         = require 'underscore'

module.exports = (app) ->

  client = ORM.model 'client'

  app.get config.apiSubDir + '/clients', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->
        userType = req.session.user.type
        clientId = req.session.user.clientId

        switch userType
          when 'superAdmin'


            #params =
            #  method: 'findAll'
            #  find:
            #    where:
            #      id: [1,2,3]
            #apiExpand(req, res, client, params)

            client.findAll().success (clients) ->
              res.jsonAPIRespond
                code: 200
                response: clients



          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'
            client.find(clientId).success (client) ->
              res.jsonAPIRespond
                code: 200
                response: client
    ]

  app.get config.apiSubDir + '/clients/:id', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->
        userType = req.session.user.type
        clientId = req.session.user.clientId



        #console.log req.params.id
        #console.log req.params.id.split(',')
        #console.log parseInt req.params.id
        #console.log _.isNumber req.params.id
        #console.log '----'
        #return

        params =
          method: 'findAll'
          find:
            where:
              uid: ["ea1fac23-82f5-4064-82f3-87702eb8d568", "ea1fac23-82f5-4064-82f3-87702eb8d569"]
        apiExpand(req, res, client, params)
        return


        switch userType
          when 'superAdmin'

            client.find(req.params.id).success (client) ->
              if !client
                res.jsonAPIRespond
                  code: 404
                  error: 'Not Found'
              else
                res.jsonAPIRespond
                  code: 200
                  response: client

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

