config = require '../config/config'
async  = require 'async'
_      = require 'underscore'
uuid   = require 'node-uuid'

module.exports = (scope, resourceModel, postObjects, req, res, requirements) ->

  ###
  First iterate over all the properties of all the objects and verify that all required fields are present
  Also build an array of callbacks to test each required field
  ###
  if !_.isArray postObjects
    postObjects = [postObjects]

  for object, key in postObjects


    #Instead of enforcing no missing properties HERE, enforce no unknown properties
    unknownProperties = []
    for postObjectPropertyKey, postObjectPropertyValue of object

      if _.isUndefined(requirements.requiredProperties[postObjectPropertyKey])
        errorObj = {}
        errorObj[postObjectPropertyKey] = 'unknown field'
        unknownProperties.push errorObj

    if unknownProperties.length > 0
      res.jsonAPIRespond _.extend config.errorResponse(400), {messages: unknownProperties}
      return



    #collect everything wrong with the object to send back to user
    objectValidationErrors = []

    #Test some validations on resourceModel, namely ENUM types
    for propertyName, propertyValue of object

      testAttribute = resourceModel.rawAttributes[propertyName]
      if !_.isUndefined testAttribute

        if testAttribute.type and (testAttribute.type is 'ENUM')
          if testAttribute.values.indexOf(propertyValue) is -1
            #ERROR, non-allowed value
            errorObj = {}
            errorObj[propertyName] = 'invalid value'
            objectValidationErrors.push errorObj


        #Test some other validations
        if !_.isUndefined testAttribute.validate

          #alphanumeric
          if !_.isUndefined(testAttribute.validate.isAlphanumeric) and testAttribute.validate.isAlphanumeric
            if (propertyValue.length > 0) and !propertyValue.match(/^[0-9a-z]+$/)
              errorObj = {}
              errorObj[propertyName] = 'must be alphanumeric'
              objectValidationErrors.push errorObj

          #min/max length
          if !_.isUndefined(testAttribute.validate.len) and _.isArray(testAttribute.validate.len)
            if (propertyValue.length < testAttribute.validate.len[0]) || (propertyValue.length > testAttribute.validate.len[1])
              errorObj = {}
              errorObj[propertyName] = 'length must be between ' + testAttribute.validate.len[0] + ' and ' + testAttribute.validate.len[1]
              objectValidationErrors.push errorObj

    #if errors, abort
    if objectValidationErrors.length > 0
       res.jsonAPIRespond _.extend config.errorResponse(400), messages: objectValidationErrors
       return




  #Asynchronously execute callbacks, if all tests pass insert objects, otherwise return error
  uidMappings = {}
  async.series [
    (superCallback) ->

      propertyAsyncMethods = []
      for object, key in postObjects
        for propertyName, propertyValueCheckCallback of requirements.requiredProperties




          valueToTest = object[propertyName]

          ((valueToTest, propertyValueCheckCallback, scope, objectKey)->

            propertyAsyncMethods.push (callback) ->
              propertyValueCheckCallback.call scope, valueToTest, objectKey, callback

          )(valueToTest, propertyValueCheckCallback, scope, key)




      async.parallel propertyAsyncMethods, (err, results) ->

        #uidMappings   = {}
        errorMessages = []
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
            postObjects[val.transform[0]][val.transform[1]] = val.transform[2]


        if errorMessages.length > 0
          res.jsonAPIRespond _.extend config.errorResponse(400), messages: errorMessages
          superCallback(new Error 'object property test failed')
          return

        #success
        superCallback(null, uidMappings)

    (superCallback) ->



      for object, key in postObjects

        #Give everyone their own brand new uid
        postObjects[key]['uid'] = uuid.v4()

        for objectPropKey, objectPropValue of object

          suffix = 'Uid'
          if objectPropKey.indexOf(suffix, objectPropKey.length - suffix.length) > -1
            #This property ends in Uid

            propertyAssocId  = uidMappings[objectPropValue]
            propertyPrefix   = objectPropKey.substring(0, objectPropKey.indexOf('Uid'))
            postObjects[key][propertyPrefix + 'Id'] = propertyAssocId



      console.log 'uidMappings'
      console.log uidMappings
      console.log 'postObjects'
      console.log postObjects

      async.map postObjects, (item, callback) ->

        resourceModel.create(item).success () ->
          callback()

      , (err, results) ->
        res.jsonAPIRespond(code: 201, message: config.apiResponseCodes[201])



  ]








