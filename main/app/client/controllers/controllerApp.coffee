define [
  'angular'
  'text!views/viewCore.html'
], (
  angular
  viewCore
) ->

  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewCore', viewCore

    Module.controller 'ControllerApp' , ($scope, $route, socket) ->

      $scope.$on '$routeChangeSuccess', (event, current, previous) ->
        #$scope.action = current.$$route.action

      #temp
      $scope.rootStatus = 'login'
      $scope.loadingStatus = 'Establishing Secure Connection...'
      socket.emit 'authenticate:status', {}, (data) ->

        if data.authenticated
          $scope.rootStatus = 'authenticated'
        else
          $scope.rootStatus = 'login'

      $scope.user =
        firstName: 'Casey1'
        lastName: 'Flynn2'

      $scope.$on 'changeIt', (e, data) ->
        $scope.rootStatus = data
