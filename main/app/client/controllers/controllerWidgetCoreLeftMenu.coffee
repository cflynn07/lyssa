define [
  'jquery'
  'underscore'
  'angular'
  'text!views/viewWidgetCoreLeftMenu.html'
], (
  $
  _
  angular
  viewWidgetCoreLeftMenu
) ->

  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetCoreLeftMenu', viewWidgetCoreLeftMenu


    Module.controller 'ControllerWidgetCoreLeftMenu', ($scope, $route, $templateCache) ->


      $scope.menuChoices = [{
        hash: 'menu1a'
        title: 'Menu Option 1'
        sub: [{
          hash: 'menu1a'
          title: 'Menu Option 1'
        },{
          hash: 'menu1a/sub1'
          title: 'Menu Option 1sub'
        }]
      },{
        hash: 'menu2'
        title: 'Menu Option 2'
      },{
        hash: 'menu3'
        title: 'Menu Option 3'
      }]


      $scope.activeRoute = window.location.hash
      $scope.getClass    = (hash, isTop) ->
        hash      = '#/' + hash
        className = ''
        if isTop
          if $scope.activeRoute.indexOf(hash) == 0
            className = 'active'

        else
          if $scope.activeRoute == hash
            className = 'active'
        return className


      $scope.$on '$routeChangeSuccess', (scope, current, previous) ->
        $scope.activeRoute = window.location.hash






