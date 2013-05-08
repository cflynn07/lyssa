define [
  'angular'
  'text!views/widgetScheduler/viewWidgetScheduler.html'
], (
  angular
  viewWidgetScheduler
) ->

  (Module) ->

    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewWidgetScheduler', viewWidgetScheduler
    ]



    Module.controller 'ControllerWidgetScheduler', ['$scope', '$route', 'apiRequest'
    ($scope, $route, apiRequest) ->

      $scope.viewModel =
        eventSources: []
        events: []
        updateEvents: () ->
          $scope.viewModel.eventSources = [[]]
          apiRequest.get 'event', [], {}, (response) ->
            console.log 'events'
            console.log response


      $scope.viewModel.updateEvents()

      ###
      $scope.events = [{
        title: 'first test event'
        start: '2013-05-05'
      }, {
        title: 'first test event 2'
        start: '2013-05-05'
      }]

      $scope.eventSources = [$scope.events]


      console.log $scope.eventSources
      ###






      $scope.toggleShowNew = () ->
        $scope.showNew = !$scope.showNew

      ###
      $scope.model =
        showNew: false
        buttons:
          'toggleShowNew': $scope.toggleShowNew
        form:
          type: 'full'
          name: ''
          targetDate: ''
          allowRescheduling: false
          dateRange: ''

      ###

    ]
