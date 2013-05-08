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


      ###
      model.events = [{
        title: 'first test event'
        start: '2013-05-05'
      }, {
        title: 'first test event 2'
        start: '2013-05-05'
      }]
      ###

      $scope.eventSources = []

      getEm = () ->
        apiRequest.get 'event', [], {}, (response) ->

          $scope.eventSources = [{
            title: 'first test event'
            start: '2013-05-05'
          }, {
            title: 'first test event 2'
            start: new Date('Wed May 08 2013 14:46:11 GMT-0400 (EDT)')
          }]
          for obj in $scope.eventSources
            $scope.calendar.fullCalendar 'renderEvent', obj

          setTimeout () ->
            $scope.calendar.fullCalendar 'removeEvents'
            setTimeout () ->
              getEm()
            , 1000
          , 2000

          console.log 'p2'

      getEm()



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
