define [
  'jquery'
  'angular'
  'angular-ui'
  'underscore'
  'underscore_string'
  'cs!utils/utilBuildDTQuery'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilder.html'
  'text!views/widgetExerciseBuilder/fields/viewWidgetExerciseBuilderFieldOpenResponse.html'
  'text!views/widgetExerciseBuilder/fields/viewWidgetExerciseBuilderFieldButtons.html'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilderDetailsEJS.html'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilderTemplateListButtonsEJS.html'
  'ejs'
  'async'
], (
  $
  angular
  angularUi
  _
  _string
  utilBuildDTQuery

  viewWidgetExerciseBuilder
  viewWidgetExerciseBuilderFieldOpenResponse
  viewWidgetExerciseBuilderFieldButtons

  viewWidgetExerciseBuilderDetailsEJS
  viewWidgetExerciseBuilderTemplateListButtonsEJS

  EJS
  async
) ->
  (Module) ->

    Module.run ['$templateCache',
      ($templateCache) ->
        #main Template
        $templateCache.put 'viewWidgetExerciseBuilder',
          viewWidgetExerciseBuilder

        #Field Templates
        $templateCache.put 'viewWidgetExerciseBuilderFieldOpenResponse',
          viewWidgetExerciseBuilderFieldOpenResponse
        $templateCache.put 'viewWidgetExerciseBuilderFieldButtons',
          viewWidgetExerciseBuilderFieldButtons
    ]


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




    Module.controller 'ControllerWidgetExerciseBuilderGroupFieldOpenResponse', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->

        $scope.form = {}

        $scope.cancelAddNewField = () ->
          $scope.form = {}
          $scope.formOpenResponseAdd.$setPristine()
          $scope.$parent.viewModel.cancelAddNewField()

        $scope.submitField = () ->
          apiRequest.post 'field', {
            name:     $scope.form.name
            type:     'openResponse'
            groupUid: $scope.group.uid
            ordinal:  0
          }, (response) ->
            console.log response

          $scope.cancelAddNewField()


        $scope.isFormInvalid = () ->
          return $scope.formOpenResponseAdd.$invalid


    ]



    Module.controller 'ControllerWidgetExerciseBuilderGroupEdit', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->

        fieldTypes = [
          'OpenResponse'
          'SelectIndividual'
          'SelectMultiple'
          'YesNo'
          'PercentageSlider'
        ]

        $scope.viewModel =
          showAddNewField_OpenType: ''

          cancelAddNewField: () ->
            for type in fieldTypes
              $scope.viewModel.showAddNewField_OpenType = ''

          moveGroup: (dir) ->
            newOrdinal   = $scope.group.ordinal
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
                apiRequest.put 'group', [$scope.group.uid], {
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
                    #console.log result

                    helperReorderGroupOrdinals $scope,
                      apiRequest,
                      $scope.$parent.viewModel.currentTemplateRevision.groups,
                      _.toArray($scope.$parent.viewModel.currentTemplateRevision.groups).length,
                      false,
                      () ->
                        console.log 'groups reindexed'

          putGroup: (groupUid) ->
            console.log 'groupUid'
            console.log groupUid

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
    ]




    Module.controller 'ControllerWidgetExerciseBuilder', ['$scope', '$route', '$routeParams', '$templateCache', 'socket', 'apiRequest', '$dialog',
      ($scope, $route, $routeParams, $templateCache, socket, apiRequest, $dialog) ->

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
              mData:     null
              aTargets:  [0]
              bSortable: true
              mRender: (data, type, full) ->
                resHtml  = '<a href="#' + $scope.viewRoot + '/' + $scope.escapeHtml(full.uid) + '">'
                if full.name
                  resHtml += '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].name">' + $scope.escapeHtml(full.name) + '</span>'
                resHtml += '</a>'
                return resHtml
            ,
              mData:     null
              aTargets:  [1]
              bSortable: true
              mRender: (data, type, full) ->
                resHtml = _.str.capitalize(full.type)
            ,
              mData:     null
              aTargets:  [2]
              bSortable: false
              mRender: (data, type, full) ->
                uid = $scope.escapeHtml full.uid
                html = new EJS({text: viewWidgetExerciseBuilderTemplateListButtonsEJS}).render({templateUid: uid})
            ]
            options:
              bStateSave:      true
              iCookieDuration: 2419200
              bJQueryUI:       false
              bPaginate:       true
              bLengthChange:   true
              bFilter:         false
              bInfo:           true
              bDestroy:        true
              bServerSide:     true
              bProcessing:     true
              fnServerData: (sSource, aoData, fnCallback, oSettings) ->
                query = utilBuildDTQuery ['name', 'type'],
                  ['name', 'type'],
                  oSettings

                query.filter.push ['deletedAt', '=', 'null']
                query.expand = [{
                  resource: 'revisions'
                }]

                cacheResponse   = ''
                oSettings.jqXHR = apiRequest.get 'template', [], query, (response) ->
                  if response.code == 200

                    responseDataString = JSON.stringify(response.response)
                    if cacheResponse == responseDataString
                      return
                    cacheResponse = responseDataString

                    dataArr = _.toArray response.response.data

                    fnCallback
                      iTotalRecords:        response.response.length
                      iTotalDisplayRecords: response.response.length
                      aaData:               dataArr



          deleteConfirmDialogTemplate: (templateUid) ->
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
            $groupsObj = $scope.viewModel.currentTemplateRevision.groups

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
            apiRequest.put 'template', [templateUid], {
              name: $scope.viewModel.formEditTemplateName.name
            }, (response) ->
              console.log response
              $scope.viewModel.showEditTemplateName      = false
              $scope.viewModel.formEditTemplateName.name = $scope.viewModel.currentTemplate.name

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
                $scope.viewModel.templates = results[0].response.data
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
            #console.log $scope.viewModel.currentTemplateRevision


          currentTemplate: false
          fetchCurrentTemplate: () ->
            if !$scope.viewModel.routeParams.templateUid
              $scope.viewModel.currentTemplate = false
              return

            if !$scope.viewModel.templates
              return

            $scope.viewModel.currentTemplate = $scope.viewModel.templates[$scope.viewModel.routeParams.templateUid]
            #console.log $scope.viewModel.currentTemplate





        $scope.fieldsSortableOptions =
          connectWith: 'div[data-ui-sortable]'
          update: () ->

            $('div[data-group-uid]').each () ->

              groupUid          = $(this).attr('data-group-uid')
              groupFieldOrdinal = 0

              $(this).find('div[data-field-uid]').each () ->

                fieldUid = $(this).attr('data-field-uid')
                field    = $scope.resourcePool[fieldUid]

                if (field.ordinal == groupFieldOrdinal) and (field.groupUid == groupUid)
                  #Nothing has changed here
                  groupFieldOrdinal++
                  return

                if field.groupUid != groupUid
                  $scope.resourcePool[groupUid].fields[field.uid] = field
                  delete $scope.resourcePool[field.groupUid].fields[field.uid]
                  field.groupUid = groupUid

                apiRequest.put 'field', fieldUid, {
                  ordinal:  groupFieldOrdinal
                  groupUid: groupUid
                }, (result) ->
                  console.log result

                #delete $scope.resourcePool[fieldUid]

                groupFieldOrdinal++


        #Hack to update children, with rate limiting for performance
        rateLimit = null
        $scope.$on 'resourcePut', (data, uid) ->

          found = false
          for templateUid, template of $scope.viewModel.templates
            if found
              break
            for revisionUid, revision of template.revisions
              if found
                break
              for groupUid, group of revision.groups
                if found
                  break
                for fieldUid, field of group.fields
                  if fieldUid == uid
                    found = true
                    break

          if found
            clearTimeout rateLimit
            rateLimit = setTimeout () ->
              apiRequest.get 'group', [], {expand: [{resource: 'fields'}]}, (response) ->
                console.log 'GET groups.fields'
                console.log response
            , 100



        hashChangeUpdate = () ->
          $scope.viewModel.showEditTemplateName = false
          $scope.viewModel.routeParams          = $routeParams
          $scope.viewModel.fetchCurrentTemplateRevision()
          $scope.viewModel.fetchCurrentTemplate()

        $scope.$on '$routeChangeSuccess', () ->
          hashChangeUpdate()

        #$scope.viewModel.fetchTemplates()
    ]



