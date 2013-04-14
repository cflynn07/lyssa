config              = require '../../../../config/config'
apiAuth             = require config.appRoot + '/server/components/apiAuth'
ORM                 = require config.appRoot + '/server/components/orm'
apiPostVerifyFields = require config.appRoot + '/server/components/apiPostVerifyFields'
sequelize           = ORM.setup()
async               = require 'async'
_                   = require 'underscore'
uuid                = require 'node-uuid'

module.exports = (app) ->

  employee = ORM.model 'employee'

  app.post config.apiSubDir + '/v1/employee', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        switch userType
          when 'superAdmin'

            console.log req.query
            console.log req.body

            body     = req.body
            body.uid = uuid.v4()



          #  client.create(
          #   body
          #  ).success (resClient) ->
          #    res.jsonAPIRespond
          #      code: 201


            postResourceCreate = (resourceModel, postObjects, requirements) ->




            postResourceCreate client, req.body, {
              requiredFields: [
                'name'
                'identifier'
                'address1'
                'address2'
                'address3'
                'city'
                'stateProvince'
                'country'
                'telephone'
                'fax'
              ]
              requireRelationships: {}
              clientUidRestriction: ''
            }




            #res.jsonAPIRespond config.errorResponse(401)


          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)



    ]


