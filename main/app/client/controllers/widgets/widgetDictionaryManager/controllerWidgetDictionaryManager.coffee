define [
  'jquery'
  'angular'
  'angular-ui'
  'bootstrap'
  'underscore'
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
  viewWidgetDictionaryManager
  viewWidgetDictionaryManagerDictionaryItemsButtonsEJS
  viewWidgetDictionaryManagerListButtonsEJS
  viewWidgetDictionaryManagerDictionaryItemEditEJS
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetDictionaryManager', viewWidgetDictionaryManager


    Module.controller 'ControllerWidgetDictionaryManager', ($scope, $route, $routeParams, socket, apiRequest, $filter, $dialog) ->

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
          bStateSave: true
          iCookieDuration: 2419200 # 1 month
          bJQueryUI: true
          bPaginate: true
          bLengthChange: true
          bFilter: true
          bInfo: true
          bDestroy: true
          #sPaginationType: 'two_button'

        dictionaryListOptions:
          bStateSave:      true
          iCookieDuration: 2419200 # 1 month
          bJQueryUI:       true
          bPaginate:       true
          bLengthChange:   true
          bFilter:         false
          bInfo:           true
          bDestroy:        true




        columnDefsCurrentDictionaryItems: [
          mDataProp: "name"
          aTargets: [0]
          sWidth: '50%'
          mRender: (data, type, full) ->

            name = 'editDictionaryItemForm' + full.uid.replace /-/g, '_'
            name = $scope.escapeHtml name
            uid  = $scope.escapeHtml full.uid #.replace /-/g, ''

            html = new EJS(text: viewWidgetDictionaryManagerDictionaryItemEditEJS).render
              name: name
              uid:  uid
              data: data

          #  html = '<form name="' + name + '" novalidate>'
          #  html += '<span data-ng-model="$parent.viewModel.dictionaries[$parent.viewModel.currentDictionaryUid].dictionaryItems[$parent.viewModel.editingDictionaryItemUid].name" data-ng-hide="$parent.viewModel.editingDictionaryItemUid == \'' + uid + '\'" >' + data + '</span>'
          #  html += '<input name="name" data-required data-ng-minlength = "{{clientOrmShare.dictionaryItem.model.name.validate.len[0]}}" data-ng-maxlength = "{{clientOrmShare.dictionaryItem.model.name.validate.len[1]}}" data-ng-show="$parent.viewModel.editingDictionaryItemUid == \'' + uid + '\'" type="text" data-ng-model="$parent.viewModel.editingDictionaryItemTempValue">'
          #  html += '<span data-ng-show="' + name + '.name.$error.minlength" style="color:red;" class="help-inline">Name must be longer than {{clientOrmShare.dictionaryItem.model.name.validate.len[0]}} characters</span>'
          #  html += '<span data-ng-show="' + name + '.name.$error.maxlength" style="color:red;" class="help-inline">Name must be shorter than {{clientOrmShare.dictionaryItem.model.name.validate.len[1]}} characters</span>'
          #  html += '</form>'

        ,
          mData: null
          aTargets: [1]
          mRender: (data, type, full) ->
            return '0 templates'
        ,
          mData: null
          sWidth: '30%'
          aTargets: [2]
          mRender: (data, type, full) ->

            name = 'editDictionaryItemForm' + full.uid.replace /-/g, '_'
            name = $scope.escapeHtml name
            uid  = $scope.escapeHtml full.uid.replace /-/g, ''

            html = new EJS({text: viewWidgetDictionaryManagerDictionaryItemsButtonsEJS}).render
              name: name
              uid:  uid
              full: full

            #html = '<div class="inline-content" style="text-align:center;">'
            #html += '<button data-ng-hide="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" data-ng-click="$parent.viewModel.deleteConfirmDialogDictionaryItem(\'' + full.uid + '\')" class="btn red">Delete</button>'
            #html += ' <button data-ng-hide="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" data-ng-click="$parent.viewModel.editDictionaryItem(\'' + full.uid + '\')" class="btn blue">Edit</button>'
            #html += ' <button data-ng-show="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" data-ng-disabled="' + name + '.$invalid" data-ng-click="$parent.viewModel.saveEditingDictionaryItem(' + name + '.$invalid' + ')" class="btn green">Save</button>'
            #html += ' <button data-ng-show="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" data-ng-click="$parent.viewModel.cancelEditDictionaryItem()" class="btn red">Cancel</button></div>'

            return html
        ]




        columnDefsDictionaryList: [
          mDataProp: "name"
          mRender: (data, type, full) ->
            resHtml  = '<a href="#' + $scope.viewRoot + '/' + $scope.escapeHtml(full.uid) + '">'
            resHtml += data #+ ' (' + $scope.getKeysLength(full.dictionaryItems) + ')'
            resHtml += '</a>'
            return resHtml
          aTargets: [0]
        ,
          mData: null
          sWidth: '20%'
          mRender: (data, type, full) ->
            return $scope.getKeysLength(full.dictionaryItems)
          aTargets: [1]
        ,
          mData: null
          bSortable: false
          sWidth: '20%'
          mRender: (data, type, full) ->

            uid      = $scope.escapeHtml(full.uid)
            viewRoot = $scope.viewRoot

            html = new EJS({text: viewWidgetDictionaryManagerListButtonsEJS}).render
              uid:      uid
              viewRoot: viewRoot

            #return '<div class="inline-content" style="text-align:center;"><button data-ng-click="$parent.viewModel.deleteConfirmDialogDictionary(\'' + uid + '\')" class="btn red">Delete</button> <a href="#' + $scope.viewRoot + '/' + uid + '" class="btn blue">Edit</a></div>'
          aTargets: [2]
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


      $scope.viewModel.editingDictionaryItemUid = ''
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
        window.responsePlay           = response
        $scope.viewModel.dictionaries = response.response


