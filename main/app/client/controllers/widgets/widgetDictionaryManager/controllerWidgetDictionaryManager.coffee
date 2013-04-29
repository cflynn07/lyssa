define [
  'jquery'
  'angular'
  'underscore'
  'text!views/widgetDictionaryManager/viewWidgetDictionaryManager.html'
], (
  $
  angular
  _
  viewWidgetDictionaryManager
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetDictionaryManager', viewWidgetDictionaryManager


    Module.controller 'ControllerWidgetDictionaryManager', ($scope, $route, $routeParams, socket, apiRequest, $filter, $dialog) ->

      #Trying the object literal as a prop
      #on the scope object approach
      $scope.viewModel =
        dictionaries:               {}

        dictionariesArray:          []
        activeDictionaryItemsArray: []

        activeDictionaryUid:        ''
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

        dictionaryListOptions:
          bStateSave: true
          iCookieDuration: 2419200 # 1 month
          bJQueryUI: true
          bPaginate: false
          bLengthChange: false
          bFilter: false
          bInfo: true
          bDestroy: true

        columnDefsActiveDictionaryItems: [
          mDataProp: "name"
          aTargets: [0]
          sWidth: '50%'
          mRender: (data, type, full) ->

            name = 'editDictionaryItemForm' + full.uid.replace /-/g, '_'

            html = '<form name="' + name + '" novalidate>'
            html += '<span data-ng-model="$parent.viewModel.dictionaries[$parent.viewModel.activeDictionaryUid].dictionaryItems[$parent.viewModel.editingDictionaryItemUid].name" data-ng-hide="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" >' + data + '</span>'
            html += '<input name="name" data-required data-ng-minlength = "{{clientOrmShare.dictionaryItem.model.name.validate.len[0]}}" data-ng-maxlength = "{{clientOrmShare.dictionaryItem.model.name.validate.len[1]}}" data-ng-show="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" type="text" data-ng-model="$parent.viewModel.editingDictionaryItemTempValue">'
            html += '<span data-ng-show="' + name + '.name.$error.minlength" style="color:red;" class="help-inline">Name must be longer than {{clientOrmShare.dictionaryItem.model.name.validate.len[0]}} characters</span>'
            html += '<span data-ng-show="' + name + '.name.$error.maxlength" style="color:red;" class="help-inline">Name must be shorter than {{clientOrmShare.dictionaryItem.model.name.validate.len[1]}} characters</span>'
            html += '</form>'

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

            html = '<div class="inline-content" style="text-align:center;">'
            html +=  '<a href data-ng-hide="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" data-ng-click="$parent.viewModel.deleteConfirmDialogDictionaryItem(\'' + full.uid + '\')" class="btn red">Delete</a>'
            html += ' <a href data-ng-hide="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" data-ng-click="$parent.viewModel.editDictionaryItem(\'' + full.uid + '\')" class="btn blue">Edit</a>'
            html += ' <a href data-ng-disabled="' + name + '.$invalid" data-ng-show="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" data-ng-click="$parent.viewModel.saveEditingDictionaryItem(' + name + '.$invalid' + ')" class="btn green">Save</a>'
            html += ' <a href data-ng-show="$parent.viewModel.editingDictionaryItemUid == \'' + full.uid + '\'" data-ng-click="$parent.viewModel.cancelEditDictionaryItem()" class="btn red">Cancel</a></div>'

            return html
        ]

        columnDefsDictionaryList: [
          mDataProp: "name"
          mRender: (data, type, full) ->
            resHtml  = '<a href="#' + $scope.viewRoot + '/' + full.uid + '">'
            resHtml += data #+ ' (' + $scope.getKeysLength(full.dictionaryItems) + ')'
            resHtml += '</a>'
            return resHtml
          aTargets: [0]
        ,
          mData: null
          sWidth: '15%'
          mRender: (data, type, full) ->
            return $scope.getKeysLength(full.dictionaryItems)
          aTargets: [1]
        ,
          mData: null
          bSortable: false
          sWidth: '35%'
          mRender: (data, type, full) ->
            return '<div class="inline-content" style="text-align:center;"><a data-ng-href data-ng-click="$parent.viewModel.deleteConfirmDialogDictionary(\'' + full.uid + '\')" class="btn red">Delete</a> <a href="#' + $scope.viewRoot + '/' + full.uid  + '" class="btn blue">Edit</a></div>'
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
            dictionaryUid: $scope.viewModel.dictionaries[$scope.viewModel.activeDictionaryUid].uid
            name: $scope.viewModel.newDictionaryItemForm.name
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
        $scope.viewModel.editingDictionaryItemTempValue = $scope.viewModel.dictionaries[$scope.viewModel.activeDictionaryUid].dictionaryItems[$scope.viewModel.editingDictionaryItemUid].name
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


      setActiveDictionary = () ->
        $scope.viewModel.activeDictionaryUid = $routeParams.dictionaryUid
      $scope.$on '$routeChangeSuccess', () ->
        #reset forms...
        $scope.viewModel.showAddDictionaryItems = false
        $scope.newDictionaryItemForm.$setPristine()
        $scope.viewModel.newDictionaryItemForm  = {}

        $scope.viewModel.showAddNewDictionary = false
        $scope.newDictionaryForm.$setPristine()
        $scope.viewModel.newDictionaryForm    = {}

        setActiveDictionary()
      setActiveDictionary()


      apiRequest.get 'dictionary', [], {expand: [{'resource':'dictionaryItems'}]}, (response) ->
        window.responsePlay           = response
        $scope.viewModel.dictionaries = response.response


