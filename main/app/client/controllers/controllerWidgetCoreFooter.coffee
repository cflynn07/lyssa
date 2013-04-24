define [
  'angular'
  'text!views/viewWidgetCoreFooter.html'
], (
  angular
  viewWidgetCoreFooter
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetCoreFooter', viewWidgetCoreFooter

    Module.controller 'ControllerWidgetCoreFooter', ($scope, authenticate) ->
      $scope.logout = () ->
        authenticate.unauthenticate()
