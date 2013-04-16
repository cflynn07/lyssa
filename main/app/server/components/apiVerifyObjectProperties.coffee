ORMValidateFieldsHelper = require './ORMValidateFieldsHelper'
config                  = require '../config/config'
async                   = require 'async'
uuid                    = require 'node-uuid'
_                       = require 'underscore'
preventUnknownFieldsHelper = require config.appRoot + 'server/components/preventUnknownFieldsHelper'


module.exports = (scope, resourceModel, testObjects, req, res, requirements, finalMethod) ->

  ###
  First iterate over all the properties of all the objects and verify that all required fields are present
  Also build an array of callbacks to test each required field
  ###
  if !_.isArray testObjects
    testObjects = [testObjects]


  unknownProperties = preventUnknownFieldsHelper(resourceModel, testObjects, requirements)
  if unknownProperties.length > 0
    res.jsonAPIRespond _.extend config.errorResponse(400), {messages: unknownProperties}
    return



  #validates each object property against any validation specs in resourceModel
  objectValidationErrors = ORMValidateFieldsHelper testObjects, resourceModel
  if objectValidationErrors.length > 0
    res.jsonAPIRespond _.extend config.errorResponse(400), messages: objectValidationErrors
    return



  #Asynchronously execute callbacks, if all tests pass insert objects, otherwise return error
  uidMappings = {}
  async.series [
    (superCallback) ->

      propertyAsyncMethods = []
      for object, key in testObjects
        for propertyName, propertyValueCheckCallback of requirements.requiredProperties

          valueToTest = object[propertyName]

          ((valueToTest, propertyValueCheckCallback, scope, objectKey, object)->

            propertyAsyncMethods.push (callback) ->
              propertyValueCheckCallback.call scope, valueToTest, objectKey, object, callback

          )(valueToTest, propertyValueCheckCallback, scope, key, object)



      errorMessages = []
      async.parallel propertyAsyncMethods, (err, results) ->

        #results will be array of results from each callback test
        for val in results
          if val.success is false

            if val.message
              errorMessages.push val.message

          else

            if _.isObject val.mapping
              for mappingUid, mappingId of val.mapping
                uidMappings[mappingUid] = mappingId

          if _.isArray val.transform
            testObjects[val.transform[0]][val.transform[1]] = val.transform[2]


        if errorMessages.length > 0
          res.jsonAPIRespond _.extend config.errorResponse(400), messages: errorMessages
          superCallback(new Error 'object property test failed')
          return


        #attach id's for uids
        for object, key in testObjects

          #Give everyone their own brand new uid
          #testObjects[key]['uid'] = uuid.v4()

          for objectPropKey, objectPropValue of object

            suffix = 'Uid'
            if objectPropKey.indexOf(suffix, objectPropKey.length - suffix.length) > -1
              #This property ends in Uid

              propertyAssocId  = uidMappings[objectPropValue]
              propertyPrefix   = objectPropKey.substring(0, objectPropKey.indexOf('Uid'))
              testObjects[key][propertyPrefix + 'Id'] = propertyAssocId


          #success
          superCallback(null, uidMappings)

    (superCallback) ->
      finalMethod testObjects

  ]


