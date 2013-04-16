config = require '../config/config'
async  = require 'async'
_      = require 'underscore'


module.exports = (resourceModel, objects, requirements) ->

  unknownProperties = []
  for object, key in objects

    #Instead of enforcing no missing properties HERE, enforce no unknown properties

    for postObjectPropertyKey, postObjectPropertyValue of object

      if _.isUndefined(requirements.requiredProperties[postObjectPropertyKey])
        errorObj = {}
        errorObj[postObjectPropertyKey] = 'unknown field'
        unknownProperties.push errorObj

  return unknownProperties
