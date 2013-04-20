define [
  'angular'
  'text!views/viewWidgetCoreLogin.html'

], (
  angular
  viewWidgetCoreLogin
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetCoreLogin', viewWidgetCoreLogin

    Module.controller 'ControllerWidgetCoreLogin', ($scope, $templateCache) ->

