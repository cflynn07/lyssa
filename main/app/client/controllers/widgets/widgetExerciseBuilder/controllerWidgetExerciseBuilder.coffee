define [
  'angular'
  'angular-ui'
  'underscore'
  #'bootstrap-tree'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilder.html'
  'text!views/widgetExerciseBuilder/fields/viewWidgetExerciseBuilderFieldOpenResponse.html'
], (
  angular
  angularUi
  _
  #bootstrapTree
  viewWidgetExerciseBuilder
  viewWidgetExerciseBuilderFieldOpenResponse
) ->
  (Module) ->

    Module.run ($templateCache) ->
      #main Template
      $templateCache.put 'viewWidgetExerciseBuilder', viewWidgetExerciseBuilder

      #Field Templates
      $templateCache.put 'viewWidgetExerciseBuilderFieldOpenResponse', viewWidgetExerciseBuilderFieldOpenResponse

      #$templateCache.put 'viewWidgetExerciseBuilder', viewWidgetExerciseBuilder
      #$templateCache.put 'viewWidgetExerciseBuilder', viewWidgetExerciseBuilder


    Module.controller 'ControllerWidgetExerciseBuilder', ($scope, $route, $routeParams, $templateCache, socket, apiRequest) ->


      $scope.test = () ->
        alert 'test!'

      #$scope.viewRoot = $route.current.path #'templates'

      $scope.templates                    = []
      $scope.currentRevision              = {}
      $scope.currentTemplate              = {}
      $scope.currentTemplateFirstRevision = {}




    #  apiRequest.get 'dictionary', [], {expand: [{'resource':'dictionaryItems'}]}, (response) ->
    #    window.responsePlay            = response
    #    #$scope.viewModel.dictionaries = response.response





      fetchCurrentTemplate = () ->
        $scope.currentTemplate = _.find $scope.templates, (item) ->
          if item.uid == $routeParams.templateId
            return true
          return false

        if $scope.currentTemplate and $scope.currentTemplate.revisions
          $scope.currentTemplateFirstRevision = _.first $scope.currentTemplate.revisions

      fetchTemplates = () ->
        apiRequest.get 'template', [], {expand: [{resource: 'revisions', expand:[{resource: 'employee'}]}]}, (response) ->
          console.log response
          $scope.templates = response.response

        #socket.apiRequest 'GET', '/templates', {expand: [{resource: 'revisions', expand:[{resource: 'employee'}]}]}, {}, (response) ->
        #  $scope.templates = response.response
        #fetchCurrentTemplate()

      fetchCurrentRevision = () ->
        socket.apiRequest 'GET', '/revisions/' + $scope.revisionId, {expand: [{resource: 'groups', expand:[{resource: 'fields'}]}]}, {}, (response) ->
          $scope.currentRevision = response.response




      fetchTemplates()
      fetchCurrentRevision()
      $scope.$on '$routeChangeSuccess', () ->
        $scope = _.extend $scope, $routeParams
        fetchTemplates()
        fetchCurrentRevision()
