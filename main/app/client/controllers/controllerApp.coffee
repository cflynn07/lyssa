define [
  'angular'
  'text!views/viewCore.html'
], (
  angular
  viewCore
) ->

  ($scope, $route, $templateCache) ->

    $templateCache.put 'viewCore', viewCore

    #temp
    $scope.rootStatus = 'authenticated'

    $scope.$on 'changeIt', (e, data) ->
      $scope.rootStatus = data
