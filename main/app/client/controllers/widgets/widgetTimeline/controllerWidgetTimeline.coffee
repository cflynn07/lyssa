define [
  'jquery'
  'underscore'
  'cs!utils/utilBuildDTQuery'
  'text!views/widgetTimeline/viewWidgetTimeline.html'
], (
  $
  _
  utilBuildDTQuery
  viewWidgetTimeline
) ->

  (Module) ->

    Module.run ['$templateCache', ($templateCache) ->
      $templateCache.put 'viewWidgetTimeline', viewWidgetTimeline
    ]

    Module.controller 'ControllerWidgetTimeline', ['$scope', '$templateCache', 'socket', 'apiRequest', ($scope, $templateCache, socket, apiRequest) ->

      viewModel =
        eventListDT:
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
              #return
              query = utilBuildDTQuery ['name', 'dateTime'],
                ['name', 'dateTime'],
                oSettings

              query.expand = [{resource: 'eventParticipants', expand: [{resource: 'employee'}]}]

              cacheResponse   = ''
              oSettings.jqXHR = apiRequest.get 'event', [], query, (response, responseRaw) ->
                if response.code != 200
                  return

                if cacheResponse == responseRaw
                  return
                cacheResponse = responseRaw

                empArr = _.toArray response.response.data

                fnCallback
                  iTotalRecords:        response.response.length
                  iTotalDisplayRecords: response.response.length
                  aaData:               empArr
          fnRowCallback: (nRow, aData, iDisplayIndex) ->
            nowDate   = (new Date()).getTime()
            eventDate = (new Date(aData.dateTime)).getTime()

            if nowDate > eventDate
              $(nRow).addClass 'pastEvent'
            else
              $(nRow).addClass 'upcomingEvent'

          columnDefs: [
              mData:     null
              bSortable: true
              aTargets:  [0]
              mRender: (data, type, full) ->
                #console.log 'colrender1'
                #console.log arguments
                #return full.firstName
                return '<span data-ng-bind="resourcePool[\'' + full.uid + '\'].name">' + full.name + '</span>'
            ,
              mData:     null
              bSortable: true
              aTargets:  [1]
              mRender: (data, type, full) ->
                return '<span>{{ resourcePool[\'' + full.uid + '\'].dateTime | date:\'short\' }}</span><br><span>({{ resourcePool[\'' + full.uid + '\'].dateTime | fromNow }})</span>'
            ,
              mData:     null
              bSortable: true
              aTargets:  [2]
              mRender: (data, type, full) ->
                return '<span>{{ (resourcePool[\'' + full.uid + '\'].eventParticipants | toArray).length }}</span>'
            ]


      $scope.viewModel = viewModel

    ]