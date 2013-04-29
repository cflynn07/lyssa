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



      $scope.viewModel =
        fetchTemplates: () ->
          #API request loads templats -> revisions -> groups -> fields thanks to api uid hash reconciliation
          apiRequest.get 'template', [], {expand:[{resource: 'revisions'}]}, (responseA) ->
            if responseA.code == 200
              revisionUids = []
              for propName, propValue of responseA.response
                for propName2, propValue2 of propValue.revisions
                  revisionUids.push propValue2.uid
              apiRequest.get 'revision', revisionUids, {expand:[{resource: 'groups', expand:[{resource: 'fields'}]}]}, (responseB) ->
                $scope.viewModel.templates = responseA.response

        templates:         {}
        activeTemplateUid: ''

        dataTable:
          detailRow: (obj) ->

            return '<div class="portlet box grey" style="margin-bottom:0;">
                      <div class="portlet-title">
                        <h4><span>' + obj.name + ' Revisions</span></h4>
                      </div>
                      <div class="portlet-body light-grey">
                      </div>
                    </div>'


          columnDefs: [
            mDataProp:  'name'
            aTargets:   [0]
            mRender: (data, type, full) ->
              resHtml  = '<a href="#' + $scope.viewRoot + '/' + full.uid + '">'
              resHtml += data
              resHtml += '</a>'
              return resHtml
          ,
            mData:      null
            aTargets:   [1]
            mRender: (data, type, full) ->
              return $scope.getKeysLength(full.revisions)
          ,
            mData:      null
            aTargets:   [2]
            mRender: (data, type, full) ->
              html  = '<div class="inline-content" style="text-align:center;">'
              html += '<a data-ng-href data-ng-click="$parent.viewModel.deleteConfirmDialogDictionary(\'' + full.uid + '\')" class="btn red">Delete</a>'
              html += ' '
              html += '<a class="btn blue detail">Revisions</a></div>'
          ]
          options:
            bStateSave:      true
            iCookieDuration: 2419200
            bJQueryUI:       true
            bPaginate:       false
            bLengthChange:   false
            bFilter:         false
            bInfo:           false
            bDestroy:        true


      $scope.viewModel.fetchTemplates()

      return


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
