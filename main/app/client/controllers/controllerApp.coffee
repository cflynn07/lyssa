define [
  'jquery'
  'angular'
  'text!views/viewCore.html'
  'text!config/clientOrmShare.json'
], (
  $
  angular
  viewCore
  clientOrmShare
) ->

  clientOrmShare = JSON.parse clientOrmShare

  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewCore', viewCore

    Module.controller 'ControllerApp' , ($rootScope, $route, socket, authenticate) ->

      #quick hack
      $('body').removeClass 'login'


      $rootScope.clientOrmShare = clientOrmShare


      #temp
      $rootScope.rootStatus    = 'loading'
      $rootScope.loadingStatus = 'Establishing Secure Connection...'

      #Get status, determine if user is authenticated or not.
      #unauthenticated shows login prompt, authenticated shows application
      socket.emit 'authenticate:status', {}, (response) ->
        if response.authenticated and response.user
          authenticate.authenticate response.user
        else
          authenticate.unauthenticate()
