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







      $scope.viewModel =
        dictionaries:               {}

        dictionariesArray:          []
        activeDictionaryItemsArray: []

        activeDictionaryUid:        ''
        showAddNewDictionary:       false
        newDictionaryForm:          {}

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
        ,
          mData: null
          aTargets: [1]
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
          mRender: (data, type, full) ->
            return $scope.getKeysLength(full.dictionaryItems)
          aTargets: [1]
        ,
          mData: null
          bSortable: false
          mRender: (data, type, full) ->
            return '<div class="inline-content" style="text-align:center;"><a data-ng-href data-ng-click="$parent.viewModel.deleteConfirmDialog(\'' + full.uid + '\')" class="btn red mini">Delete</a> <a href="#' + $scope.viewRoot + '/' + full.uid  + '" class="btn blue mini">Edit</a></div>'
          aTargets: [2]
        ]



        postNewDictionary: () ->
          apiRequest.post 'dictionary', {
            name: $scope.viewModel.newDictionaryForm.name
          }, (response) ->
            return
          $scope.viewModel.newDictionaryForm = {}







      $scope.viewModel.deleteConfirmDialog = (dictionaryUid) ->

        apiRequest.get 'dictionary', [dictionaryUid], {}, (response) ->
          console.log response


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
              return
              alert('dialog closed with result: ' + result)










      $scope.$on '$routeChangeSuccess', () ->
        $scope.viewModel.activeDictionaryUid = $routeParams.dictionaryUid





















      updateActiveDictionaryItemsArray = () ->
        console.log 'updateActiveDictionaryItemsArray'
        $scope.viewModel.activeDictionaryItemsArray = []
        if !_.isUndefined $scope.viewModel.dictionaries[$scope.viewModel.activeDictionaryUid]
          for propName, propVal of $scope.viewModel.dictionaries[$scope.viewModel.activeDictionaryUid].dictionaryItems
            $scope.viewModel.activeDictionaryItemsArray.push propVal


      $scope.$watch 'viewModel.activeDictionaryUid', (newVal, oldVal) ->
        updateActiveDictionaryItemsArray()
      , true


      $scope.$watch 'viewModel.dictionaries', (newVal, oldVal) ->
        updateActiveDictionaryItemsArray()

        $scope.viewModel.dictionariesArray = []
        for propName, propVal of $scope.viewModel.dictionaries
          $scope.viewModel.dictionariesArray.push propVal
      , true


      apiRequest.get 'dictionary', [], {expand: [{'resource':'dictionaryItems'}]}, (response) ->
        window.responsePlay           = response
        $scope.viewModel.dictionaries = response.response
















      $scope.myCallback = (nRow, aData, iDisplayIndex, iDisplayIndexFull) ->
        $("td:eq(2)", nRow).bind "click", ->
          $scope.$apply ->
            $scope.someClickHandler aData
        nRow

      $scope.someClickHandler = (info) ->
        $scope.message = "clicked: " + info.price

      $scope.columnDefs = [
        mDataProp: "name"
        aTargets: [0]
      ,
        mData: null
        aTargets: [1]
      ]








      $scope.sampleProductCategories = [
        name: "1948 Porsche 356-A Roadster"
        price: 53.9
        category: "Classic Cars"
        action: "x"
      ,
        name: "1948 Porsche Type 356 Roadster"
        price: 62.16
        category: "Classic Cars"
        action: "x"
      ,
        name: "1949 Jaguar XK 120"
        price: 47.25
        category: "Classic Cars"
        action: "x"
      ,
        name: "1936 Harley Davidson El Knucklehead"
        price: 24.23
        category: "Motorcycles"
        action: "x"
      ,
        name: "1957 Vespa GS150"
        price: 32.95
        category: "Motorcycles"
        action: "x"
      ,
        name: "1960 BSA Gold Star DBD34"
        price: 37.32
        category: "Motorcycles"
        action: "x"
      ,
        name: "1900s Vintage Bi-Plane"
        price: 34.25
        category: "Planes"
        action: "x"
      ,
        name: "1900s Vintage Tri-Plane"
        price: 36.23
        category: "Planes"
        action: "x"
      ,
        name: "1928 British Royal Navy Airplane"
        price: 66.74
        category: "Planes"
        action: "x"
      ,
        name: "1980s Black Hawk Helicopter"
        price: 77.27
        category: "Planes"
        action: "x"
      ,
        name: "ATA: B757-300"
        price: 59.33
        category: "Planes"
        action: "x"
      ]




















      $scope.getKeysLength = (obj) ->
        length = 0
        for key, value of obj
          if !_.isUndefined value['uid']
            length++
        return length

      $scope.putDictionaryItem = (dictionaryItem) ->
        socket.apiRequest 'PUT',
          '/dictionaries',
          {},
          {
            uid:  dictionaryItem.uid
            name: dictionaryItem.name
            dictionaryUid: dictionaryItem.dictionaryUid
          },
          (response) ->
            if response.code is 200
              $scope.fetchData()

      $scope.fetchData = () ->
        return
        apiRequest.get 'dictionary', [], {expand: [{'resource':'dictionaryItems'}]}, (response) ->
          window.responsePlay           = response
          $scope.viewModel.dictionaries = response.response

      $scope.fetchData()









      testObj = {
        "name":"gasdfasdfasdfasdfasdf",
        "dictionaryUid":"3b5c6c5b-ca10-4c96-a9e3-82cfa15e258c"
      }
      #apiRequest.post 'dictionaryItem', [testObj], (response) ->
      #  return
      #  console.log 'post test'
      #  console.log response




      $scope.persist = (dictionaryItem) ->
        apiRequest.put 'dictionaryItem',
          dictionaryItem.uid, {
            name: dictionaryItem.name
          }, (response) ->
            console.log response


      $scope.viewModel.activeDictionaryUid = $routeParams.dictionaryUid
      $scope.$on '$routeChangeSuccess', () ->
        $scope.viewModel.activeDictionaryUid = $routeParams.dictionaryUid
