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

  app.post config.apiSubDir + '/v1/employees', (req, res) ->
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


            postResourceCreate = (resourceModel, postObjects, req, res, requirements) ->

              if !_.isArray postObjects
                postObjects = [postObjects]

              for object, key in postObjects

                missingProperties       = []

                #verify this object has all properties of requiredProperties
                for requiredProperty in requirements.requiredProperties

                  #is requiredProperty in object
                  if _.isUndefined object[requiredProperty]
                    missingProperties.push requiredProperty

                if missingProperties.length > 0
                  res.jsonAPIRespond _.extend config.errorResponse(400), {missingProperties: missingProperties, objectMissingProperties:key}
                  break

              #res.jsonAPIRespond success: true


            postResourceCreate employee, req.body, req, res, {
              requiredProperties: [
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



          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)



    ]


