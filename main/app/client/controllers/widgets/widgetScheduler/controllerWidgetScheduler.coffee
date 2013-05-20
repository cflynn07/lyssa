define [
  'jquery'
  'angular'
  'ejs'
  'cs!utils/utilBuildDTQuery'
  'underscore'

  'text!views/widgetScheduler/viewWidgetScheduler.html'
  'text!views/widgetScheduler/viewWidgetSchedulerListButtonsEJS.html'
  'text!views/widgetScheduler/viewPartialSchedulerAddExerciseForm.html'
], (
  $
  angular
  EJS
  utilBuildDTQuery
  _

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



    Module.controller 'ControllerWidgetSchedulerAddEvent', ['$scope', '$route', '$routeParams', 'apiRequest'
      ($scope, $route, $routeParams, apiRequest) ->

        viewModel =
          employeeListDT:
            detailRow: (obj) ->
              return new EJS({text: viewPartialEmployeeManagerEditEmployeeEJS}).render obj
            options:
              bProcessing:     true
              bStateSave:      true
              iCookieDuration: 2419200 # 1 month
              bPaginate:       true
              bLengthChange:   true
              bFilter:         true
              bInfo:           true
              bDestroy:        true
              bServerSide:     true
              sAjaxSource:     '/'
              fnServerData: (sSource, aoData, fnCallback, oSettings) ->
                query = utilBuildDTQuery ['firstName', 'lastName', 'email', 'phone'],
                  ['firstName', 'lastName', 'email', 'phone'],
                  oSettings

                cacheResponse   = ''
                oSettings.jqXHR = apiRequest.get 'employee', [], query, (response) ->
                  if response.code == 200

                    responseDataString = JSON.stringify(response.response)
                    if cacheResponse == responseDataString
                      return
                    cacheResponse = responseDataString
                    empArr = _.toArray response.response.data

                    fnCallback
                      iTotalRecords:        response.response.length
                      iTotalDisplayRecords: response.response.length
                      aaData:               empArr

            columnDefs: [
              mData:     null
              bSortable: true
              aTargets:  [0]
              mRender: (data, type, full) ->
                #console.log 'colrender1'
                #console.log arguments
                #return full.firstName
                return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].firstName">' + full.firstName + '</span>'
            ,
              mData:     null
              bSortable: true
              aTargets:  [1]
              mRender: (data, type, full) ->
                return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].lastName">' + full.lastName + '</span>'
            ,
              mData:     null
              bSortable: true
              aTargets:  [2]
              mRender: (data, type, full) ->
                return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].email">' + full.email + '</span>'
            ,
              mData:     null
              bSortable: true
              aTargets:  [3]
              mRender: (data, type, full) ->
                return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].phone">' + full.phone + '</span>'
            ,
              mData:     null
              bSortable: false
              aTargets:  [4]
              mRender: (data, type, full) ->
                return '' #<span data-ng-bind="resourcePool[\'' + full.uid + '\'].type">' + full.type + '</span>'
            ,
              mData:     null
              bSortable: false
              aTargets:  [5]
              mRender: (data, type, full) ->
                return ''
            ]

        $scope.viewModel = viewModel

    ]






    Module.controller 'ControllerWidgetScheduler', ['$scope', '$route', '$routeParams', 'apiRequest'
    ($scope, $route, $routeParams, apiRequest) ->

      viewModel =
        addNewEventForm: {}
        routeParams:     $routeParams
        eventListDT:
          detailRow: (obj) ->
            return ' - '
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
            sWidth:    '100px'
            mRender: (data, type, full) ->
              resHtml = '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].dateTime | date:\'short\'"></span>'
          ,
            mData:     null
            aTargets:  [2]
            bSortable: true
            sWidth:    '100px'
            mRender: (data, type, full) ->
              resHtml = '<span data-ng-bind="resourcePool[resourcePool[\'' + full.revisionUid + '\'].templateUid].type"></span>'
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
              query = utilBuildDTQuery ['name', 'dateTime'],
                ['name', 'dateTime'],
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

                  #Also fetch associated revisions & templates... (this is a pain in the ass)
                  revisionUids = []
                  for key, value of response.response.data
                    revisionUids.push value.revisionUid
                  revisionUids = _.uniq revisionUids

                  apiRequest.get 'revision', revisionUids, {}, (response) ->
                    if response.code == 200

                      templateUids = []
                      for key, value of response.response.data
                        templateUids.push value.revisionUid
                      templateUids = _.uniq templateUids

                      console.log templateUids
                      apiRequest.get 'template', templateUids, {}, (response) ->
                        return
                  #Fetched revisions & templates



        fullCalendarOptions:
          eventsResultCache: {}
          events: (start, end, callback) ->

            filter  = [['dateTime', '>', (new Date(start).toISOString()), 'and'], ['dateTime', '<', (new Date(end).toISOString())]]
            curDate = new Date()

            apiRequest.get 'event', [], {
              filter: filter
            }, (response) ->

              eventsArr = []
              if response.code == 200
                for key, eventObj of response.response.data
                  FCEventObj =
                    title: eventObj.name
                    start: new Date(eventObj.dateTime)
                    className: if (new Date(eventObj.dateTime) < curDate) then 'event pastEvent' else 'event upcomingEvent'
                  eventsArr.push FCEventObj

              if JSON.stringify(eventsArr) != $scope.viewModel.fullCalendarOptions.eventsResultCache
                $scope.viewModel.fullCalendarOptions.eventsResultCache = JSON.stringify(eventsArr)
                callback eventsArr





      hashChangeUpdate = () ->
        $scope.viewModel.routeParams = $routeParams
      $scope.$on '$routeChangeSuccess', () ->
        hashChangeUpdate()
      $scope.viewModel = viewModel

    ]
