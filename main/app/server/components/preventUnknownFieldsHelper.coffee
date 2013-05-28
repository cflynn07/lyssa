config = require '../config/config'
async  = require 'async'
_      = require 'underscore'


module.exports = (resourceModel, objects, requirements) ->

  #console.log 'requirements'
  #console.log requirements

  unknownProperties = []
  for object, key in objects

    #Instead of enforcing no missing properties HERE, enforce no unknown properties

    for objectPropertyKey, objectPropertyValue of object

      if _.isUndefined(requirements.requiredProperties[objectPropertyKey])

        errorObj                    = {}
        errorObj[objectPropertyKey] = 'unknown field'

        unknownProperties.push errorObj

  return unknownProperties
