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

    missingProperties = []

    #verify this object has all properties of requiredProperties
    for requiredPropertyKey, requiredPropertyValue of requirements.requiredProperties

      #is requiredProperty in object
      if _.isUndefined object[requiredPropertyKey]
        missingProperties.push requiredPropertyKey

    if missingProperties.length > 0
      res.jsonAPIRespond _.extend config.errorResponse(400), {missingProperties: missingProperties, objectMissingProperties:key}
      return


  ###
  Asynchronously execute callbacks, if all tests pass insert objects, otherwise return error
  ###
  async.series [
    (superCallback) ->

      propertyAsyncMethods = []
      for object, key in postObjects
        for propertyName, propertyValueCheckCallback of requirements.requiredProperties

          valueToTest = object[propertyName]

          ((valueToTest, propertyValueCheckCallback, scope)->

            propertyAsyncMethods.push (callback) ->
              propertyValueCheckCallback.call scope, valueToTest, callback

          )(valueToTest, propertyValueCheckCallback, scope)

      async.parallel propertyAsyncMethods, (err, results) ->

        #results will be array of results from each callback test
        for val in results

          if val.result is false
            res.jsonAPIRespond _.extend config.errorResponse(400)
            superCallback(new Error 'object property test failed')
            return

        superCallback()

    (superCallback) ->
      #If we get to this point, we're good to insert and respond

      res.jsonAPIRespond success: 'you made it to the finish line'

  ]
