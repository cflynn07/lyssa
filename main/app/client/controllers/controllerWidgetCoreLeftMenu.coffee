define [
  'app'
  'jquery'
  'underscore'
  'text!views/widgetLeftMenu/viewWidgetCoreLeftMenu.html'
  'text!views/widgetLeftMenu/viewWidgetCoreLeftMenuOptionsAdmin.html'
  'text!views/widgetLeftMenu/viewWidgetCoreLeftMenuOptionsDelegate.html'
  'config/clientConfig'
], (
  app
  $
  _
  viewWidgetCoreLeftMenu
  viewWidgetCoreLeftMenuOptionsAdmin
  viewWidgetCoreLeftMenuOptionsDelegate
  clientConfig
) ->

  app.run [
    '$templateCache'
    ($templateCache) ->
      $templateCache.put 'viewWidgetCoreLeftMenu',                viewWidgetCoreLeftMenu
      $templateCache.put 'viewWidgetCoreLeftMenuOptionsAdmin',    viewWidgetCoreLeftMenuOptionsAdmin
      $templateCache.put 'viewWidgetCoreLeftMenuOptionsDelegate', viewWidgetCoreLeftMenuOptionsDelegate
  ]

  app.controller 'ControllerWidgetCoreLeftMenu', [
    '$scope'
    '$rootScope'
    '$route'
    '$templateCache'
    '$location'
    ($scope
      $rootScope
      $route
      $templateCache
      $location) ->

      if $scope.quizMode
        return false

      $rootScope.sidebarClosedToggle = () ->
        $rootScope.sidebarClosed = !$rootScope.sidebarClosed

      $scope.menuChoices = []

      $scope.currentActiveMenuItem = ''
      $scope.setCurrentActiveMenuItem = (item) ->
        if $scope.currentActiveMenuItem == item
          $scope.currentActiveMenuItem = ''
        else
          $scope.currentActiveMenuItem = item


      $scope.getClass = (menuTitle, isTop) ->
        className = ''
        if isTop
          if $scope.activeMenuItem.indexOf(menuTitle) == 0
            className = 'active'
        #className

      $scope.updateActiveMenuItem = () ->
        $scope.locationHash = $location.$$path
        ###
        $scope.activeMenuItem    = ''
        #$scope.activeSubMenuItem = ''
        if !_.isUndefined($route.current) and !_.isUndefined($route.current.pathValue)
          $scope.activeMenuItem = $route.current.pathValue.title
          $scope.locationHash   = $location.$$path
          #console.log '$location.$$path'
          #console.log $location.$$path
        ###

      $scope.$on '$routeChangeSuccess', (scope, current, previous) ->
        $scope.updateActiveMenuItem()
      $scope.updateActiveMenuItem()
  ]
