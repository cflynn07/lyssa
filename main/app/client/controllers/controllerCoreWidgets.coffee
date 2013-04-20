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

      $scope.$on '$routeChangeSuccess', (event, current, previous) ->
        console.log current
        console.log current.redirectTo
        #if current && (current.redirectTo is not undefined)
        #  console.log '$routeChangeSuccess'
        updateShit()


      updateShit = () ->
        $scope.widgetRows = [{
          widget: 'viewWidgetBreadCrumbs'
        },{
          widget: 'viewWidgetExerciseBuilder'
        }]
