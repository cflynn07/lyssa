define [
  'jquery'
  'angular'
  'text!views/viewCore.html'
], (
  $
  angular
  viewCore
) ->

  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewCore', viewCore

    Module.controller 'ControllerApp' , ($rootScope, $route, socket, authenticate) ->

      #quick hack
      $('body').removeClass 'login'


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
