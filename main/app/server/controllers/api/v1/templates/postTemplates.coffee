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


            console.log req.query
            console.log req.body

            body     = req.body
            body.uid = uuid.v4()






            postResourceCreate = (resourceModel, postObjects, req, res, requirements) ->

              if !_.isArray postObjects
                postObjects = [postObjects]

              for object, key in postObjects

                missingProperties = []

                #verify this object has all properties of requiredProperties
                for requiredProperty in requirements.requiredProperties

                  #is requiredProperty in object
                  if _.isUndefined object[requiredProperty]
                    missingProperties.push requiredProperty

                if missingProperties.length > 0
                  res.jsonAPIRespond _.extend config.errorResponse(400), {missingProperties: missingProperties, objectMissingProperties:key}
                  return


              #make sure all essential relationships exist
              #objectAsyncMethods   = []



              async.series [
                (superCallback) ->

                  propertyAsyncMethods = []
                  for object, key in postObjects
                    for propertyName, propertyValueCheckCallback of requirements.requiredProperties

                      valueToTest = object[propertyName]

                      ((valueToTest)->

                        propertyAsyncMethods.push (callback) ->
                          propertyValueCheckCallback valueToTest, callback

                      )(valueToTest)



                  async.parallel propertyAsyncMethods, (err, results) ->



                    #results will be array of results from each callback test
                    for val in results

                      val = {result:true}

                      if val.result is false
                        res.jsonAPIRespond _.extend config.errorResponse(400)
                        superCallback(new Error 'object property test failed')
                        return

                    superCallback()


                (superCallback) ->
                  #If we get to this point, we're good to insert and respond

                  res.jsonAPIRespond success: 'you made it to the finish line'


              ]







            postResourceCreate template, req.body, req, res, {
              requiredProperties:
                'name':        (val, callback) ->

                  config              = require '../../../../config/config'
                  apiAuth             = require config.appRoot + '/server/components/apiAuth'
                  ORM                 = require config.appRoot + '/server/components/orm'


                  console.log ORM

                  console.log 'template'
                  console.log template
                  console.log (val is '555')
                  console.log val
                  #callback err, results
                  callback()


                'type':        (val, callback) ->

                  console.log (val is '555')
                  console.log val

                  callback()
                'employeeUid': (val, callback) ->




                  config              = require '../../../../config/config'
                  apiAuth             = require config.appRoot + '/server/components/apiAuth'
                  ORM                 = require config.appRoot + '/server/components/orm'


                  console.log ORM



                  console.log (val is '555')
                  console.log val

                  callback()

              clientUidRestriction: clientUid     #<-- Normally for superAdmin this is FALSE, since a SA can create a new employee for anyone
            }
















          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)



    ]


