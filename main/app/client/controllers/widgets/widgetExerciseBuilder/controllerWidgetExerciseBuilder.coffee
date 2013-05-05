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



    helperReorderGroupOrdinals = ($scope, apiRequest, groupsHash, insertOrdinalNum, insertUid = false, topCallback) ->
      groupsArray = $scope.getArrayFromHash groupsHash

      groupsArray = _.sortBy groupsArray, (item) ->
        return item.ordinal

      groupsArray = _.filter groupsArray, (item) ->
        !item.deletedAt

      #Now sorted by ordinal
      i = 0
      groupsArray = _.map groupsArray, (item) ->

        if insertUid
          if item.uid == insertUid
            return item #This one is about to be tweaked

        if i >= insertOrdinalNum
          item.ordinal = i + 1
        else
          item.ordinal = i
        i++
        return item

      async.map groupsArray, (item, callback) ->

        apiRequest.put 'group', item.uid, {
          ordinal: item.ordinal
        }, (result) ->
          callback()

      , (err, results) ->

        topCallback()



    Module.controller 'ControllerWidgetExerciseBuilderGroupEdit', ($scope, apiRequest, $dialog) ->

      $scope.viewModel =
        moveGroup: (dir) ->
          newOrdinal  = $scope.group.ordinal
          groupsLength = _.filter(_.toArray($scope.$parent.viewModel.currentTemplateRevision.groups), (item) -> !item.deletedAt).length

          if dir == 'down'
            newOrdinal++
          else
            newOrdinal--

          if newOrdinal < 0
            return
          if (newOrdinal + 1) > groupsLength
            return

          _$scope = $scope
          helperReorderGroupOrdinals $scope,
            apiRequest,
            $scope.$parent.viewModel.currentTemplateRevision.groups,
            newOrdinal,
            $scope.group.uid,
            () ->
              apiRequest.put 'group', [_$scope.group.uid], {
                ordinal: newOrdinal
              }, (response) ->
                console.log response


        deleteGroup: (groupUid) ->

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
                apiRequest.delete 'group', [groupUid], (result) ->
                  console.log result

                  helperReorderGroupOrdinals $scope,
                    apiRequest,
                    $scope.$parent.viewModel.currentTemplateRevision.groups,
                    _.toArray($scope.$parent.viewModel.currentTemplateRevision.groups).length,
                    false,
                    () ->
                      console.log 'groups reindexed'




        putGroup: (groupUid) ->

          name = $scope.resourcePool[groupUid].name

          if (name.length < $scope.clientOrmShare.group.model.name.validate.len[0]) || (name.length > $scope.clientOrmShare.group.model.name.validate.len[1])

            title = 'Invalid name'
            msg   = 'Group name length must be between ' + $scope.clientOrmShare.group.model.name.validate.len[0] + ' and ' + $scope.clientOrmShare.group.model.name.validate.len[1] + ' characters'
            btns  = [
              result:   'cancel'
              label:    'Cancel'
              cssClass: 'red'
            ,
              result:   'ok'
              label:    'OK'
              cssClass: 'green'
            ]

            $dialog.messageBox(title, msg, btns)
              .open()
              .then (result) ->
                if result == 'cancel'
                  apiRequest.get 'group', [groupUid], {}, () ->
                  $scope.nameEditing = false

            return true

          else

            apiRequest.put 'group', groupUid, {
              name: $scope.resourcePool[groupUid].name
            }, (response) ->
              console.log response
            return false





    Module.controller 'ControllerWidgetExerciseBuilder', ($scope, $route, $routeParams, $templateCache, socket, apiRequest, $dialog) ->

      $scope.viewModel =

        showAddNewTemplate:      false
        showAddNewTemplateGroup: false

        routeParams: {}
        templates:   {}

        newTemplateForm:      {}
        newTemplateGroupForm: {}
        editTemplateNameForm: {}

        templatesListDataTable:
          detailRow: (obj) ->
            uid = $scope.escapeHtml obj.uid
            return new EJS(text: viewWidgetExerciseBuilderDetailsEJS).render({templateUid: uid})
          columnDefs: [
            mData:  null
            aTargets:   [0]
            mRender: (data, type, full) ->
              resHtml  = '<a href="#' + $scope.viewRoot + '/' + $scope.escapeHtml(full.uid) + '">'

              if full.name
                resHtml += $scope.escapeHtml(full.name)

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

        clearnewTemplateGroupForm: () ->
          $scope.viewModel.showAddNewTemplateGroup = false
          $scope.newTemplateGroupForm.$setPristine()
          $scope.viewModel.newTemplateGroupForm = {}

        clearNewTemplateForm: () ->
          $scope.viewModel.showAddNewTemplate = false
          $scope.newTemplateForm.$setPristine()
          $scope.viewModel.newTemplateForm = {}

        postNewTemplateGroup: () ->
          $groupsObj   = $scope.viewModel.currentTemplateRevision.groups

          helperReorderGroupOrdinals $scope,
            apiRequest,
            $groupsObj,
            0,
            false,
            () ->
              apiRequest.post 'group', {
                name:        $scope.viewModel.newTemplateGroupForm.name
                description: $scope.viewModel.newTemplateGroupForm.description
                ordinal:     0
                revisionUid: $scope.viewModel.currentTemplateRevision.uid
              }, (result) ->

                $scope.viewModel.clearnewTemplateGroupForm()
                console.log result

        putTemplate: (templateUid) ->
          console.log templateUid


        postNewTemplate: () ->
          apiRequest.post 'template', {
            name:        $scope.viewModel.newTemplateForm.name
            type:        $scope.viewModel.newTemplateForm.type
          }, (result) ->

            #Create first revision
            apiRequest.post 'revision', {
              changeSummary: ''
              scope:         ''
              templateUid:   result.uids[0]
            }, (result) ->
              console.log result
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


        currentTemplateRevision: false
        fetchCurrentTemplateRevision: () ->
          if !$scope.viewModel.routeParams.templateUid
            $scope.viewModel.currentTemplateRevision = false
            return

          if !$scope.viewModel.templates
            return

          template = $scope.viewModel.templates[$scope.viewModel.routeParams.templateUid]
          $scope.viewModel.currentTemplateRevision = $scope.getLastObjectFromHash template.revisions
          console.log $scope.viewModel.currentTemplateRevision

        currentTemplate: false
        fetchCurrentTemplate: () ->
          if !$scope.viewModel.routeParams.templateUid
            $scope.viewModel.currentTemplate = false
            return

          if !$scope.viewModel.templates
            return

          $scope.viewModel.currentTemplate = $scope.viewModel.templates[$scope.viewModel.routeParams.templateUid]
          #console.log $scope.viewModel.currentTemplate



      hashChangeUpdate = () ->
        $scope.viewModel.showEditTemplateName = false
        $scope.viewModel.routeParams = $routeParams
        $scope.viewModel.fetchCurrentTemplateRevision()
        $scope.viewModel.fetchCurrentTemplate()

      $scope.$on '$routeChangeSuccess', () ->
        hashChangeUpdate()

      $scope.viewModel.fetchTemplates()






