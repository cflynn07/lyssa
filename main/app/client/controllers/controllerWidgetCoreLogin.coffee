define [
  'angular'
  'text!views/viewWidgetCoreLogin.html'

], (
  angular
  viewWidgetCoreLogin
) ->

  ($scope, $templateCache) ->

    $templateCache.put 'viewWidgetCoreLogin', viewWidgetCoreLogin
