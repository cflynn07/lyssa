define [
  'angular'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilder.html'
], (
  angular
  viewWidgetExerciseBuilder
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetExerciseBuilder', viewWidgetExerciseBuilder

    Module.controller 'ControllerWidgetExerciseBuilder', ($scope, $templateCache) ->

      $scope.title    = 'Test Title'
      $scope.subtitle = 'Test Subtitle'
