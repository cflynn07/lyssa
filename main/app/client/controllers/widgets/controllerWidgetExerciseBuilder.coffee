define [
  'angular'
  #'bootstrap-tree'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilder.html'
], (
  angular
  #bootstrapTree
  viewWidgetExerciseBuilder
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetExerciseBuilder', viewWidgetExerciseBuilder

    Module.controller 'ControllerWidgetExerciseBuilder', ($scope, $templateCache, socket) ->

      $scope.loaded = false
      $scope.collapsed = false
      $scope.reload = () ->
      $scope.toggle = () ->
        $scope.collapsed = !$scope.collapsed

      $scope.exercises = []
      socket.apiRequest 'GET', '/templates?type=superAdmin', {expand: [{resource: 'revisions'}]}, {}, (response) ->
        console.log 'AND THE RESPONSE IS!'
        console.log response.response
        $scope.exercises = response.response
        #$scope.loaded = true



