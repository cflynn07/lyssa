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

    Module.controller 'ControllerWidgetQuizExerciseSubmitter', ['$scope', '$route', '$routeParams', 'apiRequest'
    ($scope, $route, $routeParams, apiRequest) ->

      viewModel =
        routeParams: $routeParams
        eventParticipant: {}
        getEventParticipant: () ->
          if !viewModel.routeParams.eventParticipantUid
            return

          apiRequest.get 'eventParticipant', [viewModel.routeParams.eventParticipantUid], {
            expand: [{
              resource: 'event'
              expand: [{
                resource: 'revision'
              }]
            }]
          }, (response) ->
            if response.code != 200
              return

            #console.log '$scope.resourcePool[viewModel.routeParams.eventParticipantUid]'
            #console.log $scope.resourcePool[viewModel.routeParams.eventParticipantUid]

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
              console.log 'revisionResponse'
              console.log revisionResponse

            #viewModel.eventParticipant = response.response.data

            #console.log 'eventParticipant'
            #console.log response



      viewModel.getEventParticipant()
      $scope.viewModel = viewModel


    ]
