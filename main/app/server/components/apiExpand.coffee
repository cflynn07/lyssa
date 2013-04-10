###
Module for managing api resource expansion relationships,
permissions, and validation
###

config    = require '../config/config'
_         = require 'underscore'
ORM       = require config.appRoot + '/server/components/orm'
sequelize = ORM.setup()
async     = require 'async'

module.exports = (req, res, resource, resourceQueryParams) ->

  console.log req.apiExpand

  #Verify extend parameter is valid if it exists
  #extend may be a string (HTTP) or an object (socketio)
  #returns boolean
  isValidExtend = (req) ->
    #verify extend

    checkHelper = (expandArray) ->
      for v in expandArray
        if !_.isObject v
          return false
        if typeof v.resource is not 'string'
          return false
      return true

    if _.isArray(req.apiExpand) or _.isString(req.apiExpand)

      if _.isArray(req.apiExpand)
        return checkHelper(req.apiExpand)

      else if _.isString(req.apiExpand)
        try
          req.apiExpand = JSON.parse req.apiExpand
        catch e
          #invalid JSON
          return false

        return checkHelper req.apiExpand

    #No api expand
    req.apiExpand = []
    return true




  #recursively iterates over verified extend parameter and checks each association is valid
  #and that no circular associations or duplicate associations are attempted
  isValidExtendAssociation = (resource, req) ->

    #verify no circular references, which shouldn't be possible anways
    #since we're only allowing "downstream" (hasMany, hasOne) associations
    #to be extended/fetched
    extendedModels = []
    downstreamAssociations = []

    for name, item of resource.associations
      if item.associationType.toLowerCase() is 'hasmany'
        downstreamAssociations.push (item.target.name + 's')
      if item.associationType.toLowerCase() is 'hasone'
        downstreamAssociations.push item.target.name

    for v in req.apiExpand
      if downstreamAssociations.indexOf(v.resource) == -1
        return false
      if extendedModels.indexOf(v.resource) != -1
        return false
      extendedModels.push v.resource

    return true



  #abort if invalid 'extend' parameter
  if !isValidExtend(req)
    res.jsonAPIRespond(_.extend({message: 'invalid expand format'}, config.errorResponse(400)))
    return

  #abort if invalid association-extend in 'extend' parameter
  if !isValidExtendAssociation(resource, req)
    console.log 'FAIL!'
    res.jsonAPIRespond(_.extend({message: 'invalid/unknown expand resource specified'}, config.errorResponse(400)))
    return




  include       = []
  secondInclude = []

  for v in req.apiExpand
    include.push ORM.model(v.resource.replace(/s+$/, ''))

    #if _.isArray v.expand
      #for k in v.expand
        #if !
        #secondInclude.push {parent: ORM.model(v.resource.replace(/s+$/, '')), child: ORM.model(k.resource.replace(/s+$/, ''))}



  findObj =
    include: include
  findMethod = 'findAll'

  if resourceQueryParams
    findObj.where = resourceQueryParams
    findMethod = 'find'

  resource[findMethod](findObj).success (result) ->

    if secondInclude.length > 0
      res.jsonAPIRespond
        code: 404
        message: 'still working on 2nd level nested associations'
    else
      res.jsonAPIRespond
        code: 200
        response: result





















