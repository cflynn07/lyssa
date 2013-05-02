define [
  'angular'
  'angular-ui'
  'underscore'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilder.html'
  'text!views/widgetExerciseBuilder/fields/viewWidgetExerciseBuilderFieldOpenResponse.html'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilderDetailsEJS.html'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilderTemplateListButtonsEJS.html'
  'ejs'
  'async'
], (
  angular
  angularUi
  _
  viewWidgetExerciseBuilder
  viewWidgetExerciseBuilderFieldOpenResponse

  viewWidgetExerciseBuilderDetailsEJS
  viewWidgetExerciseBuilderTemplateListButtonsEJS

  EJS
  async
) ->
  (Module) ->

    Module.run ($templateCache) ->
      #main Template
      $templateCache.put 'viewWidgetExerciseBuilder', viewWidgetExerciseBuilder
      #Field Templates
      $templateCache.put 'viewWidgetExerciseBuilderFieldOpenResponse', viewWidgetExerciseBuilderFieldOpenResponse


    Module.controller 'ControllerWidgetExerciseBuilder', ($scope, $route, $routeParams, $templateCache, socket, apiRequest, $dialog) ->


      console.log $scope.clientOrmShare


      $scope.viewModel =

        showAddNewTemplate: false

        routeParams: {}
        templates:   {}

        newTemplateForm: {}

        clearNewTemplateForm: () ->
          $scope.viewModel.showAddNewTemplate = false
          $scope.newTemplateForm.$setPristine()
          $scope.viewModel.newTemplateForm = {}
        postNewTemplate: () ->
          apiRequest.post 'template', {
            name: $scope.viewModel.newTemplateForm.name
            type: $scope.viewModel.newTemplateForm.type
          }, (result) ->
            $scope.viewModel.clearNewTemplateForm()
            console.log result


        fetchTemplates: () ->
          #API request loads templats -> revisions -> groups -> fields thanks to api uid hash reconciliation
          async.parallel [
            (callback) ->
              apiRequest.get 'template', [], {expand:[{resource: 'revisions'}]}, (response) ->
                callback(null, response)
            (callback) ->
              apiRequest.get 'revision', [], {expand:[{resource: 'groups', expand:[{resource: 'fields'}]}]}, (response) ->
                callback(null, response)
            (callback) ->
              apiRequest.get 'employee', [], {expand: [{resource: 'revisions'}]}, (response) ->
                callback(null, response)
          ], (err, results) ->
            if results[0] and results[0].response
              $scope.viewModel.templates = results[0].response
              hashChangeUpdate()

        templatesListDataTable:
          detailRow: (obj) ->
            uid = $scope.escapeHtml obj.uid
            return new EJS(text: viewWidgetExerciseBuilderDetailsEJS).render({templateUid: uid})
          columnDefs: [
            mDataProp:  'name'
            aTargets:   [0]
            mRender: (data, type, full) ->
              resHtml  = '<a href="#' + $scope.viewRoot + '/' + $scope.escapeHtml(full.uid) + '">'
              resHtml += $scope.escapeHtml(data)
              resHtml += '</a>'
              #resHtml += '<span>{{resourcePool[\'' + $scope.escapeHtml(full.uid) + '\'].revisions}} Revisions</span>'
              return resHtml
          ,
            mData:      null
            aTargets:   [1]
            mRender: (data, type, full) ->
              uid = $scope.escapeHtml full.uid
              html = new EJS({text: viewWidgetExerciseBuilderTemplateListButtonsEJS}).render({templateUid: uid})
          ]
          options:
            bStateSave:      true
            iCookieDuration: 2419200
            bJQueryUI:       true
            bPaginate:       true
            bLengthChange:   true
            bFilter:         false
            bInfo:           true
            bDestroy:        true

        deleteConfirmDialogTemplate: (templateUid) ->
          #Delete a template
          apiRequest.get 'template', [templateUid], {}, (response) ->

            title = 'Delete Dialog'
            msg   = 'Dire Consequences...'
            btns  = [
              result:   false
              label:    'Cancel'
              cssClass: 'red'
            ,
              result:   true
              label:    'Confirm'
              cssClass: 'green'
            ]

            $dialog.messageBox(title, msg, btns).open()
              .then (result) ->
                if result
                  apiRequest.delete 'template', templateUid, (result) ->
                    return
                    #console.log result


        currentTemplateRevision: false
        fetchCurrentTemplateRevision: () ->
          if !$scope.viewModel.routeParams.templateUid
            $scope.viewModel.currentTemplateRevision = false
            return
          template = $scope.viewModel.templates[$scope.viewModel.routeParams.templateUid]
          $scope.viewModel.currentTemplateRevision = $scope.getLastObjectFromHash template.revisions


        currentTemplate: false
        fetchCurrentTemplate: () ->
          if !$scope.viewModel.routeParams.templateUid
            $scope.viewModel.currentTemplate = false
            return
          $scope.viewModel.currentTemplate = $scope.viewModel.templates[$scope.viewModel.routeParams.templateUid]
          console.log $scope.viewModel.currentTemplate




      hashChangeUpdate = () ->
        $scope.viewModel.routeParams = $routeParams
        $scope.viewModel.fetchCurrentTemplateRevision()
        $scope.viewModel.fetchCurrentTemplate()

      $scope.viewModel.fetchTemplates()

      $scope.$on '$routeChangeSuccess', () ->
        hashChangeUpdate()



