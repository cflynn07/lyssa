define [
  'angular'
  'text!views/widgetFullExerciseSubmitter/viewWidgetFullExerciseSubmitter.html'
], (
  angular
  viewWidgetFullExerciseSubmitter
) ->

  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetFullExerciseSubmitter', viewWidgetFullExerciseSubmitter

    Module.controller 'ControllerWidgetFullExerciseSubmitter', ($scope, $route) ->

      $scope.test = 'foo'
