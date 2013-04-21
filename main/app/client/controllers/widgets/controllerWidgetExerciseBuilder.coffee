define [
  'angular'
  'underscore'
  #'bootstrap-tree'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilder.html'
], (
  angular
  _
  #bootstrapTree
  viewWidgetExerciseBuilder
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetExerciseBuilder', viewWidgetExerciseBuilder



    Module.controller 'ControllerWidgetExerciseBuilder', ($scope, $routeParams, $templateCache, socket) ->

      $scope.loaded = false
      $scope.collapsed = false
      $scope.reload = () ->
      $scope.toggle = () ->
        $scope.collapsed = !$scope.collapsed

      $scope.viewRoot = 'templates'



      console.log $routeParams
      $scope = _.extend $scope, $routeParams


      $scope.activeRevision = false
      $scope.activeTemplate = false
      $scope.setActive = (template, revision) ->
        $scope.activeRevision = revision
        $scope.activeTemplate = template

      $scope.getStyle = (uid) ->
        if uid == $scope.activeRevision
          return 'font-weight:bold;'
        return ''




      $scope.templates = []
      socket.apiRequest 'GET', '/templates?type=superAdmin', {expand: [{resource: 'revisions', expand:[{resource: 'employee'}]}]}, {}, (response) ->
        console.log response.response
        $scope.templates = response.response
        #$scope.loaded = true



