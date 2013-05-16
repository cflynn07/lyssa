define [
  'jquery'
  'underscore'
  'angular'
  'cs!config/clientConfig'
  'text!views/viewCore.html'
  'text!config/clientOrmShare.json'
], (
  $
  _
  angular
  clientConfig
  viewCore
  clientOrmShare
) ->

  clientOrmShare = JSON.parse clientOrmShare

  (Module) ->

    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewCore', viewCore
    ]

    Module.controller 'ControllerApp' , ['$rootScope', '$route', 'socket', 'authenticate',
    ($rootScope, $route, socket, authenticate) ->


      #Global Helpers
      $rootScope.getKeysLength = (obj) ->
        length = 0
        for key, value of obj
          if !_.isUndefined(value['uid']) and _.isNull(value['deletedAt'])
            length++
        return length

      $rootScope.escapeHtml = (str) ->
        div = document.createElement 'div'
        div.appendChild(document.createTextNode(str))
        div.innerHTML


      helperSortHash = (hash, timeProp = 'createdAt') ->
        hashArray       = _.toArray hash
        sortedHashArray = _.sortBy hashArray, (obj) ->
          new Date obj[timeProp]

      $rootScope.getLastObjectFromHash = (hash, timeProp = 'createdAt') ->
        sortedHashArray = helperSortHash hash, timeProp
        _.last sortedHashArray

      $rootScope.getFirstObjectFromHash = (hash, timeProp = 'createdAt') ->
        sortedHashArray = helperSortHash hash, timeProp
        _.first sortedHashArray

      $rootScope.getArrayFromHash = (hash) ->
        resArray = []
        for prop, val of hash
          resArray.push val
        #Sorting?
        return resArray

      #quick hack
      $('body').removeClass 'login'

      $rootScope.clientOrmShare = clientOrmShare

      #temp
      $rootScope.rootStatus    = 'loading'
      $rootScope.loadingStatus = 'Establishing Secure Connection...'



      #QuizMode
      $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
        if clientConfig.isRouteQuiz($route.current.path)
          $rootScope.quizMode = true
          return
        else
          $rootScope.quizMode = false



      #Get status, determine if user is authenticated or not.
      #unauthenticated shows login prompt, authenticated shows application
      socket.emit 'authenticate:status', {}, (response) ->
        if response.authenticated and response.user
          authenticate.authenticate response.user
        else
          authenticate.unauthenticate()

    ]
