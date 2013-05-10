define [
  'jquery'
  'angular'
  'ejs'
  'text!views/widgetScheduler/viewWidgetScheduler.html'
  'text!views/widgetScheduler/viewWidgetSchedulerListButtonsEJS.html'
], (
  $
  angular
  EJS
  viewWidgetScheduler
  viewWidgetSchedulerListButtonsEJS
) ->

  (Module) ->

    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewWidgetScheduler', viewWidgetScheduler
    ]

    Module.controller 'ControllerWidgetScheduler', ['$scope', '$route', '$routeParams', 'apiRequest'
    ($scope, $route, $routeParams, apiRequest) ->

      viewModel =
        addNewEventForm:       {}
        routeParams:           $routeParams
        events:                {}
        calendarEventsObjects: []

        employees :            {}
        newTemplateFormEmployeesDT:
          options:
            bStateSave:      true
            iCookieDuration: 2419200
            bJQueryUI:       true
            bPaginate:       true
            bLengthChange:   true
            bFilter:         false
            bInfo:           true
            bDestroy:        true
          columnDefs: [
            mData:    null
            aTargets: [0]
            mRender: (data, type, full) ->
              return full.firstName
          ,
            mData:    null
            aTargets: [1]
            mRender: (data, type, full) ->
              return full.email

          ,
            mData:    null
            aTargets: [2]
            mRender: (data, type, full) ->
              return 'test'
          ]


        exerciseListDT:
          detailRow: (obj) ->
            uid = $scope.escapeHtml obj.uid
            return ''
          columnDefs: [
            mData:  null
            aTargets:   [0]
            mRender: (data, type, full) ->
              resHtml  = '<a href="#' + $scope.viewRoot + '/' + $scope.escapeHtml(full.uid) + '">'
              if full.name
                resHtml += $scope.escapeHtml(full.name)
              resHtml += '</a>'
              return resHtml
          ,
            mData:      null
            aTargets:   [1]
            mRender: (data, type, full) ->
              html = new EJS({text: viewWidgetSchedulerListButtonsEJS}).render
                full:     full
                name:     full.name
                viewRoot: $scope.viewRoot
              #uid = $scope.escapeHtml full.uid
              #html = ''
          ]
          options:
            bStateSave:      true
            iCookieDuration: 2419200
            bJQueryUI:       true
            bPaginate:       true
            bLengthChange:   true
            bFilter:         false
            bInfo:           true
            bDestroy:        true
        renderEvents: () ->

          $('#primaryFullCalendar')
            .fullCalendar('removeEvents')
            .fullCalendar('removeEventSources')
          $('#secondaryFullCalendar')
            .fullCalendar('removeEvents')
            .fullCalendar('removeEventSources')

          eventsArray = []
          for uid, eventObj of viewModel.events
            eventObj =
              title: eventObj.name
              start: new Date(eventObj.dateTime)
            eventsArray.push eventObj
          viewModel.calendarEventsObjects = eventsArray

          $('#primaryFullCalendar')
            .fullCalendar('addEventSource', viewModel.calendarEventsObjects)
          $('#secondaryFullCalendar')
            .fullCalendar('addEventSource', viewModel.calendarEventsObjects)
          $('#primaryFullCalendar')
            .fullCalendar('refetchEvents')
          $('#secondaryFullCalendar')
            .fullCalendar('refetchEvents')


      viewModel.calendarEventsObjects = [{
        title: 'new event'
        start: new Date()
      }]

      calConfObj = {
        events: viewModel.calendarEventsObjects
      }

      $('#primaryFullCalendar')
        .fullCalendar(calConfObj)
      $('#secondaryFullCalendar')
        .fullCalendar(calConfObj)


      hashChangeUpdate = () ->
        $scope.viewModel.routeParams = $routeParams
      $scope.$on '$routeChangeSuccess', () ->
        hashChangeUpdate()


      $scope.$watch 'viewModel.events', (value) ->
        viewModel.renderEvents()
      , true

      #FETCH DATA!
      apiRequest.get 'event', [], {}, (response) ->
        viewModel.events = response.response

      apiRequest.get 'template', [], {expand: [{resource:'revisions'}]}, (response) ->
        viewModel.templates = response.response

      apiRequest.get 'employee', [], {}, (response) ->
        viewModel.employees = response.response

      $scope.viewModel = viewModel

    ]
