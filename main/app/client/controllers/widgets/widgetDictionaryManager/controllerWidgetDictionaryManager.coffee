define [
  'jquery'
  'angular'
  'angular-ui'
  'bootstrap'
  'underscore'
  'cs!utils/utilBuildDTQuery'
  'text!views/widgetDictionaryManager/viewWidgetDictionaryManager.html'
  'text!views/widgetDictionaryManager/viewWidgetDictionaryManagerDictionaryItemsButtonsEJS.html'
  'text!views/widgetDictionaryManager/viewWidgetDictionaryManagerListButtonsEJS.html'
  'text!views/widgetDictionaryManager/viewWidgetDictionaryManagerDictionaryItemEditEJS.html'
], (
  $
  angular
  angularUi
  bootstrap
  _
  utilBuildDTQuery
  viewWidgetDictionaryManager
  viewWidgetDictionaryManagerDictionaryItemsButtonsEJS
  viewWidgetDictionaryManagerListButtonsEJS
  viewWidgetDictionaryManagerDictionaryItemEditEJS
) ->
  (Module) ->

    Module.run ['$templateCache', ($templateCache) ->
      $templateCache.put 'viewWidgetDictionaryManager', viewWidgetDictionaryManager
    ]

    Module.controller 'ControllerWidgetDictionaryManager',
      ['$scope', '$route', '$routeParams', 'socket', 'apiRequest', '$filter', '$dialog',
        ($scope, $route, $routeParams, socket, apiRequest, $filter, $dialog) ->

          #Trying the object literal as a prop
          #on the scope object approach
          $scope.viewModel =
            dictionaries:               {}

            currentDictionaryUid:        ''
            showAddNewDictionary:       false
            showAddDictionaryItems:     false

            newDictionaryForm:          {}
            newDictionaryItemForm:      {}


            dictionaryItemsOptions:
              bStateSave:      true
              iCookieDuration: 2419200 # 1 month
              bJQueryUI:       false
              bPaginate:       true
              bLengthChange:   true
              bFilter:         true
              bInfo:           true
              bDestroy:        true
              bServerSide:     true
              bProcessing:     true
              fnServerData: (sSource, aoData, fnCallback, oSettings) ->




            dictionaryListOptions:
              bStateSave:      true
              iCookieDuration: 2419200 # 1 month
              bJQueryUI:       false
              bPaginate:       true
              bLengthChange:   true
              bFilter:         false
              bInfo:           true
              bDestroy:        true

            columnDefsCurrentDictionaryItems: [
              mDataProp:  "name"
              aTargets:   [0]
              sWidth:     '50%'
              mRender: (data, type, full) ->

                name = 'editDictionaryItemForm' + full.uid.replace /-/g, '_'
                name = $scope.escapeHtml name
                uid  = $scope.escapeHtml full.uid

                html = new EJS(text: viewWidgetDictionaryManagerDictionaryItemEditEJS).render
                  name: name
                  uid:  uid
                  data: data
            ,
              mData:    null
              aTargets: [1]
              mRender: (data, type, full) ->
                return '0 templates'
            ,
              mData:     null
              bSortable: false
              sWidth:    '30%'
              aTargets:  [2]
              mRender: (data, type, full) ->

                name = 'editDictionaryItemForm' + full.uid.replace /-/g, '_'
                name = $scope.escapeHtml name
                uid  = $scope.escapeHtml full.uid.replace /-/g, ''

                html = new EJS({text: viewWidgetDictionaryManagerDictionaryItemsButtonsEJS}).render
                  name: name
                  uid:  uid
                  full: full

                return html
            ]




            columnDefsDictionaryList: [
              mDataProp: 'name'
              aTargets: [0]
              mRender: (data, type, full) ->
                resHtml  = '<a href="#' + $scope.viewRoot + '/' + $scope.escapeHtml(full.uid) + '">'
                resHtml += data #+ ' (' + $scope.getKeysLength(full.dictionaryItems) + ')'
                resHtml += '</a>'
                return resHtml
            ,
              mData:  null
              sWidth: '20%'
              aTargets: [1]
              mRender: (data, type, full) ->
                return $scope.getKeysLength(full.dictionaryItems)
            ,
              mData:     null
              bSortable: false
              sWidth:    '20%'
              aTargets: [2]
              mRender: (data, type, full) ->

                uid      = $scope.escapeHtml(full.uid)
                viewRoot = $scope.viewRoot

                html = new EJS({text: viewWidgetDictionaryManagerListButtonsEJS}).render
                  uid:      uid
                  viewRoot: viewRoot

            ]

            postNewDictionary: () ->
              apiRequest.post 'dictionary', {
                name: $scope.viewModel.newDictionaryForm.name
              }, (response) ->
                return
              $scope.viewModel.newDictionaryForm = {}

            postNewDictionaryItem: () ->
              #console.log 'p1'
              apiRequest.post 'dictionaryItem', {
                dictionaryUid: $scope.viewModel.dictionaries[$scope.viewModel.currentDictionaryUid].uid
                name:          $scope.viewModel.newDictionaryItemForm.name
              }, (response) ->
                #console.log response
                return
              $scope.viewModel.newDictionaryItemForm = {}


          $scope.viewModel.deleteConfirmDialogDictionary = (dictionaryUid) ->

            apiRequest.get 'dictionary', [dictionaryUid], {}, (response) ->

              if response.code == 200

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
                      apiRequest.delete 'dictionary', dictionaryUid, (result) ->
                        #console.log result



          $scope.viewModel.deleteConfirmDialogDictionaryItem = (dictionaryItemUid) ->

            apiRequest.get 'dictionaryItem', [dictionaryItemUid], {}, (response) ->
              #console.log response

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
                    apiRequest.delete 'dictionaryItem', dictionaryItemUid, (result) ->
                      #console.log result


          $scope.viewModel.cancelEditDictionaryItem = () ->
            $scope.viewModel.editingDictionaryItemTempValue = ''
            $scope.viewModel.editingDictionaryItemUid       = ''

          $scope.viewModel.editDictionaryItem = (dictionaryUid) ->
            $scope.viewModel.editingDictionaryItemUid       = dictionaryUid
            $scope.viewModel.editingDictionaryItemTempValue = $scope.viewModel.dictionaries[$scope.viewModel.currentDictionaryUid].dictionaryItems[$scope.viewModel.editingDictionaryItemUid].name
          $scope.viewModel.saveEditingDictionaryItem = (isInvalid) ->
            if isInvalid
              return
            apiRequest.put 'dictionaryItem', $scope.viewModel.editingDictionaryItemUid, {
              name: $scope.viewModel.editingDictionaryItemTempValue
            }, (response) ->
              #console.log 'response'
              #console.log response
            $scope.viewModel.cancelEditDictionaryItem()

          $scope.viewModel.editingDictionaryItemUid       = ''
          $scope.viewModel.editingDictionaryItemTempValue = ''


          setCurrentDictionary = () ->
            $scope.viewModel.currentDictionaryUid = $routeParams.dictionaryUid

          $scope.$on '$routeChangeSuccess', () ->
            #reset forms...
            $scope.viewModel.showAddDictionaryItems = false
            $scope.newDictionaryItemForm.$setPristine()
            $scope.viewModel.newDictionaryItemForm  = {}

            $scope.viewModel.showAddNewDictionary = false
            $scope.newDictionaryForm.$setPristine()
            $scope.viewModel.newDictionaryForm    = {}

            setCurrentDictionary()
          setCurrentDictionary()


          apiRequest.get 'dictionary', [], {expand: [{'resource':'dictionaryItems'}]}, (response) ->

            #dictArr = []
            #for key, value of response.response.data
            #  dictArr.push value

            dictArr = response.response.data


          #  window.responsePlay           = response
            $scope.viewModel.dictionaries = dictArr

      ]

