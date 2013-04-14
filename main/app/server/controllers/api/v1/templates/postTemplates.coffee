config              = require '../../../../config/config'
apiAuth             = require config.appRoot + '/server/components/apiAuth'
ORM                 = require config.appRoot + '/server/components/orm'
apiPostVerifyFields = require config.appRoot + '/server/components/apiPostVerifyFields'
sequelize           = ORM.setup()
async               = require 'async'
_                   = require 'underscore'
uuid                = require 'node-uuid'

module.exports = (app) ->

  template = ORM.model 'template'

  app.post config.apiSubDir + '/v1/templates', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        switch userType
          when 'superAdmin'

          #  console.log req.query
          #  console.log req.body


            _this = this
            apiPostVerifyFields _this, template, req.body, req, res, {
              requiredProperties:
                'name':        (val, callback) ->

                  console.log funscope
                  console.log 'name'
                  console.log val
                  callback()


                'type':        (val, callback) ->

                  console.log 'type'
                  console.log val
                  callback()


                'employeeUid': (val, callback) ->

                  console.log 'employeeUid'
                  console.log val
                  callback()


              clientUidRestriction: clientUid     #<-- Normally for superAdmin this is FALSE, since a SA can create a new employee for anyone
            }



          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)


    ]


