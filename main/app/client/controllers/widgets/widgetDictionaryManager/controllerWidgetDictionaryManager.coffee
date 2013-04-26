define [
  'angular'
  'underscore'
  'text!views/widgetDictionaryManager/viewWidgetDictionaryManager.html'
], (
  angular
  _
  viewWidgetDictionaryManager
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetDictionaryManager', viewWidgetDictionaryManager




    Module.controller 'ControllerWidgetDictionaryManager', ($scope, $route, $routeParams, socket, apiRequest) ->


      $scope.viewModel =
        dictionaries: {}
        activeDictionaryUid: ''


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




      apiRequest.get 'dictionary', [], {}, (response) ->
        window.responsePlay           = response
        $scope.viewModel.dictionaries = response.response





      $scope.persist = (dictionaryItem) ->
        apiRequest.put 'dictionaryItem',
          dictionaryItem.uid, {
            name: dictionaryItem.name
          }, (response) ->
            console.log response


      $scope.viewModel.activeDictionaryUid = $routeParams.dictionaryUid
      $scope.$on '$routeChangeSuccess', () ->
        $scope.viewModel.activeDictionaryUid = $routeParams.dictionaryUid
