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

    Module.run ($templateCache, apiRequest) ->
      $templateCache.put 'viewCoreWidgets', viewCoreWidgets

    ###
      Manages the dynamic insertion of widgets to the main content area of the application
    ###
    Module.controller 'ControllerCoreWidgets', ($scope, $route, $rootScope) ->

      #Global Helper
      $rootScope.getKeysLength = (obj) ->
        length = 0
        for key, value of obj
          if !_.isUndefined(value['uid']) and _.isNull(value['deletedAt'])
            length++
        return length



      $scope.widgetRows   = [{widget: 'viewWidgetBreadCrumbs'}]
      previousRouteTitle  = ''

      isDerivativeRoute   = (newRouteTitle) ->
        result = true
        if newRouteTitle != previousRouteTitle
          result = false
          previousRouteTitle = newRouteTitle
        return result

      stripAllButBC = () ->
        $scope.widgetRows.splice 0, 1

      trigger4oh4 = () ->
        widgets = stripAllButBC()
        widgets.push widget:'viewWidget4oh4'
        $scope.widgetRows = widgets
        previousRouteTitle = ''

      loadNewRoute = () ->

        #Determine if this is a valid application route
        if _.isUndefined($route.current) || _.isUndefined($route.current.path) || _.isUndefined($route.current.pathValue)
          if previousRouteTitle == ''
            window.location.hash = '/' + clientConfig.simplifiedUserCategories[$scope.rootUser.type] + '/themis'
            return
          else
            trigger4oh4()
            return

        #Determine if this is a valid route for the given user-type
        if !clientConfig.routeMatchClientType($route.current.path, $scope.rootUser.type)
          trigger4oh4()
          return

        if !isDerivativeRoute($route.current.pathValue.title)
          $('body').scrollTop 0
          widgets = stripAllButBC()
          addWidgets = []
          for value in $route.current.pathValue.widgets
            addWidgets.push widget: value
          $scope.widgetRows = widgets.concat addWidgets

          #Used by widgets for forming links
          $rootScope.viewRoot = $route.current.pathValue.root

      $scope.$on '$routeChangeSuccess', (event, current, previous) ->
        loadNewRoute()

      loadNewRoute()
