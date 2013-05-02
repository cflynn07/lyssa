define [
  'underscore'
  #'uuid'
  'text!config/clientOrmShare.json'
], (
  _
  #uuid
  clientOrmShare
) ->

  clientOrmShare = JSON.parse clientOrmShare

  (Module) ->
    Module.factory 'apiRequest', (socket, $rootScope) ->

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
        console.log resourcePool[data['uid']]
        $rootScope.$broadcast 'resourcePut'
        if !_.isUndefined data['uid'] and !_.isUndefined resourcePool[data['uid']]
          updatePoolResource resourcePool[data['uid']], data
        console.log resourcePool[data['uid']]

      socket.on 'resourcePost', (data) ->
        console.log 'resourcePost'
        console.log data
        $rootScope.$broadcast 'resourcePost'
        if !_.isUndefined(data['resource']) and !_.isUndefined(data['resource']['uid']) and !_.isUndefined(data['resourceName']) and !_.isUndefined(data['apiCollectionName'])   # and !_.isUndefined(resourcePoolCollections[data['resourceName']])
          #resourcePoolCollections[data['resourceName']][data['resource']['uid']] = data['resource']

          #turn it into a hash obj on uid
          obj = {}
          obj[data['resource']['uid']] = data['resource']
          data['resource'] = obj

          #Add in to resourcePool also (this might be happening twice)
          _.extend resourcePool, data['resource']
          #attach to parent resources if exist
          attachResourcesToParentsInPool data['apiCollectionName'], data['resource']

          addResourcesToOpenEndedGet data['apiCollectionName'],
            data['resourceName'],
            data['resource'],
            {},
            false


      #
      # MSC Helpers
      #
      attachResourcesToParentsInPool = (apiCollectionName, resources) ->
        if !_.isArray resources
          resources = [resources]

        #Helper
        endsWith = (string, suffix) ->
          return string.indexOf(suffix, string.length - suffix.length) != -1

        for obj in resources
          for propName, propValue of obj #HASH

            for propName2, propValue2 of propValue  #RESOURCE OBJECT
              #Does it end in "Uid"
              if endsWith propName2, 'Uid'
                #Does the resource/hash (propValue2) exist in our pool?
                if !_.isUndefined resourcePool[propValue2]
                  if !_.isUndefined resourcePool[propValue2][apiCollectionName]
                    _.extend resourcePool[propValue2][apiCollectionName], obj





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
        _.extend poolResource, updatedResource
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

          for obj in passedValueObjOrArray

            if !_.isUndefined resourcePool[obj.uid]
              #We have it already
              updatePoolResource resourcePool[obj.uid], obj
              responseHash[obj.uid] = resourcePool[obj.uid]

            else
              #It's new
              addPoolResource obj
              responseHash[obj.uid] = obj

            for objKey, objValue of obj
              if _.isArray objValue
                #We turn properties that are arrays of objects into hashes of objects indexed by Uid
                obj[objKey] = recursiveCallback objValue
                updatePoolResource resourcePool[obj.uid], obj

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
        return apiCollectionName

      #
      # Response Object
      #
      factory =



        get: (resourceName, uids = [], expand = {}, callback = null, cacheSyncRequest = false) ->

          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName


          #Opportunity to return from cache, then update cache if
          #we have all of the specified uids in the resourcePool
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
            allUids = false


          if uids.length == 0
            collectionHashSaved = false
            if !_.isUndefined resourcePoolCollections[apiCollectionName]
              collectionHashSaved = true
              if _.isFunction callback
                callback({code: 200, response: resourcePoolCollections[apiCollectionName]})


          socket.apiRequest 'GET',
            '/' + apiCollectionName + '/' + uids.join(','),
            expand, #query
            {},     #data
            (response) ->

              if response.code == 200

                #HERE we turn array into hash indexed by uids
                response.response = reconcileResultsWithPool (response.response)

                if uids.length == 0
                  #This was open-ended GET request. Store it.
                  #resourcePoolCollections[apiCollectionName] = response.response
                  addResourcesToOpenEndedGet apiCollectionName, resourceName, response.response, expand, cacheSyncRequest

                if !allUids and !collectionHashSaved
                  if _.isFunction callback
                    callback response
              else
                if !allUids and !collectionHashSaved
                  if _.isFunction callback
                    callback response




        post: (resourceName, objects, callback) ->
          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName

          socket.apiRequest 'POST',
            '/' + apiCollectionName,
            {}       #query
            objects, #data
            (response) ->
              #console.log 'response'
              #console.log response
              #console.log callback
              callback(response)


        put: (resourceName, uid, properties, callback) ->
          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName
          properties['uid'] = uid

          if !_.isUndefined resourcePool[uid]
            resourcePool[uid].isFresh = false
            _.extend resourcePool[uid], properties


          socket.apiRequest 'PUT',
            '/' + apiCollectionName,
            {} #query
            properties, #data
            (response) ->

              if response.code == 202
                if !_.isUndefined resourcePool[uid]
                  updatePoolResource resourcePool[uid], properties

              callback(response)


        delete: (resourceName, uid, callback) ->
          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName


          if !_.isUndefined resourcePool[uid]
            resourcePool[uid].isFresh = false

          socket.apiRequest 'DELETE',
            '/' + apiCollectionName,
            {} #query
            uid, #data
            (response) ->

              callback response

