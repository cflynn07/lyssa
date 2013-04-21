define [
  'angular'
  'text!views/viewCoreWidgets.html'
], (
  angular
  viewCoreWidgets
) ->

  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewCoreWidgets', viewCoreWidgets

    Module.controller 'ControllerCoreWidgets', ($scope, $route) ->

      once = false
      $scope.$on '$routeChangeSuccess', (event, current, previous) ->

        #if current && (current.redirectTo is not undefined)
        #  console.log '$routeChangeSuccess'
        if !once
          once = true
          updateShit()


      updateShit = () ->
        $scope.widgetRows = [{
          widget: 'viewWidgetBreadCrumbs'
        },{
          widget: 'viewWidgetExerciseBuilder'
        }]
      updateShit()
