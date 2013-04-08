config  = require '../../../config/config'
apiAuth = require config.appRoot + '/server/components/apiAuth'
ORM     = require config.appRoot + '/server/components/orm'

module.exports = (app) ->

  app.get config.apiSubDir + '/clients', (req, res) ->
    apiAuth req, res, () ->

      client = ORM.model 'client'

      switch req.session.user.type
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
      switch req.session.user.type
        when 'super_admin'


          res.jsonAPIRespond config.unauthorizedResponse



        when 'client_super_admin'
          res.jsonAPIRespond config.unauthorizedResponse
        when 'client_admin'
          res.jsonAPIRespond config.unauthorizedResponse
        when 'client_delegate'
          res.jsonAPIRespond config.unauthorizedResponse
        when 'client_auditor'
          res.jsonAPIRespond config.unauthorizedResponse
