define [
  'jquery'
  'angular'
  'ejs'
  'cs!utils/utilBuildDTQuery'
  'cs!utils/utilParseClientTimeZone'
  'underscore'

  'text!views/widgetScheduler/viewWidgetScheduler.html'
  'text!views/widgetScheduler/viewWidgetSchedulerListButtonsEJS.html'
  'text!views/widgetScheduler/viewPartialSchedulerAddExerciseForm.html'
], (
  $
  angular
  EJS
  utilBuildDTQuery
  utilParseClientTimeZone
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
          clientTimeZone:   utilParseClientTimeZone()
          newEventForm:     {}
          activeWizardStep: 0

          isStepValid: (step = false) ->
            if !$scope.newEventForm
              return false
            form = $scope.newEventForm
            if step is false
              step = viewModel.activeWizardStep
            step0Valid = (form.eventType.$valid && form.name.$valid && form.description.$valid && form.date.$valid)
            step1Valid = (form.templateUid.$valid && form.revisionUid.$valid)
            step2Valid = true
            switch step
              when 2
                result = step0Valid && step1Valid && step2Valid
              when 1
                result = step0Valid && step1Valid
              when 0
                result = step0Valid
            return result

          addEmployeeToEvent: (employeeUid) ->
            console.log arguments
            console.log $scope.viewModel.newEventForm

            if !_.isArray(viewModel.newEventForm.employeeUids)
              viewModel.newEventForm.employeeUids = []

            if viewModel.newEventForm.employeeUids.indexOf(employeeUid) == -1
              viewModel.newEventForm.employeeUids.push employeeUid


          templatesListDataTable:
            columnDefs: [
              mData:     null
              aTargets:  [0]
              bSortable: true
              mRender: (data, type, full) ->
                resHtml = '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].name"></span>'
            ,
              mData:     null
              aTargets:  [1]
              bSortable: true
              sWidth:    '45px'
              mRender: (data, type, full) ->
                resHtml = _.str.capitalize(full.type)
            ,
              mData:     null
              aTargets:  [2]
              bSortable: false
              sWidth: '70px'
              mRender: (data, type, full) ->
                html  = '<div class="inline-content">'
                html += '<button class="btn blue" data-ng-click="$parent.viewModel.newEventForm.templateUid = \'' + full.uid + '\'; $parent.newEventForm.templateUid.$pristine = false;">Select</button>'
                html += '</div>'
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

                if _.isUndefined($scope.viewModel.newEventForm) || _.isUndefined($scope.viewModel.newEventForm.eventType)
                  return

                console.log $scope.viewModel.newEventForm
                console.log 'p1'

                query.filter.push ['deletedAt', '=', 'null', 'and']
                query.filter.push ['type',      '=', $scope.viewModel.newEventForm.eventType,   'and']

                query.expand = [{
                  resource: 'revisions'
                }]

                cacheResponse   = ''
                oSettings.jqXHR = apiRequest.get 'template', [], query, (response) ->
                  console.log 'response'
                  console.log response

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



          revisionsListDataTable:
            columnDefs: [
              mData:     null
              aTargets:  [0]
              bSortable: true
              mRender: (data, type, full) ->
                resHtml  = '<span data-ng-bind="resourcePool[resourcePool[\'' + full.uid + '\'].employee.uid].firstName"></span> '
                resHtml += '<span data-ng-bind="resourcePool[resourcePool[\'' + full.uid + '\'].employee.uid].lastName"></span>'
            ,
              mData:     null
              aTargets:  [1]
              bSortable: true
              mRender: (data, type, full) ->
                resHtml = '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].createdAt | date:\'short\'"></span>'
            ,
              mData:     null
              aTargets:  [2]
              bSortable: true
              mRender: (data, type, full) ->
                resHtml = '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].changeSummary"></span>'
            ,
              mData:     null
              aTargets:  [3]
              bSortable: false
              mRender: (data, type, full) ->
                html  = '<div class="inline-content">'
                html += '<button class="btn blue" data-ng-click="$parent.viewModel.newEventForm.revisionUid = \'' + full.uid + '\'; $parent.newEventForm.revisionUid.$pristine = false;">Select</button>'
                html += '</div>'
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
                query = utilBuildDTQuery [],
                  [],
                  oSettings

                if _.isUndefined($scope.viewModel.newEventForm) || _.isUndefined($scope.viewModel.newEventForm.templateUid)
                  return

                query.filter.push ['deletedAt',   '=', 'null', 'and']
                query.filter.push ['templateUid', '=', $scope.viewModel.newEventForm.templateUid, 'and']
                query.expand = [{resource: 'template'}, {resource: 'employee'}]

                cacheResponse   = ''
                oSettings.jqXHR = apiRequest.get 'revision', [], query, (response) ->

                  console.log 'response'
                  console.log response

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



          employeeListDT:
            options:
              bProcessing:  true
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
                return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].phone | tel ">' + full.phone + '</span>'
            ,
              mData:     null
              bSortable: false
              aTargets:  [4]
              mRender: (data, type, full) ->
                return '' #<span data-ng-bind="resourcePool[\'' + full.uid + '\'].type">' + full.type + '</span>'
            ,
              mData:     null
              bSortable: false
              sWidth: '70px'
              aTargets:  [5]
              mRender: (data, type, full) ->
                html  = '<div class="inline-content">'
                html += '<button class="btn blue" data-ng-disabled="($parent.viewModel.newEventForm.employeeUids.length && $parent.viewModel.newEventForm.employeeUids.indexOf(\'' + full.uid + '\') != -1)" data-ng-click="$parent.viewModel.addEmployeeToEvent(\'' + full.uid + '\'); $parent.newEventForm.employeeUids.$pristine = false;">'
                html += '<span style="color:#FFF !important;" data-ng-hide="($parent.viewModel.newEventForm.employeeUids.length && $parent.viewModel.newEventForm.employeeUids.indexOf(\'' + full.uid + '\') != -1)">Select</span>'
                html += '<span style="color:#FFF !important;" data-ng-show="($parent.viewModel.newEventForm.employeeUids.length && $parent.viewModel.newEventForm.employeeUids.indexOf(\'' + full.uid + '\') != -1)">Selected</span>'
                html += '</button>'
                html += '</div>'
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
              resHtml = '<span data-ng-bind="resourcePool[resourcePool[\'' + full.revisionUid + '\'].templateUid].name"></span>'
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
              query.expand = [{resource: 'revision', expand:[{resource: 'template'}]}]

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








        fullCalendarOptions:
          eventsResultCache: {}
          events: (start, end, callback) ->

            filter  = [['dateTime', '>', (new Date(start).toISOString()), 'and'], ['dateTime', '<', (new Date(end).toISOString())]]
            curDate = new Date()

            apiRequest.get 'event', [], {
              filter: filter
            }, (response) ->
              console.log response

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

        fullCalendarOptionsSecondary:
          eventsResultCache: {}
          events: (start, end, callback) ->

            filter  = [['dateTime', '>', (new Date(start).toISOString()), 'and'], ['dateTime', '<', (new Date(end).toISOString())]]
            curDate = new Date()

            apiRequest.get 'event', [], {
              filter: filter
            }, (response) ->
              #console.log response

              eventsArr = []
              if response.code == 200
                for key, eventObj of response.response.data
                  FCEventObj =
                    title: eventObj.name
                    start: new Date(eventObj.dateTime)
                    className: if (new Date(eventObj.dateTime) < curDate) then 'event pastEvent' else 'event upcomingEvent'
                  eventsArr.push FCEventObj

              if JSON.stringify(eventsArr) != $scope.viewModel.fullCalendarOptionsSecondary.eventsResultCache
                $scope.viewModel.fullCalendarOptionsSecondary.eventsResultCache = JSON.stringify(eventsArr)
                callback eventsArr










      hashChangeUpdate = () ->
        $scope.viewModel.routeParams = $routeParams
      $scope.$on '$routeChangeSuccess', () ->
        hashChangeUpdate()
      $scope.viewModel = viewModel

    ]
