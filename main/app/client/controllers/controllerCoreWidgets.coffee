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
        console.log '$routeChangeSuccess'
        console.log arguments
        updateShit()


      updateShit = () ->
        $scope.widgetRows = [{
          widget: 'viewWidgetBreadCrumbs'
        },{
          widget: 'viewWidgetExerciseBuilder'
        }]
