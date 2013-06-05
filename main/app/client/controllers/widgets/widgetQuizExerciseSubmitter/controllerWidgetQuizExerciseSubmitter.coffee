define [
  'jquery'
  'angular'
  'ejs'
  'text!views/widgetQuizExerciseSubmitter/viewWidgetQuizExerciseSubmitter.html'
], (
  $
  angular
  EJS
  viewWidgetQuizExerciseSubmitter
) ->

  (Module) ->

    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewWidgetQuizExerciseSubmitter',
        viewWidgetQuizExerciseSubmitter
    ]

    Module.controller 'ControllerWidgetQuizExerciseSubmitter', ['$scope', '$route', '$routeParams', 'apiRequest', '$filter'
    ($scope, $route, $routeParams, apiRequest, $filter) ->

      viewModel =

        routeParams:         $routeParams
        eventParticipant:    {}

        revision:            {}
        #Gets set to first group after load, incremented with steps
        activeRevisionGroup: ''
        setActiveRevisionGroup: (groupUid) ->
          if viewModel.activeRevisionGroup is ''

            groupsArray = $filter('deleted')(viewModel.revision.groups)
            groupsArray = $filter('orderBy')(groupsArray, 'ordinal')

            if groupsArray.length
              viewModel.activeRevisionGroup = groupsArray[0].uid


        getEventParticipant: () ->
          if !viewModel.routeParams.eventParticipantUid
            return

          apiRequest.get 'eventParticipant', [viewModel.routeParams.eventParticipantUid], {
            expand: [{
              resource: 'event'
              expand: [{
                resource: 'employee'
              },{
                resource: 'revision'
              }]
            }]
          }, (response) ->
            console.log response
            if response.code != 200
              return

            eP = $scope.resourcePool[viewModel.routeParams.eventParticipantUid]
            if _.isUndefined(eP) || _.isUndefined(eP.event.revision) || _.isUndefined(eP.event.revision.uid)
              return

            apiRequest.get 'revision', [eP.event.revision.uid], {
              expand: [{
                resource: 'groups'
                expand: [{
                  resource: 'fields'
                }]
              }]
            }, (revisionResponse) ->
              if revisionResponse.code != 200
                return

              for key, value of revisionResponse.response.data
                viewModel.revision = value
                break

              viewModel.setActiveRevisionGroup()

              #console.log 'viewModel.revision'
              #console.log viewModel.revision


      viewModel.getEventParticipant()
      $scope.viewModel = viewModel

    ]
