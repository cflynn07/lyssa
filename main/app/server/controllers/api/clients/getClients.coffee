config    = require '../../../config/config'
apiAuth   = require config.appRoot + '/server/components/apiAuth'
apiExpand = require config.appRoot + '/server/components/apiExpand'
ORM       = require config.appRoot + '/server/components/orm'
sequelize = ORM.setup()
async     = require 'async'


module.exports = (app) ->

  client = ORM.model 'client'

  app.get config.apiSubDir + '/clients', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->
        #Here we will do expansion testing
        apiExpand req, res, callback
      (callback) ->
        userType = req.session.user.type
        clientId = req.session.user.clientId

        switch userType
          when 'super_admin'
            client.findAll().success (clients) ->
              res.jsonAPIRespond
                code: 200
                response: clients

          when 'client_super_admin', 'client_admin', 'client_delegate', 'client_auditor'
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
        callback(false)
      (callback) ->
        userType = req.session.user.type
        clientId = req.session.user.clientId

        switch userType
          when 'super_admin'

            client.find(req.params.id).success (client) ->
              if !client
                res.jsonAPIRespond
                  code: 404
                  error: 'Not Found'
              else
                res.jsonAPIRespond
                  code: 200
                  response: client

          when 'client_super_admin', 'client_admin', 'client_delegate', 'client_auditor'

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

