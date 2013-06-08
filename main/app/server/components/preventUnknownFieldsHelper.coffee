config = require '../config/config'
async  = require 'async'
_      = require 'underscore'


module.exports = (resourceModel, objects, requirements) ->

  #console.log 'requirements'
  #console.log requirements


  #console.log config.resourceModelUnknownFieldsExceptions

  unknownProperties = []
  for object, key in objects

    #Instead of enforcing no missing properties HERE, enforce no unknown properties

    for objectPropertyKey, objectPropertyValue of object
      if _.isUndefined(requirements.requiredProperties[objectPropertyKey])

        #Check if this unknown property is an exception & DONT create error if so
        exceptionProperties = config.resourceModelUnknownFieldsExceptions[resourceModel.name]
        if _.isUndefined(exceptionProperties) || (exceptionProperties.indexOf(objectPropertyKey) is -1)
          errorObj                    = {}
          errorObj[objectPropertyKey] = 'unknown field'
          unknownProperties.push errorObj


  return unknownProperties
