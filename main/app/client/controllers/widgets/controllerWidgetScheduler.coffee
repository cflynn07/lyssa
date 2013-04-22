define [
  'angular'
  'text!views/widgetScheduler/viewWidgetScheduler.html'
], (
  angular
  viewWidgetScheduler
) ->

  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetScheduler', viewWidgetScheduler

    Module.controller 'ControllerWidgetScheduler', ($scope, $route) ->

      $scope.eventSources = []
      #  url: "http://www.google.com/calendar/feeds/usa__en%40holiday.calendar.google.com/public/basic"
      #  className: 'gcal-event'
      #  currentTimezone: 'America/Chicago'
      $scope.events = []
      $scope.eventSource = {}


      $scope.toggleShowNew = () ->
        console.log 'tsn'
        $scope.showNew = !$scope.showNew

      $scope.model =
        showNew: false
        buttons:
          'toggleShowNew': $scope.toggleShowNew
