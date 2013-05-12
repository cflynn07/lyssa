###
Module for managing api resource expansion relationships,
permissions, and validation
###


config    = require '../config/config'
_         = require 'underscore'
ORM       = require config.appRoot + 'server/components/oRM'
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
  sendFinalResult = (topResult, topSetLen) ->

    topResultJSON = JSON.parse JSON.stringify topResult
    recursiveCleanProps topResultJSON

    #if single array, just return object
    if _.isArray(topResultJSON) and topResultJSON.length is 1
      topResultJSON = topResultJSON[0]

    #override if specified to wrap in array
    if !_.isArray(topResultJSON) and resourceQueryParams.searchExpectsMultiple
      topResultJSON = [topResultJSON]

    returnResult =
      data:   topResultJSON
      length: topSetLen
      offset: resourceQueryParams.find.offset
      limit:  resourceQueryParams.find.limit

    res.jsonAPIRespond
      code: 200
      response: returnResult

    #Join rooms here for all requested resources
    if !_.isUndefined(req.io) and _.isFunction(req.io.join)
      if !_.isUndefined(req.session) and !_.isUndefined(req.session.user) and !_.isUndefined(req.session.user.clientUid)

          roomName = req.session.user.clientUid + '-postResources'
          req.io.join(roomName)
          #console.log 'joined room ' + roomName

      #if _.isUndefined(resourceQueryParams.find) || _.isUndefined(resourceQueryParams.find.where) || _.isUndefined(resourceQueryParams.find.where.uid)
      #  if !_.isUndefined(req.session) and !_.isUndefined(req.session.user) and !_.isUndefined(req.session.user.clientUid)
      #    req.io.join(req.session.user.clientUid + '-' + resource.name)
      #    console.log 'joined room ' + req.session.user.clientUid + '-postResources'



      recursiveBindToRooms = (collection) ->

        if !_.isArray collection
          collection = [collection]

        for obj in collection

          if !_.isUndefined obj['uid']
            req.io.join obj.uid
            #console.log 'join room: ' + obj.uid

          for propertyName, propertyValue of obj
            if _.isArray propertyValue
              recursiveBindToRooms propertyValue

      recursiveBindToRooms topResultJSON






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


  maxLimit = 500

  #Default offset & limit
  resourceQueryParams.find.offset = 0        #req.query.offset
  resourceQueryParams.find.limit  = maxLimit #req.query.limit

  #check supplied limit & offset
  if !_.isUndefined(req.query.limit)
    limit = Math.floor(parseInt(req.query.limit, 10))
    if !_.isNaN(limit) and _.isNumber(limit)
      if limit <= maxLimit
        resourceQueryParams.find.limit = limit

  if !_.isUndefined(req.query.offset)
    offset = Math.floor(parseInt(req.query.offset, 10))
    console.log 'offset: ' + offset
    if !_.isNaN(offset) and _.isNumber(offset)
      resourceQueryParams.find.offset = offset


  #console.log 'secondLevelIncludeObjects'
  #console.log secondLevelIncludeObjects
  #client ->
  #  employees -> expand to
  #    { employees: [ { resource: 'templates' }, { resource: 'revisions' } ] }

  if !_.isUndefined(resourceQueryParams.find) and !_.isUndefined(resourceQueryParams.find.where) and !_.isUndefined(resourceQueryParams.find.where.uid)
    if !_.isArray resourceQueryParams.find.where.uid
      resourceQueryParams.find.where.uid = [resourceQueryParams.find.where.uid]

  # {raw:true}

  checkOrderQueryProperty = (order) ->
    if !_.isArray order
      return false

    for val in order
      if !_.isArray(val) or val.length != 2
        return false
      for subVal in val
        if !_.isString subVal
          return false

    for val in order
      if !checkPropertiesAgainstResource(val[0])
        return false
      if (val[1].toLowerCase() != 'asc') and (val[1].toLowerCase() != 'desc')
        return false
    return true

  checkFilterQueryProperty = (filter) ->
    if !_.isArray filter
      return false

    for val in filter
      if !_.isArray(val) or val.length != 3
        return false
      for subVal in val
        if !_.isString subVal
          return false

    for val in filter
      if !checkPropertiesAgainstResource(val[0])
        return false
      if (val[1] != '=') and (val[1] != '!=') and (val[1].toLowerCase() != 'like')
        return false
      if val[2].length > 200
        return false
    return true

  checkPropertiesAgainstResource = (property) ->
    if _.isUndefined(resource.rawAttributes[property])
      return false
    if property == 'uid'
      return false
    if property == 'id'
      return false
    if property == 'clientUid'
      return false
    return true


  #IF (offset || limit) && include
    #We must look up the 'ids' of the parent resource and filter by those
  findCopy = _.extend {}, resourceQueryParams.find
  delete findCopy.include
  delete findCopy.offset
  delete findCopy.limit
  findCopy.attributes = ['id']

  #Hunt down ID's to grab, & total result set length...
  resource[resourceQueryParams.method](findCopy).success (filterIds) ->

    totalSetLen    = filterIds.length
    offsetLimitSet = filterIds.splice resourceQueryParams.find.offset, resourceQueryParams.find.limit

    filterIdsArr = []
    for obj in offsetLimitSet
      filterIdsArr.push obj.id
    resourceQueryParams.find.where.id = filterIdsArr

    findRealCopy = _.extend {}, resourceQueryParams.find
    delete findRealCopy.limit
    delete findRealCopy.offset

    whereString = ''
    for prop, val of findRealCopy.where
      if _.isArray(val) and val.length > 0
        whereString += '`' + resource.tableName + '`.`' + prop + '` IN (' + val.join() + ') and '
      else
        whereString += '`' + resource.tableName + '`.`' + prop + '` = \'' + val + '\' and '




    #User supplied stuff begins here... danger zone
    if !_.isUndefined(req.query.filter)
      try
        filters = JSON.parse req.query.filter
      catch e
        res.jsonAPIRespond config.apiErrorResponse 'invalidFilterQuery'
        return

      if !checkFilterQueryProperty(filters)
        res.jsonAPIRespond config.apiErrorResponse 'invalidFilterQuery'
        return

      #filters = JSON.parse req.query.filter
      for filterArr in filters
        if filterArr[1].toLowerCase() == 'like'
          whereString += '`' + resource.tableName + '`.`' + filterArr[0] + '` COLLATE UTF8_GENERAL_CI ' + filterArr[1].toUpperCase() + ' \'%' + filterArr[2] + '%\' and '
        else
          whereString += '`' + resource.tableName + '`.`' + filterArr[0] + '` COLLATE UTF8_GENERAL_CI ' + filterArr[1] + ' \'' + filterArr[2] + '\' and '

    whereString = whereString.substring(0, whereString.length - 5)
    findRealCopy.where = whereString

    if !_.isUndefined(req.query.order)
      try
        orders = JSON.parse req.query.order
      catch e
        res.jsonAPIRespond config.apiErrorResponse 'invalidOrderQuery'
        return

      if !checkOrderQueryProperty(orders)
        res.jsonAPIRespond config.apiErrorResponse 'invalidOrderQuery'
        return

      orderArray = []
      for order in orders
        orderArray.push '`' + resource.tableName + '`.`' + order[0] + '` ' + order[1].toUpperCase()

      findRealCopy.order = orderArray




    #Find actualy query based on ids
    resource[resourceQueryParams.method](findRealCopy).success (topResult) ->

      if !_.isArray topResult
        topResult = [topResult]

      #Verify no unknown resources specified
      if !verifyNoUnknownResource topResult, resourceQueryParams.find
        return

      if Object.getOwnPropertyNames(secondLevelIncludeObjects).length is 0
        #DONE, Nothing else to include
        sendFinalResult topResult, totalSetLen

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
          sendFinalResult topResult, totalSetLen




