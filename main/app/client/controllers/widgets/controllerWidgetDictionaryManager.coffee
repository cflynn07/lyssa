define [
  'angular'
  'text!views/widgetDictionaryManager/viewWidgetDictionaryManager.html'
], (
  angular
  viewWidgetDictionaryManager
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetDictionaryManager', viewWidgetDictionaryManager

    Module.controller 'ControllerWidgetDictionaryManager', ($scope, socket) ->

      $scope.dictionary = {}
      $scope.items = ['apple', 'food', 'donut']
      $scope.dictionaries = [
        name: 'employees'
      ,
        name: 'vendors'
      ,
        name: 'birthdays'
      ]
