define [
  'underscore'
  'text!config/clientOrmShare.json'
], (
  _
  clientOrmShare
) ->

  clientOrmShare = JSON.parse clientOrmShare

  (Module) ->
    Module.factory 'apiRequest', (socket, $rootScope) ->


      socket.on 'resourcePut', (data) ->
        if !_.isUndefined data['uid'] and !_.isUndefined resourcePool[data['uid']]
          updatePoolResource resourcePool[data['uid']], data

      socket.on 'resourcePost', (data) ->
        console.log 'resourcePost'
        console.log data




      #Hash of all ORM resources
      resourcePool = {}

      #Store results from open-ended (no specified uids) GET requests to resources
      resourcePoolCollections = {}


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
          isArray = true
          if !_.isArray passedValueObjOrArray
            isArray = false
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

      factory =
        # Request resources and bind callbacks
        get: (resourceName, uids = [], expand = {}, callback) ->

          if !validateResource resourceName
            return

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

          apiCollectionName = getCollectionName resourceName





          collectionHashSaved = false
          if !_.isUndefined resourcePoolCollections[apiCollectionName]
            collectionHashSaved = true
            callback({code: 200, response: resourcePoolCollections[apiCollectionName]})




          socket.apiRequest 'GET',
            '/' + apiCollectionName + '/' + uids.join(','),
            expand, #query
            {},     #data
            (response) ->

              if response.code == 200
                response.response = reconcileResultsWithPool (response.response)


                if uids.length == 0
                  #This was open-ended GET request. Store it.
                  resourcePoolCollections[apiCollectionName] = response.response


                if !allUids and !collectionHashSaved
                  callback response
              else
                if !allUids and !collectionHashSaved
                  callback response






        post: (resourceName) ->
          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName


        put: (resourceName, uid, properties, callback) ->
          if !validateResource resourceName
            return

          apiCollectionName = getCollectionName resourceName
          properties['uid'] = uid

          if !_.isUndefined resourcePool[uid]
            resourcePool[uid].isFresh = false

          socket.apiRequest 'PUT',
            '/' + apiCollectionName,
            {} #query
            properties, #data
            (response) ->

              if response.code == 202
                if !_.isUndefined resourcePool[uid]
                  updatePoolResource resourcePool[uid], properties

              callback(response)


        delete: (resourceName) ->
          if !validateResource resourceName
            return

