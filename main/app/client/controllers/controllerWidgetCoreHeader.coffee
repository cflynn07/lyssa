define [
  'angular'
  'text!views/viewWidgetCoreHeader.html'
], (
  angular
  viewWidgetCoreHeader
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetCoreHeader', viewWidgetCoreHeader

    Module.controller 'ControllerWidgetCoreHeader', ($scope, authenticate) ->
      console.log $scope.rootUser
      $scope.logout = () ->
        authenticate.unauthenticate()
