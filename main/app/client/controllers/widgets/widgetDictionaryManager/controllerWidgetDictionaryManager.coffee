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

    Module.controller 'ControllerWidgetDictionaryManager', ($scope, $route, $routeParams, socket) ->

      $scope.dictionaries     = []
      $scope.activeDictionary = false
      $scope.items            = ['foo', 'bar', 'tst']


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

      #$scope.



      $scope.findActiveDictionary = () ->
        if _.isUndefined $routeParams.dictionaryUid
          $scope.activeDictionary = false
        else
          for obj in $scope.dictionaries
            if obj.uid == $routeParams.dictionaryUid
              $scope.activeDictionary = obj
              return

      $scope.fetchData = () ->
        socket.apiRequest 'GET',
          '/dictionaries',
          {
            expand: [{resource: 'dictionaryItems'}]
          },
          {},
          (response) ->
            if response.code is 200
              $scope.dictionaries = response.response
              $scope.findActiveDictionary()

      $scope.fetchData()



      $scope.$on '$routeChangeSuccess', () ->
        $scope.findActiveDictionary()
