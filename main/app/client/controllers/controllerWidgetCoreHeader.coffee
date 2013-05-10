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

    Module.controller 'ControllerWidgetCoreHeader', ['$scope', '$rootScope', 'authenticate',
    ($scope, $rootScope, authenticate) ->

      $scope.toggleTopBarOpen = () ->
        console.log 'top'
        $rootScope.topBarOpen = !$rootScope.topBarOpen

      $scope.logout = () ->
        authenticate.unauthenticate()
    ]
