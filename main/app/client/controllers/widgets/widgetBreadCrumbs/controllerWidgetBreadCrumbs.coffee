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

    Module.controller 'ControllerWidgetBreadCrumbs', ($scope, $templateCache, socket) ->
      $scope.title    = 'Themis'
      $scope.subtitle = 'by Cobar Systems LLC'
