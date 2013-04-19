define [
  'angular'
  'text!views/viewWidgetCoreHeader.html'
], (
  angular
  viewWidgetCoreHeader
) ->

  ($scope, $templateCache) ->

    $templateCache.put 'viewWidgetCoreHeader', viewWidgetCoreHeader

    $scope.firstName = 'Casey'
    $scope.lastName  = 'Flynn'
