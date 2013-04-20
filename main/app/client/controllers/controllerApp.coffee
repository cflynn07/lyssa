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

    Module.controller 'ControllerApp' , ($scope, $route) ->

      #temp
      $scope.rootStatus = 'authenticated'

      $scope.user =
        firstName: 'Casey1'
        lastName: 'Flynn2'

      $scope.$on 'changeIt', (e, data) ->
        $scope.rootStatus = data
