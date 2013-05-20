define [
  'jquery'
  'angular'
  'angular-ui'
  'underscore'
  'underscore_string'
  'cs!utils/utilBuildDTQuery'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilder.html'


  'text!views/widgetExerciseBuilder/fields/viewPartialExerciseBuilderFieldOpenResponse.html'
  'text!views/widgetExerciseBuilder/fields/viewPartialExerciseBuilderFieldSelectIndividual.html'
  'text!views/widgetExerciseBuilder/fields/viewPartialExerciseBuilderFieldSlider.html'
  'text!views/widgetExerciseBuilder/fields/viewWidgetExerciseBuilderFieldButtons.html'

  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilderDetailsEJS.html'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilderTemplateListButtonsEJS.html'
  'text!views/widgetExerciseBuilder/viewPartialExerciseBuilderNewTemplateForm.html'
  'text!views/widgetExerciseBuilder/viewPartialExerciseBuilderNewGroupForm.html'
  'text!views/widgetExerciseBuilder/viewPartialExerciseBuilderGroupMenu.html'
  'text!views/widgetExerciseBuilder/formPartials/viewPartialExerciseBuilderGroupFieldOpenResponse.html'
  'text!views/widgetExerciseBuilder/formPartials/viewPartialExerciseBuilderGroupFieldSelectIndividual.html'
  'text!views/widgetExerciseBuilder/formPartials/viewPartialExerciseBuilderGroupFieldPercentageSlider.html'
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

  viewPartialExerciseBuilderFieldOpenResponse
  viewPartialExerciseBuilderFieldSelectIndividual
  viewPartialExerciseBuilderFieldSlider
  viewWidgetExerciseBuilderFieldButtons

  viewWidgetExerciseBuilderDetailsEJS
  viewWidgetExerciseBuilderTemplateListButtonsEJS
  viewPartialExerciseBuilderNewTemplateForm
  viewPartialExerciseBuilderNewGroupForm
  viewPartialExerciseBuilderGroupMenu
  viewPartialExerciseBuilderGroupFieldOpenResponse
  viewPartialExerciseBuilderGroupFieldSelectIndividual
  viewPartialExerciseBuilderGroupFieldPercentageSlider

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
        $templateCache.put 'viewPartialExerciseBuilderFieldOpenResponse',
          viewPartialExerciseBuilderFieldOpenResponse
        $templateCache.put 'viewPartialExerciseBuilderFieldSelectIndividual',
          viewPartialExerciseBuilderFieldSelectIndividual
        $templateCache.put 'viewPartialExerciseBuilderFieldSlider',
          viewPartialExerciseBuilderFieldSlider
        $templateCache.put 'viewWidgetExerciseBuilderFieldButtons',
          viewWidgetExerciseBuilderFieldButtons

        #Partials
        $templateCache.put 'viewPartialExerciseBuilderNewTemplateForm',
          viewPartialExerciseBuilderNewTemplateForm
        $templateCache.put 'viewPartialExerciseBuilderNewGroupForm',
          viewPartialExerciseBuilderNewGroupForm
        $templateCache.put 'viewPartialExerciseBuilderGroupMenu',
          viewPartialExerciseBuilderGroupMenu

        #Partials -- field adds
        $templateCache.put 'viewPartialExerciseBuilderGroupFieldOpenResponse',
          viewPartialExerciseBuilderGroupFieldOpenResponse
        $templateCache.put 'viewPartialExerciseBuilderGroupFieldSelectIndividual',
          viewPartialExerciseBuilderGroupFieldSelectIndividual
        $templateCache.put 'viewPartialExerciseBuilderGroupFieldPercentageSlider',
          viewPartialExerciseBuilderGroupFieldPercentageSlider
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


    ###
    #
    #  BEGIN Field add form controllers
    #
    ###

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
          if !$scope.formOpenResponseAdd
            return
          return $scope.formOpenResponseAdd.$invalid
    ]
    Module.controller 'ControllerWidgetExerciseBuilderGroupFieldSelectIndividual', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->
        $scope.form = {}

        $scope.cancelAddNewField = () ->
          $scope.form = {}
          $scope.formSelectIndividualAdd.$setPristine()
          $scope.$parent.viewModel.cancelAddNewField()

        $scope.isFormInvalid = () ->
          if !$scope.formSelectIndividualAdd
            return
          return $scope.formSelectIndividualAdd.$invalid

        $scope.submitField = () ->
          apiRequest.post 'field', {
            name:          $scope.form.name
            type:          'selectIndividual'
            dictionaryUid: $scope.form.dictionaryUid
            groupUid:      $scope.group.uid
            ordinal:       0
          }, (response) ->
            console.log response
          $scope.cancelAddNewField()

        $scope.removeFieldCorrectDictionaryItems = (uid) ->
          $scope.form.fieldCorrectDictionaryItems.splice($scope.form.fieldCorrectDictionaryItems.indexOf(uid), 1)

        $scope.addToFieldCorrectDictionaryItems = (uid) ->
          if !_.isArray $scope.form.fieldCorrectDictionaryItems
            $scope.form.fieldCorrectDictionaryItems = []
          if $scope.form.fieldCorrectDictionaryItems.indexOf(uid) == -1
            $scope.form.fieldCorrectDictionaryItems.push uid

        $scope.dictionaryListDT =
          columnDefs: [
            mData:    null
            aTargets: [0]
            bSortable: false
            sWidth:   '10px'
            mRender: (data, type, full) ->
              return '<a data-ng-click="form.dictionaryUid = \'' + full.uid + '\'; formSelectIndividualAdd.dictionaryUid.$pristine = false; form.fieldCorrectDictionaryItems = undefined;" class="btn blue">Select</a>'
              #return '<input type="radio" data-required name="dictionary" data-ng-model="form.dictionary" value="' + full.uid + '"></input>' #full.name
          ,
            mData:    null
            aTargets: [1]
            mRender: (data, type, full) ->
              return full.name
          ]
          options:
            bStateSave:      true
            iCookieDuration: 2419200
            bJQueryUI:       false
            bPaginate:       true
            bLengthChange:   false
            bFilter:         true
            bInfo:           true
            bDestroy:        true
            bServerSide:     true
            bProcessing:     true
            fnServerData: (sSource, aoData, fnCallback, oSettings) ->
              query = utilBuildDTQuery ['name'],
                ['name'],
                oSettings

              if query.filter and !_.isUndefined(query.filter[0])
                query.filter[0][3] = 'and'

              query.filter.push ['deletedAt', '=', 'null']

              #console.log query

              cacheResponse   = ''
              oSettings.jqXHR = apiRequest.get 'dictionary', [], query, (response) ->
                #console.log 'response'
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

        $scope.dictionaryItemsListDT =
          columnDefs: [
            mData:    null
            aTargets: [0]
            bSortable: false
            sWidth:   '105px'
            mRender: (data, type, full) ->
              html  = '<div style="width:100%;text-align:center;">'
              html += '<a class="btn green" style="margin-left:auto;margin-right:auto;" data-ng-disabled = "(form.fieldCorrectDictionaryItems && form.fieldCorrectDictionaryItems.indexOf(\'' + full.uid + '\') != -1)" data-ng-click="addToFieldCorrectDictionaryItems(\'' + full.uid + '\'); formSelectIndividualAdd.fieldCorrectDictionaryItems.$pristine = false;"><i class="icon-plus m-icon-white"></i> '
              html += '<span style="color:#FFF !important;" data-ng-hide="(form.fieldCorrectDictionaryItems && form.fieldCorrectDictionaryItems.indexOf(\'' + full.uid + '\') != -1)">Select</span>'
              html += '<span style="color:#FFF !important;" data-ng-show="(form.fieldCorrectDictionaryItems && form.fieldCorrectDictionaryItems.indexOf(\'' + full.uid + '\') != -1)">Selected</span>'
              html += '</a>'
              html += '</div>'
          ,
            mData:    null
            aTargets: [1]
            mRender: (data, type, full) ->
              return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].name">' + full.name + '</span>'
          ]
          options:
            bStateSave:      true
            iCookieDuration: 2419200
            bJQueryUI:       false
            bPaginate:       true
            bLengthChange:   false
            bFilter:         true
            bInfo:           true
            bDestroy:        true
            bServerSide:     true
            bProcessing:     true
            fnServerData: (sSource, aoData, fnCallback, oSettings) ->
              query = utilBuildDTQuery ['name'],
                ['name'],
                oSettings

              #console.log 'fnServerData'
              #console.log $scope.form.dictionaryUid
              #console.log $scope.form

              if !$scope.form.dictionaryUid
                fnCallback
                  iTotalRecords:        0
                  iTotalDisplayRecords: 0
                  aaData:               []
                return

              if query.filter and !_.isUndefined(query.filter[0])
                query.filter[0][3] = 'and'

              query.filter.push ['deletedAt', '=', 'null', 'and']
              query.filter.push ['dictionaryUid', '=', $scope.form.dictionaryUid, 'and']

              #console.log query

              cacheResponse   = ''
              oSettings.jqXHR = apiRequest.get 'dictionaryItem', [], query, (response) ->
                console.log 'response'
                console.log response
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


    ]
    Module.controller 'ControllerWidgetExerciseBuilderGroupFieldSelectMultiple', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->
        $scope.form = {}

        $scope.cancelAddNewField = () ->
          $scope.form = {}
          $scope.formSelectMultipleAdd.$setPristine()
          $scope.$parent.viewModel.cancelAddNewField()

    ]
    Module.controller 'ControllerWidgetExerciseBuilderGroupFieldYesNo', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->
        $scope.form = {}

        $scope.cancelAddNewField = () ->
          $scope.form = {}
          $scope.formYesNoAdd.$setPristine()
          $scope.$parent.viewModel.cancelAddNewField()
    ]
    Module.controller 'ControllerWidgetExerciseBuilderGroupFieldPercentageSlider', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->
        $scope.form = {}

        $scope.cancelAddNewField = () ->
          $scope.form = {}
          $scope.formPercentageSliderAdd.$setPristine()
          $scope.$parent.viewModel.cancelAddNewField()

        $scope.submitField = () ->
          apiRequest.post 'field', {
            name:                  $scope.form.name
            type:                  'slider'
            percentageSliderLeft:  $scope.form.leftValue
            percentageSliderRight: $scope.form.rightValue
            groupUid:              $scope.group.uid
            ordinal:               0
          }, (response) ->
            console.log response
          $scope.cancelAddNewField()


        $scope.isFormInvalid = () ->
          if !$scope.formPercentageSliderAdd
            return
          return $scope.formPercentageSliderAdd.$invalid

    ]

    ###
    #
    #  END Field add form controllers
    #
    ###



    ###
    #
    #   GROUP CONTROLLER
    #
    ###
    Module.controller 'ControllerWidgetExerciseBuilderGroupEdit', ['$scope', '$routeParams', 'apiRequest', '$dialog',
      ($scope, $routeParams, apiRequest, $dialog) ->

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

            if !$routeParams.revisionUid
              return

            groupsLength = _.filter(_.toArray($scope.resourcePool[$routeParams.revisionUid].groups), (item) -> !item.deletedAt).length

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
              $scope.resourcePool[$routeParams.revisionUid].groups,
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
                      $scope.resourcePool[$routeParams.revisionUid].groups,
                      _.toArray($scope.resourcePool[$routeParams.revisionUid].groups).length,
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
    ######


    ###
    #
    #  FIELDS CONTROLLERS
    #
    ###
    Module.controller 'ControllerWidgetExerciseBuilderFieldManageOpenResponse', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->
    ]
    Module.controller 'ControllerWidgetExerciseBuilderFieldManageSelectIndividual', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->

        #console.log $scope.field

        $scope.dictionaryItemsDT =
          columnDefs: [
            mData:    null
            aTargets: [0]
            mRender: (data, type, full) ->
              return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].name">' + full.name + '</span>'
          ]
          options:
            bStateSave:      true
            iCookieDuration: 2419200
            bJQueryUI:       false
            bPaginate:       true
            bLengthChange:   false
            bFilter:         true
            bInfo:           true
            bDestroy:        true
            bServerSide:     true
            bProcessing:     true
            fnServerData: (sSource, aoData, fnCallback, oSettings) ->
              query = utilBuildDTQuery ['name'],
                ['name'],
                oSettings

              if query.filter and !_.isUndefined(query.filter[0])
                query.filter[0][3] = 'and'

              query.filter.push ['deletedAt', '=', 'null', 'and']
              query.filter.push ['dictionaryUid', '=', $scope.field.dictionaryUid, 'and']

              cacheResponse   = ''
              oSettings.jqXHR = apiRequest.get 'dictionaryItem', [], query, (response) ->
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

    ]
    Module.controller 'ControllerWidgetExerciseBuilderFieldManageSelectMultiple', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->
    ]
    Module.controller 'ControllerWidgetExerciseBuilderFieldManageYesNo', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->
    ]
    Module.controller 'ControllerWidgetExerciseBuilderFieldManageSlider', ['$scope', 'apiRequest', '$dialog',
      ($scope, apiRequest, $dialog) ->

        $scope.slider =
          value: 50
          step:  5

        #setInterval () ->
        #  console.log $scope.slider
        #, 500


    ]
    ###
    #
    #  END FIELDS CONTROLLERS
    #
    ###





    ###
    #
    #  PRIMARY CONTROLLER
    #
    ###
    Module.controller 'ControllerWidgetExerciseBuilder', ['$scope', '$route', '$routeParams', '$templateCache', 'socket', 'apiRequest', '$dialog',
      ($scope, $route, $routeParams, $templateCache, socket, apiRequest, $dialog) ->


        $scope.viewModel =

          toggleTemplatesListCollapsed: () ->
            options = {}
            options.direction = 'left'
            if !$scope.viewModel.templatesListCollapsed
              $('#templatesListPortlet').effect 'blind', {direction:'left'}, () ->

                setTimeout () ->
                  $scope.viewModel.templatesListCollapsed = !$scope.viewModel.templatesListCollapsed
                  if !$scope.$$phase
                    $scope.$apply()
                , 150

            else
              $scope.viewModel.templatesListCollapsed = !$scope.viewModel.templatesListCollapsed


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
              sWidth:    '45px'
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
            if $scope.newTemplateGroupForm
              $scope.newTemplateGroupForm.$setPristine()
            $scope.viewModel.newTemplateGroupForm = {}

          clearNewTemplateForm: () ->
            $scope.viewModel.showAddNewTemplate = false
            if $scope.newTemplateForm
              $scope.newTemplateForm.$setPristine()
            $scope.viewModel.newTemplateForm = {}

          postNewTemplateGroup: () ->
            #$groupsObj = $scope.viewModel.currentTemplateRevision.groups
            if !$scope.viewModel.routeParams.revisionUid
              return
            $groupsObj = $scope.resourcePool[$scope.viewModel.routeParams.revisionUid].groups

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
                  revisionUid: $scope.viewModel.routeParams.revisionUid
                }, (result) ->
                  $scope.viewModel.clearnewTemplateGroupForm()
                  console.log result


          revisionChangeSummary: ''
          putRevisionChangeSummary: () ->
            apiRequest.put 'revision', [$scope.viewModel.routeParams.revisionUid], {
              changeSummary: $scope.viewModel.revisionChangeSummary
            }, (response) ->
              console.log response


          putRevisionFinalize: () ->
            title = 'Save Revision'
            msg   = 'Save this exercise revision if you\'re done editing. You will not be able to make changes to this revision after your save.'
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
                  apiRequest.put 'revision', [$scope.viewModel.routeParams.revisionUid], {
                    finalized: true
                  }, (response) ->
                    console.log response


          putTemplate: (templateUid) ->
            apiRequest.put 'template', [templateUid], {
              name: $scope.viewModel.formEditTemplateName.name
            }, (response) ->
              console.log response
              $scope.viewModel.showEditTemplateName      = false
              #$scope.viewModel.formEditTemplateName.name = $scope.viewModel.currentTemplate.name



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
              #console.log result


          currentTemplateRevision: {}
          fetchCurrentTemplateRevision: () ->
            if !$scope.viewModel.routeParams.templateUid
              $scope.viewModel.currentTemplateRevision = false
              return
            if !$scope.viewModel.templates
              return
            if !$scope.viewModel.routeParams.templateUid
              return
            return
            $scope.resourcePool[$scope.viewModel.routeParams.templateUid]

            apiRequest.get 'revision', [], {}, (response) ->


            template = $scope.viewModel.templates[$scope.viewModel.routeParams.templateUid]
            $scope.viewModel.currentTemplateRevision = $scope.getLastObjectFromHash template.revisions
            #console.log $scope.viewModel.currentTemplateRevision

          currentTemplate: false
          fetchCurrentTemplate: () ->
            if !$scope.viewModel.routeParams.templateUid
              $scope.viewModel.currentTemplate = false
              return
            apiRequest.get 'template', [$scope.viewModel.routeParams.templateUid], {
              expand: [{
                resource: 'revisions',
                expand: [{resource: 'groups'}]
              }]
            }, (response) ->
              if response.code == 200

                #if !_.isUndefined $scope.resourcePool[$scope.viewModel.routeParams.revisionUid]
                #  $scope.viewModel.revisionChangeSummary = $scope.resourcePool[$scope.viewModel.routeParams.revisionUid].changeSummary

                groupUids = []
                for prop1, template of response.response.data
                  for prop2, revision of template.revisions
                    for prop3, group of revision.groups
                      groupUids.push group.uid

                apiRequest.get 'group', groupUids, {
                  expand: [{resource: 'fields'}]
                }, (response) ->
                  #console.log 'groups'
                  #console.log response


            #$scope.viewModel.currentTemplate = $scope.viewModel.templates[$scope.viewModel.routeParams.templateUid]
            #console.log $scope.viewModel.currentTemplate


        $scope.fieldsSortableOptions =
          connectWith: 'div[data-ui-sortable]'
          disabled: false
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
        $scope.$on 'resourcePut', (e, data) ->

          if !$scope.routeParams.revisionUid
            return

          groupUids = []

          found = false
          for groupUid, group of $scope.resourcePool[$scope.routeParams.revisionUid].groups
            groupUids.push groupUid
            for fieldUid, field of group.fields
              if fieldUid == data['uid']
                found = true
                break

          if found
            clearTimeout rateLimit
            rateLimit = setTimeout () ->
              apiRequest.get 'group', groupUids, {expand: [{resource: 'fields'}]}, (response) ->
                console.log 'GET groups.fields'
                console.log response
            , 100



        hashChangeUpdate = () ->
          $scope.viewModel.showEditTemplateName = false
          $scope.viewModel.routeParams          = $routeParams
          if $routeParams.templateUid
            $scope.viewModel.fetchCurrentTemplate()
          #$scope.viewModel.fetchCurrentTemplateRevision()
          #$scope.viewModel.fetchCurrentTemplate()


        $scope.$on '$routeChangeSuccess', () ->
          hashChangeUpdate()

        hashChangeUpdate()
        $scope.viewModel.fetchCurrentTemplate()

    ]



