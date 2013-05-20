define [
  'jquery'
  'angular'
  'ejs'
  'cs!utils/utilBuildDTQuery'

  'text!views/widgetScheduler/viewWidgetScheduler.html'
  'text!views/widgetScheduler/viewWidgetSchedulerListButtonsEJS.html'
  'text!views/widgetScheduler/viewPartialSchedulerAddExerciseForm.html'
], (
  $
  angular
  EJS
  utilBuildDTQuery

  viewWidgetScheduler
  viewWidgetSchedulerListButtonsEJS
  viewPartialSchedulerAddExerciseForm
) ->

  (Module) ->

    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewWidgetScheduler',
        viewWidgetScheduler
      $templateCache.put 'viewPartialSchedulerAddExerciseForm',
        viewPartialSchedulerAddExerciseForm
    ]

    Module.controller 'ControllerWidgetScheduler', ['$scope', '$route', '$routeParams', 'apiRequest'
    ($scope, $route, $routeParams, apiRequest) ->

      viewModel =

        addNewEventForm:       {}
        routeParams:           $routeParams

        events:                {}
        calendarEventsObjects: []

        eventListDT:
          detailRow: (obj) ->
            return ''
          columnDefs: [
            mData:     null
            aTargets:  [0]
            bSortable: true
            mRender: (data, type, full) ->
              resHtml = '<a href="#' + $scope.viewRoot + '/' + $scope.escapeHtml(full.uid) + '">'
              if full.name
                resHtml += '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].name">' + $scope.escapeHtml(full.name) + '</span>'
              resHtml += '</a>'
              return resHtml
          ,
            mData:     null
            aTargets:  [1]
            bSortable: true
            sWidth:    '45px'
            mRender: (data, type, full) ->
              resHtml = '<span >' + '' + '</span>'
          ,
            mData:     null
            aTargets:  [2]
            bSortable: true
            mRender: (data, type, full) ->
              return '--'
          ]
          options:
            bStateSave:      true
            iCookieDuration: 2419200
            bJQueryUI:       false
            bPaginate:       true
            bLengthChange:   true
            bFilter:         false
            bInfo:           true
            bDestroy:        true
            bServerSide:     true
            bProcessing:     true
            fnServerData: (sSource, aoData, fnCallback, oSettings) ->
              query = utilBuildDTQuery ['name', 'type'],
                ['name', 'type'],
                oSettings

              query.filter.push ['deletedAt', '=', 'null']

              cacheResponse   = ''
              oSettings.jqXHR = apiRequest.get 'event', [], query, (response) ->
                if response.code == 200

                  responseDataString = JSON.stringify(response.response)
                  if cacheResponse == responseDataString
                    return
                  cacheResponse = responseDataString

                  dataArr = _.toArray response.response.data

                  fnCallback
                    iTotalRecords:        response.response.length
                    iTotalDisplayRecords: response.response.length
                    aaData:               dataArr


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

















        employees :            {}
        newTemplateFormEmployeesDT:
          options:
            bStateSave:      true
            iCookieDuration: 2419200
            bJQueryUI:       false
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












      viewModel.calendarEventsObjects = [{
        title: 'new event'
        start: new Date()
      }]




      calConfObj = {
        events: (start, end, callback) ->
          console.log 'events function'
          console.log arguments
          callback [{
            title: 'Test Event'
            date:  new Date(end + ' +7200')
          }]
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
        return
        viewModel.renderEvents()
      , true



      $scope.viewModel = viewModel

    ]
