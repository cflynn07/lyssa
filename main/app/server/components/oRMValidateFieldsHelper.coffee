config = require '../config/config'
async  = require 'async'
_      = require 'underscore'

module.exports = (postObjects, resourceModel) ->

  #collect everything wrong with the object to send back to user
  objectValidationErrors = []

  for object, key in postObjects
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

  return objectValidationErrors
