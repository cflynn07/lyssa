define [
  'angular'
  'jquery'
  'underscore'
  'text!views/viewCoreWidgets.html'
  'cs!config/clientConfig'
], (
  angular
  $
  _
  viewCoreWidgets
  clientConfig
) ->

  (Module) ->

    Module.run ['$templateCache', 'apiRequest', '$routeParams', '$route',
    ($templateCache, apiRequest, $routeParams, $route) ->
      $templateCache.put 'viewCoreWidgets', viewCoreWidgets
    ]

    ###
      Manages the dynamic insertion of widgets to the main content area of the application
    ###
    Module.controller 'ControllerCoreWidgets', ['$scope', '$route', '$rootScope',
    ($scope, $route, $rootScope) ->

      $scope.widgetRows   = [{widget: 'viewWidgetBreadCrumbs'}]
      previousRouteGroup  = ''

      isDerivativeRoute   = (newRouteTitle) ->
        result = true

        if newRouteTitle != previousRouteGroup
          result = false
          previousRouteGroup = newRouteTitle
        return result

      stripAllButBC = () ->
        $scope.widgetRows.splice 0, 1

      trigger4oh4 = () ->
        widgets = stripAllButBC()
        widgets.push widget:'viewWidget4oh4'
        $scope.widgetRows = widgets
        previousRouteGroup = ''

      loadNewRoute = () ->

        #Determine if this is a valid application route
        if _.isUndefined($route.current) # || _.isUndefined($route.current.path) || _.isUndefined($route.current.pathValue)
          if previousRouteGroup == '' && $scope.rootUser
            window.location.hash = '/' + clientConfig.simplifiedUserCategories[$scope.rootUser.type] + '/themis'
            return
          else
            trigger4oh4()
            return


        #if !clientConfig.isRouteQuiz($route.current.path)
          #Determine if this is a valid route for the given user-type
          #console.log 'routeMatchClientType'
          #if !clientConfig.routeMatchClientType($route.current.path, $scope.rootUser.type)
          #  trigger4oh4()
          #  return

        #if !isDerivativeRoute($route.current.pathValue.title)

        if $route.current.$$route.group != previousRouteGroup
          previousRouteGroup = $route.current.$$route.group

          $('body').animate({scrollTop: 0}, 700)

          widgets = stripAllButBC()
          addWidgets = []

          for value in $route.current.$$route.widgetViews
            addWidgets.push widget: value
          $scope.widgetRows = widgets.concat addWidgets

          #Used by widgets for forming links
          $rootScope.viewRoot = $route.current.$$route.root


      $scope.$on '$routeChangeSuccess', (event, current, previous) ->
        loadNewRoute()

      loadNewRoute()
    ]
