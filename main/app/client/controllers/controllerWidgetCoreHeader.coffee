define [
  'angular'
  'text!views/viewWidgetCoreHeader.html'
], (
  angular
  viewWidgetCoreHeader
) ->
  (Module) ->

    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewWidgetCoreHeader', viewWidgetCoreHeader
    ]

    Module.controller 'ControllerWidgetCoreHeader', ['$scope', 'authenticate',
    ($scope, authenticate) ->
      $scope.logout = () ->
        authenticate.unauthenticate()
    ]
