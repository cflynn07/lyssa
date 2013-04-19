window.CS = angular.module('cs', [])


CS.config ($routeProvider) ->

  $routeProvider.when('/home/:id', {
    action: 'standard.test'
  }).otherwise({
    redirectTo: '/'
  })


CS.controller 'AppController', ['$scope', '$route', ($scope, $route) ->


  $scope.phones = [
    'android'
    'iphone'
    'nokia'
  ]


  $scope.$on '$routeChangeSuccess', ($currentRoute, $previousRoute) ->
    console.log 'p1'
    return



]
