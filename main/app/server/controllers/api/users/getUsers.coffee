config  = require '../../../config/config'
apiAuth = require config.appRoot + '/server/components/apiAuth'
ORM     = require config.appRoot + '/server/components/orm'

module.exports = (app) ->

  app.get config.apiSubDir + '/users', (req, res) ->
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



  app.get config.apiSubDir + '/users/:id', (req, res) ->
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
