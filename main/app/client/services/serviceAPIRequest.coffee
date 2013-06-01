define [
  'underscore'
  'uuid'
  'cs!utils/utilSortHash'
  'text!config/clientOrmShare.json'
], (
  _
  uuid
  utilSortHash
  clientOrmShare
) ->

  clientOrmShare = JSON.parse clientOrmShare

  (Module) ->
    Module.factory 'apiRequest', ['socket', '$rootScope',
    (socket, $rootScope) ->

      #Hash of all ORM resources
      resourcePool = {}

      #Make available...
      $rootScope.resourcePool = resourcePool

      #Store results from open-ended (no specified uids) GET requests to resources
      resourcePoolCollections = {}

      #Store all eager-loaded child resources for each open-ended query
      resourcePoolCollectionsExpands = {}


      #TODO: Account for parent/child relationship changes
      socket.on 'resourcePut', (data) ->
        console.log 'resourcePut'
        console.log data
        $rootScope.$broadcast 'resourcePut', data #['uid']

        if !_.isUndefined data['uid'] and !_.isUndefined resourcePool[data['uid']]
          updatePoolResource resourcePool[data['uid']], data

      socket.on 'resourcePost', (data) ->
        console.log 'resourcePost'
        console.log data
        $rootScope.$broadcast 'resourcePost', data #['uid']

        if !_.isUndefined(data['resource']) and !_.isUndefined(data['resource']['uid']) and !_.isUndefined(data['resourceName']) and !_.isUndefined(data['apiCollectionName'])   # and !_.isUndefined(resourcePoolCollections[data['resourceName']])
          #resourcePoolCollections[data['resourceName']][data['resource']['uid']] = data['resource']

          #turn it into a hash obj on uid
          obj = {}
          uid = data['resource']['uid']
          obj[uid] = data['resource']

          #Add in to resourcePool also (this might be happening twice)
          _.extend resourcePool, obj

          #data['resource'] = resourcePool[obj.uid]

          #attach to parent resources if exist
          attachResourcesToParentsInPool data['apiCollectionName'], data['resource']


          #addResourcesToOpenEndedGet data['apiCollectionName'],
          #  data['resourceName'],
          #  data['resource'],
          #  {},
          #  false




      #
      # MSC Helpers
      attachResourcesToParentsInPool = (apiCollectionName, resources) ->

        #console.log 'p3'
        #console.log arguments

        if !_.isArray resources
          resources = [resources]

        #Helper
        endsWith = (string, suffix) ->
          return string.indexOf(suffix, string.length - suffix.length) != -1


        for obj in resources
          for propName, propValue of obj #HASH

            if _.isObject(propValue) && !_.isArray(propValue) && !_.isUndefined(propValue.uid)
              reconcileResultsWithPool(propValue)

            #for propName, propValue of propValue  #RESOURCE OBJECT

            #Does it end in "Uid"
            if endsWith propName, 'Uid'

              #console.log 'p2'
              #console.log propName

              objHashed = {}
              uid = obj.uid
              objHashed[uid] = obj

              #Does the resource/hash (propValue) exist in our pool?
              if !_.isUndefined resourcePool[propValue]
                if !_.isUndefined resourcePool[propValue][apiCollectionName]
                  _.extend resourcePool[propValue][apiCollectionName], objHashed

                  #console.log 'p1'
                  #console.log resourcePool[propValue][apiCollectionName]

                else

                  #console.log 'p1a'

                  resourcePool[propValue][apiCollectionName] = {}
                  _.extend resourcePool[propValue][apiCollectionName], objHashed



      addResourcesToOpenEndedGet = (apiCollectionName, resourceName, resources, expand, cacheSyncRequest) ->

        if _.isUndefined resourcePoolCollections[apiCollectionName]
          resourcePoolCollections[apiCollectionName] = resources
        else
          _.extend resourcePoolCollections[apiCollectionName], resources

        presentExpand = resourcePoolCollectionsExpands[apiCollectionName]

        #First load, we don't need this
        if _.isUndefined presentExpand
          resourcePoolCollectionsExpands[apiCollectionName] = expand
          return

        #TODO: This runs more than it has to, fix
        #console.log '---'
        #console.log JSON.stringify presentExpand
        #console.log JSON.stringify expand

        if JSON.stringify(presentExpand) != JSON.stringify(expand)

          _.extend resourcePoolCollectionsExpands[apiCollectionName], expand

          if !cacheSyncRequest
            #We must execute a GET to load the nested resources

            factory.get resourceName, [], resourcePoolCollectionsExpands[apiCollectionName], (response) ->
              return

              #console.log 'updated eager associations'
              #console.log resourcePoolCollectionsExpands[apiCollectionName]
              #console.log response

            , true #Don't run again

      updatePoolResource = (poolResource, updatedResource) ->
        _.extend poolResource, updatedResource, true
        poolResource.isFresh = true

      addPoolResource = (resource) ->
        resourcePool[resource.uid] = resource
        resourcePool[resource.uid].isFresh = true




      #Merge each result with resourcePool hash
      reconcileResultsWithPool = (results) ->

        recursiveCallback = (passedValueObjOrArray) ->

          responseHash = {}

          #Temporary convert to array
          if !_.isArray passedValueObjOrArray
            passedValueObjOrArray = [passedValueObjOrArray]

          for obj in passedValueObjOrArray #<-- At this point it's an array ^


            if !_.isUndefined resourcePool[obj.uid]
              #We have it already
              updatePoolResource resourcePool[obj.uid], obj
              responseHash[obj.uid] = resourcePool[obj.uid]
            else
              #It's new
              addPoolResource obj
              responseHash[obj.uid] = obj



            for objKey, objValue of obj
              if _.isObject(objValue) and !_.isUndefined(objValue.uid)

                if !_.isUndefined(resourcePool[objValue.uid])
                  _.extend resourcePool[objValue.uid], objValue
                else
                  resourcePool[objValue.uid] = objValue
                objValue = resourcePool[objValue.uid]


            for objKey, objValue of obj
              if _.isArray(objValue)
                #We turn properties that are arrays of objects into hashes of objects indexed by Uid
                obj[objKey] = recursiveCallback objValue
                updatePoolResource resourcePool[obj.uid], obj

              else if (_.isObject(objValue) && !_.isUndefined(objValue.uid))
                if _.isUndefined resourcePool[obj.uid]
                  addPoolResource obj
                else
                  updatePoolResource resourcePool[obj.uid], obj

                recursiveCallback(objValue)

          return responseHash

        responseHash = recursiveCallback results
        return responseHash




      validateResource = (resourceName) ->
        if _.isUndefined clientOrmShare[resourceName]
          throw new Error resourceName + ' unknown'
          return false
        return true

      getCollectionName = (resourceName) ->
        apiCollectionName = resourceName + 's'
        #One exception to pluralization for dictionary
        if resourceName == 'dictionary'
          apiCollectionName = 'dictionaries'
        if resourceName == 'activity'
          apiCollectionName = 'activity'

        return apiCollectionName



      #To assist with caching API results by 4 params (offset, limit, filter, order)
      cacheHashIdentifier = (resourceName, options) ->

        defaultOptions =
          offset: 0
          limit:  300 #API DEF
          filter: []
          order:  []

        _.extend defaultOptions, options

        #Flatten arrays to aid in creating simple hash string
        #Must sort by propName
        filter = []
        filter = _.sortBy defaultOptions.filter, (arr) ->
          return arr[0] + arr[1] + [2]

        order = []
        order = _.sortBy defaultOptions.order, (arr) ->
          return arr[0] + arr[1]

        hashString = resourceName + defaultOptions.offset + defaultOptions.limit + JSON.stringify(filter) + JSON.stringify(order)
        return hashString




      #
      # Response Object
      #
      factory =

        get: (resourceName, uids = [], expand = {}, callback = null, cacheSyncRequest = false) ->

          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName

          hashString = cacheHashIdentifier apiCollectionName,
            offset: if expand.offset then expand.offset else 0
            limit:  if expand.limit  then expand.limit  else 300
            filter: if expand.filter then expand.filter else []
            order:  if expand.order  then expand.order  else []

          #console.log hashString

          #Opportunity to return from cache, then update cache if
          #we have all of the specified uids in the resourcePool
          ###
          allUids = true
          if uids.length > 0
            respObj = {}
            for uid in uids
              if _.isUndefined resourcePool[uid]
                allUids = false
                break
              else
                respObj[uid] = resourcePool[uid]
            if allUids
              callback({code: 200, response: respObj})
          else
          ###
          allUids = false


          if uids.length == 0
            collectionHashSaved = false
            #if !_.isUndefined resourcePoolCollections[apiCollectionName]
            if !_.isUndefined resourcePoolCollections[hashString]
              collectionHashSaved = true
              if _.isFunction callback
                callback({code: 200, response: resourcePoolCollections[hashString].response}, resourcePoolCollections[hashString].responseRaw, true)


          #if !allUids and !collectionHashSaved
          socket.apiRequest 'GET',
            '/' + apiCollectionName + '/' + uids.join(','),
            expand, #query
            {},     #data
            (response) ->

              responseRaw = JSON.stringify(response)

              #console.log 'x1'

              if response.code == 200

                #HERE we turn array into hash indexed by uids
                response.response.data = reconcileResultsWithPool response.response.data
                collectionHashSaved    = false

                #console.log 'x2'

                if uids.length == 0
                  #This was open-ended GET request. Store it.
                  resourcePoolCollections[hashString] =
                    response:    response.response
                    responseRaw: responseRaw
                  #addResourcesToOpenEndedGet apiCollectionName, resourceName, response.response.data, expand, cacheSyncRequest

                if !allUids and !collectionHashSaved
                  if _.isFunction callback
                    callback response, responseRaw, false

                #console.log 'x3'

              else
                if !allUids and !collectionHashSaved
                  if _.isFunction callback
                    callback response, responseRaw, false


              ###
              console.log '----'
              console.log 'resourcePool'
              console.log resourcePool
              console.log '----'
              console.log 'resourcePoolCollections'
              console.log resourcePoolCollections
              console.log '----'
              ###

        post: (resourceName, objects, query, callback) ->
          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName

          ###
          if !_.isArray objects
            objects = [objects]
          for obj in objects
            obj.tempUid = uuid.v4()
          ###

          socket.apiRequest 'POST',
            '/' + apiCollectionName,
            query,   #query
            objects, #data
            (response) ->
              #console.log 'response'
              #console.log response
              #console.log callback
              callback(response)

          ###
          for obj in objects
            obj.uid = obj.tempUid

          #attachResourcesToParentsInPool apiCollectionName, objects
          addResourcesToOpenEndedGet apiCollectionName, resourceName, objects, {}, false

          if !$rootScope.$$phase
            $rootScope.$apply()
          ###

          #helper


        put: (resourceName, uid, properties, query, callback) ->
          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName
          properties['uid'] = uid

          if !_.isUndefined resourcePool[uid]
            resourcePool[uid].isFresh = false
            _.extend resourcePool[uid], properties

          socket.apiRequest 'PUT',
            '/' + apiCollectionName,
            query,
            properties, #data
            (response) ->

              if response.code == 202
                if !_.isUndefined resourcePool[uid]
                  updatePoolResource resourcePool[uid], properties

              callback(response)


        delete: (resourceName, uid, query, callback) ->
          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName

          if !_.isUndefined resourcePool[uid]
            resourcePool[uid].isFresh   = false
            resourcePool[uid].deletedAt = (new Date()).toString()

          socket.apiRequest 'DELETE',
            '/' + apiCollectionName,
            query #query
            uid, #data
            (response) ->

              callback response

    ]

