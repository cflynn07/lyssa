config  = require '../../../config/config'
apiAuth = require config.appRoot + '/server/components/apiAuth'
ORM     = require config.appRoot + '/server/components/orm'

module.exports = (app) ->

  employee = ORM.model 'employee'

  app.get config.apiSubDir + '/employees', (req, res) ->
    apiAuth req, res, () ->

      userType = req.session.user.type
      clientId = req.session.user.clientId

      switch userType
        when 'super_admin'

          employee.findAll().success (employees) ->
            res.jsonAPIRespond
              code: 200
              response: employees

        when 'client_super_admin', 'client_admin', 'client_delegate', 'client_auditor'

          #Always prevent password hash from being sent
          employee.find(
            where:
              clientId: req.session.user.clientId
          ).success (employees) ->
            res.jsonAPIRespond
              code: 200
              response: employees


  app.get config.apiSubDir + '/employees/:id', (req, res) ->
    apiAuth req, res, () ->

      userType = req.session.user.type
      clientId = req.session.user.clientId

      switch userType
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
