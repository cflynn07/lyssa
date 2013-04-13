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

  #Verify extend parameter is valid if it exists
  #extend may be a string (HTTP) or an object (socketio)
  #returns boolean

  isValidExtend = (req) ->
    #verify extend

    checkHelper = (expandArray) ->
      for v in expandArray
        if !_.isObject v
          return false
        if !_.isString(v.resource)
          return false


        if !_.isUndefined(v.expand)

          if _.isArray(v.expand)
            return checkHelper(v.expand)
          else
            return false

        else
          return true


    if !_.isUndefined(req.apiExpand)   # and (_.isArray(req.apiExpand) or _.isString(req.apiExpand))
      if _.isArray(req.apiExpand)
        return checkHelper(req.apiExpand)

      else if _.isString(req.apiExpand)
        try
          req.apiExpand = JSON.parse req.apiExpand
        catch e
          #invalid JSON
          return false
        return checkHelper req.apiExpand

    else
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


  ###
  Determine if any tree branch extends beyond 2 levels
  ###
  isExtendShallowerThanThree = (req) ->

    maxLvl = 2
    if _.isUndefined req.apiExpand
      return true

    recursiveHelper = (exp, lvl) ->

      if lvl > maxLvl
        return false

      childNodesTests = []
      for val, key in exp
        if !_.isUndefined(val.expand)
          childNodesTests.push recursiveHelper(val.expand, (lvl+1))

      for val in childNodesTests
        if val is false
          return false
      return true

    return recursiveHelper(req.apiExpand, 1)


  #Now we must clear out "id" and "password" props
  #NOTE: topResult should still be an array
  recursiveCleanProps = (arr) ->
    for subResult in arr
      for subResultPropertyKey, subResultPropertyValue of subResult
        if _.isArray(subResultPropertyValue)
          recursiveCleanProps(subResultPropertyValue)

        else

          if (subResultPropertyKey is 'id') or (subResultPropertyKey is 'password')
            delete subResult[subResultPropertyKey]

          if (subResultPropertyKey.indexOf('Id') > -1)
            delete subResult[subResultPropertyKey]



  #Checks result against request uids, verifies match
  verifyNoUnknownResource = (topResult, find) ->

    topResult = JSON.parse JSON.stringify topResult

    if !find.where or !find.where.uid
      return true

    if topResult.length is find.where.uid.length
      return true


    #Mismatch between # of results and # of ids specified, find missing results
    unknownUids = []

    if _.isArray find.where.uid
      for specUid in find.where.uid

        found = false
        for result in topResult
          if result.uid is specUid
            found = true
            break

        if !found
          unknownUids.push specUid

    res.jsonAPIRespond _.extend config.apiErrorResponse('unknownRootResourceId'), {unknownUids: unknownUids}
    return false



  #DRY - this optionally gets invoked from two places
  sendFinalResult = (topResult) ->
    topResultJSON = JSON.parse JSON.stringify topResult
    recursiveCleanProps topResultJSON

    #if single array, just return object
    if _.isArray(topResultJSON) and topResultJSON.length is 1
      topResultJSON = topResultJSON[0]

    #override if specified to wrap in array
    if !_.isArray(topResultJSON) and resourceQueryParams.searchExpectsMultiple
      topResultJSON = [topResultJSON]

    res.jsonAPIRespond
      code: 200
      response: topResultJSON


  ###
  STANDARD CHECKS...
  ###

  #abort if invalid 'extend' parameter
  if !isValidExtend(req)
    res.jsonAPIRespond config.apiErrorResponse 'invalidExpandJSON'
    return

  #abort if invalid association-extend in 'extend' parameter
  if !isValidExtendAssociation(resource, req)
    res.jsonAPIRespond config.apiErrorResponse 'unknownExpandResource'
    return

  if !isExtendShallowerThanThree(req)
    res.jsonAPIRespond config.apiErrorResponse 'nestedTooDeep'
    return




  firstLevelIncludeModels = []
  secondLevelIncludeObjects = {}


  for firstLevelIncludeObject in req.apiExpand

    firstLevelIncludedResourceName = firstLevelIncludeObject.resource
    firstLevelIncludedModelName    = firstLevelIncludeObject.resource.replace(/s+$/, '')
    firstLevelIncludeModels.push ORM.model firstLevelIncludedModelName


    if _.isArray(firstLevelIncludeObject.expand)
      for secondLevelExpandIncludeObject in firstLevelIncludeObject.expand

        if _.isUndefined secondLevelIncludeObjects[firstLevelIncludedResourceName]
          secondLevelIncludeObjects[firstLevelIncludedResourceName] = [secondLevelExpandIncludeObject]
        else
          secondLevelIncludeObjects[firstLevelIncludedResourceName].push secondLevelExpandIncludeObject


  if firstLevelIncludeModels.length > 0
    resourceQueryParams.find.include = firstLevelIncludeModels


  #console.log 'secondLevelIncludeObjects'
  #console.log secondLevelIncludeObjects
  #client ->
  #  employees -> expand to
  #    { employees: [ { resource: 'templates' }, { resource: 'revisions' } ] }


  if resourceQueryParams.find and resourceQueryParams.find.where and resourceQueryParams.find.where.uid
    if !_.isArray resourceQueryParams.find.where.uid
      resourceQueryParams.find.where.uid = [resourceQueryParams.find.where.uid]


  resource[resourceQueryParams.method](resourceQueryParams.find).success (topResult) ->

    if !_.isArray topResult
      topResult = [topResult]


    #Verify no unknown resources specified
    if !verifyNoUnknownResource topResult, resourceQueryParams.find
      return


    if Object.getOwnPropertyNames(secondLevelIncludeObjects).length is 0
      #DONE, Nothing else to include
      sendFinalResult topResult
    else

      topResult = JSON.parse JSON.stringify topResult

      #console.log topResult

      asyncMethods = []

      for subResult in topResult

        #topResult == all clients []
          #subResult == each client {}

        #console.log secondLevelIncludeObjects
        #continue

        for subResultPropertyToExpandKey, expandResourceObjectArrayValue of secondLevelIncludeObjects

          #console.log subResultPropertyToExpandKey
          #console.log expandResourceObjectArrayValue
          #continue

          #client
          # -> employees... == subResultPropertyToExpandKey
          # -> templates... == subResultPropertyToExpandKey

          subResourceToExpandModel = ORM.model subResultPropertyToExpandKey.replace(/s+$/, '')

          #console.log '======================='
          #console.log subResult
          #console.log subResultPropertyToExpandKey
          #console.log '======================='

          subResourceIds = []
          for subResource in subResult[subResultPropertyToExpandKey]
            subResourceIds.push subResource.id

          subResourceExpandModels = []


          #console.log 'expandResourceObjectArrayValue'
          #console.log expandResourceObjectArrayValue
          #console.log '-------'


          for resourceObject in expandResourceObjectArrayValue
            ##resourceObject == { resource: 'modelname' }
            #build array of models to use w/ expansion of
            model = ORM.model resourceObject.resource.replace(/s+$/, '')
            if model
              subResourceExpandModels.push model

          ((asyncMethods, subResourceToExpandModel, subResourceIds, subResourceExpandModels, subResult, subResultPropertyToExpandKey) ->

            asyncMethods.push (callback) ->

              subResourceToExpandModel.findAll(
                where:
                  id: subResourceIds
                include: subResourceExpandModels
              ).success (resultNewSubResource) ->
                subResult[subResultPropertyToExpandKey] = resultNewSubResource
                callback()

          )(asyncMethods, subResourceToExpandModel, subResourceIds, subResourceExpandModels, subResult, subResultPropertyToExpandKey)


      async.parallel asyncMethods, () ->
        sendFinalResult topResult
        return



