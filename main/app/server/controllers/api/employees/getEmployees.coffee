config  = require '../../../config/config'
apiAuth = require config.appRoot + '/server/components/apiAuth'
ORM     = require config.appRoot + '/server/components/orm'

module.exports = (app) ->

  app.get config.apiSubDir + '/employees', (req, res) ->
    apiAuth req, res, () ->

      employee = ORM.model 'employee'

      switch req.session.user.type
        when 'super_admin'

          employee.findAll().success (employees) ->
            res.jsonAPIRespond
              code: 200
              response: employees

        when 'client_super_admin', 'client_admin', 'client_delegate', 'client_auditor'

          employee.find(
            where
              clientId: this.session.user.clientId
          ).success (employees) ->
            res.jsonAPIRespond
              code: 200
              response: employees


  app.get config.apiSubDir + '/employees/:id', (req, res) ->
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
