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

      console.log 'hi i controller'

      $scope.$on '$routeChangeSuccess', (event, current, previous) ->

        #if current && (current.redirectTo is not undefined)
        #  console.log '$routeChangeSuccess'
        console.log 'p23'
        updateShit()


      updateShit = () ->
        $scope.widgetRows = [{
          widget: 'viewWidgetBreadCrumbs'
        },{
          widget: 'viewWidgetExerciseBuilder'
        },{
          widget: 'viewWidgetExerciseBuilder'
        },{
          widget: 'viewWidgetExerciseBuilder'
        },{
          widget: 'viewWidgetExerciseBuilder'
        }]
      updateShit()
