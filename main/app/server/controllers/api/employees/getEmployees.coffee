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
        when 'superAdmin'

          employee.findAll().success (employees) ->
            res.jsonAPIRespond
              code: 200
              response: employees

        when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

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
        when 'superAdmin'
          res.jsonAPIRespond config.unauthorizedResponse
        when 'clientSuperAdmin'
          res.jsonAPIRespond config.unauthorizedResponse
        when 'clientAdmin'
          res.jsonAPIRespond config.unauthorizedResponse
        when 'clientDelegate'
          res.jsonAPIRespond config.unauthorizedResponse
        when 'clientAuditor'
          res.jsonAPIRespond config.unauthorizedResponse
