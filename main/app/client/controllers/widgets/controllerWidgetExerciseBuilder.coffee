define [
  'angular'
  'angular-ui'
  'underscore'
  #'bootstrap-tree'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilder.html'
], (
  angular
  angularUi
  _
  #bootstrapTree
  viewWidgetExerciseBuilder
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetExerciseBuilder', viewWidgetExerciseBuilder


    Module.controller 'ControllerWidgetExerciseBuilder', ($scope, $routeParams, $templateCache, socket) ->

      $scope.viewRoot = 'templates'

      $scope.templates                    = []
      $scope.currentRevision              = {}
      $scope.currentTemplate              = {}
      $scope.currentTemplateFirstRevision = {}

      fetchCurrentTemplate = () ->
        $scope.currentTemplate = _.find $scope.templates, (item) ->
          if item.uid == $routeParams.templateId
            return true
          return false

        if $scope.currentTemplate and $scope.currentTemplate.revisions
          $scope.currentTemplateFirstRevision = _.first $scope.currentTemplate.revisions

      fetchTemplates = () ->
        socket.apiRequest 'GET', '/templates?type=superAdmin', {expand: [{resource: 'revisions', expand:[{resource: 'employee'}]}]}, {}, (response) ->
          $scope.templates = response.response
        fetchCurrentTemplate()

      fetchCurrentRevision = () ->
        socket.apiRequest 'GET', '/revisions/' + $scope.revisionId + '/?type=superAdmin', {expand: [{resource: 'groups', expand:[{resource: 'fields'}]}]}, {}, (response) ->
          $scope.currentRevision = response.response
          console.log $scope.currentRevision

      fetchTemplates()
      fetchCurrentRevision()
      $scope.$on '$routeChangeSuccess', () ->
        $scope = _.extend $scope, $routeParams
        fetchTemplates()
        fetchCurrentRevision()
