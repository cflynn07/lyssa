define [
  'angular'
  'text!views/widgetBreadCrumbs/viewWidgetBreadCrumbs.html'
], (
  angular
  viewWidgetBreadCrumbs
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetBreadCrumbs', viewWidgetBreadCrumbs

    Module.controller 'ControllerWidgetBreadCrumbs', ($scope, $templateCache) ->

      $scope.title    = 'Test Title'
      $scope.subtitle = 'Test Subtitle'
