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
    if _.isArray v.expand
      for k in v.expand
        secondInclude.push {parentName: v.resource, parentModel: ORM.model(v.resource.replace(/s+$/, '')), childModel: ORM.model(k.resource.replace(/s+$/, ''))}





  if include.length > 0
    resourceQueryParams.find.include = include




  resource[resourceQueryParams.method](resourceQueryParams.find).success (topResult) ->





    if secondInclude.length > 0
      if !_.isArray(topResult)
        topResult = [topResult]

      asyncMethods = []

      for subResult, subResultIndex in topResult
        #ONCE 1

        console.log '------ EACH CLIENT -----'

        for includeItem in secondInclude
          #ALSO ONCE
          console.log '------ ONCE FOR EACH CLIENT -------'

          ids = []
          unextendedFetchedItems = subResult[includeItem.parentName]

          if unextendedFetchedItems.length > 0

            #Get all the ids we need to grab for this item
            for itemToExtend in unextendedFetchedItems
              ids.push itemToExtend.id

            #Now that we have all the ids... go fetch
            ((includeItemCap, subResultCap, subResultIndexCap, topResultCap, idsCap) ->


              asyncMethods.push (callback) ->

                includeItemCap.parentModel.findAll(
                  where:
                    id: idsCap
                  include: [includeItemCap.childModel]
                ).success (result) ->

                  topResultCap[subResultIndexCap][includeItemCap.parentName] = result
                  callback()


            )(includeItem, subResult, subResultIndex, topResult, ids)






      async.parallel asyncMethods, () ->

        console.log 'das methods est completen'
        console.log JSON.parse JSON.stringify topResult


        #Now we must clear out "id" and "password" props
        #NOTE: topResult should still be an array
        recursiveCleanProps = (arr, parentName, parentUid = false, lvl=0) ->

          for subResult in arr

            for subResultPropertyKey, subResultPropertyValue of subResult
              if _.isArray(subResultPropertyValue)

                #This should only happen on the first top-level iteration,
                #after a recursive call it will be filled out
                if lvl is 0
                  parentUid = subResult.uid
                else
                  parentName = subResultPropertyKey.replace(/s+$/, '')


                recursiveCleanProps(subResultPropertyValue, parentName, parentUid, (lvl + 1))


              else


                if (subResultPropertyKey is 'id') or (subResultPropertyKey is 'password')
                  delete subResult[subResultPropertyKey]

                if (subResultPropertyKey.indexOf('Id') > -1)
                  delete subResult[subResultPropertyKey]

                #if (parentName + 'Id' is subResultPropertyKey)
                #  subResult[subResultPropertyKey] = parentUid





        topResultJSON = JSON.parse JSON.stringify topResult
        recursiveCleanProps topResultJSON, 'client'

        console.log '-----------'
        console.log topResultJSON
        for item in topResultJSON
          console.log item





        res.jsonAPIRespond
          code: 200
          response: topResultJSON








          #else
          #  res.jsonAPIRespond
          #    code: 200
          #    response: topResult
          #  return




      #res.jsonAPIRespond
      #  code: 200
      #  response: topResult




      #console.log includeItem.parentName
      #console.log subResult[includeItem.parentName]
      ##Find all the ids of that item that were fetched
      #for unexpandedItem in subResult[includeItem.parentName]
      #  ids.push unexpandedItem.id




    #else
    #  res.jsonAPIRespond
    #    code: 200
    #    response: topResult





















