define [
  'angular'
  'underscore'
  'text!views/viewCoreWidgets.html'
  'cs!config/clientConfig'
], (
  angular
  _
  viewCoreWidgets
  clientConfig
) ->

  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewCoreWidgets', viewCoreWidgets

    ###
      Manages the dynamic insertion of widgets to the main content area of the application
    ###
    Module.controller 'ControllerCoreWidgets', ($scope, $route) ->

      $scope.widgetRows = [{widget: 'viewWidgetBreadCrumbs'}]

      previousRouteTitle  = ''
      isDerivativeRoute   = (newRouteTitle) ->
        result = true
        if newRouteTitle != previousRouteTitle
          result = false
          previousRouteTitle = newRouteTitle
        return result

      stripAllButBC = () ->
        $scope.widgetRows = $scope.widgetRows.splice 0, 1

      trigger4oh4 = () ->
        stripAllButBC()
        previousRouteTitle = ''
        $scope.widgetRows.push
          widget: 'viewWidget4oh4'

      loadNewRoute = () ->

        #Determine if this is a valid application route
        if _.isUndefined($route.current) || _.isUndefined($route.current.path) || _.isUndefined($route.current.pathValue)
          trigger4oh4()
          return

        #Determine if this is a valid route for the given user-type
        if !clientConfig.routeMatchClientType($route.current.path, $scope.rootUser.type)
          trigger4oh4()
          return

        if !isDerivativeRoute($route.current.pathValue.title)
          stripAllButBC()
          for value in $route.current.pathValue.widgets
            $scope.widgetRows.push widget: value

      $scope.$on '$routeChangeSuccess', (event, current, previous) ->
        loadNewRoute()

      loadNewRoute()






      ###
      updateShit = () ->
        $scope.widgetRows = [
          widget: 'viewWidgetBreadCrumbs'
        ,
          widget: 'viewWidgetFullExerciseSubmitter'
        ,
          widget: 'viewWidgetScheduler'
        ,
          widget: 'viewWidgetDictionaryManager'
        ,
          widget: 'viewWidgetExerciseBuilder'
        ]
      updateShit()
      ###
