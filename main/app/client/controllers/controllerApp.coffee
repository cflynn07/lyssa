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

    Module.controller 'ControllerApp' , ['$rootScope', '$route', '$routeParams', 'socket', 'authenticate',
    ($rootScope, $route, $routeParams, socket, authenticate) ->


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

      $rootScope.clientConfig = clientConfig

      #quick hack
      $('body').removeClass 'login'
      $('body').css('background-color', '#444').animate({'background-color':'#F1F1F1'}, 'slow')

      $rootScope.clientOrmShare = clientOrmShare

      #temp
      $rootScope.rootStatus    = 'loading'

      $rootScope.loadingStatus      = 'Connecting...'
      $rootScope.loadingStatusColor = '#35aa47 !important'
      $rootScope.loadingStatusIcon  = 'icon-lock'

      $rootScope.routeParams = $routeParams

      #QuizMode
      $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
        $rootScope.routeParams = $routeParams

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
