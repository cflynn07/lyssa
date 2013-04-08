config  = require '../../../config/config'
apiAuth = require config.appRoot + '/server/components/apiAuth'
ORM     = require config.appRoot + '/server/components/orm'

client = ORM.model 'client'

module.exports = (app) ->

  app.get config.apiSubDir + '/clients', (req, res) ->
    apiAuth req, res, () ->

      userType = req.session.user.type

      switch userType
        when 'super_admin'
          client.findAll().success (clients) ->
            res.jsonAPIRespond
              code: 200
              response: clients

        when 'client_super_admin', 'client_admin', 'client_delegate', 'client_auditor'
          client.find(req.session.user.clientId).success (client) ->
            res.jsonAPIRespond
              code: 200
              response: client


  app.get config.apiSubDir + '/clients/:id', (req, res) ->
    apiAuth req, res, () ->

      userType = req.session.user.type

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

        when 'client_super_admin'
          res.jsonAPIRespond config.errorResponse(401)
        when 'client_admin'
          res.jsonAPIRespond config.errorResponse(401)
        when 'client_delegate'
          res.jsonAPIRespond config.errorResponse(401)
        when 'client_auditor'
          res.jsonAPIRespond config.errorResponse(401)
