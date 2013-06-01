define [
  'jquery'
  'angular'
  'ejs'
  'text!views/widgetQuiz/viewWidgetQuiz.html'
], (
  $
  angular
  EJS
  viewWidgetQuiz
) ->

  (Module) ->

    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewWidgetQuiz', viewWidgetQuiz
    ]

    Module.controller 'ControllerWidgetQuiz', ['$scope', '$route', '$routeParams', 'apiRequest'
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

            console.log '$scope.resourcePool[viewModel.routeParams.eventParticipantUid]'
            console.log $scope.resourcePool[viewModel.routeParams.eventParticipantUid]

            eP = $scope.resourcePool[viewModel.routeParams.eventParticipantUid]

            if _.isUndefined(eP) || _.isUndefined(eP.event.revision) || _.isUndefined(eP.event.revision.uid)
              return

            apiRequest.get 'revision', [eP.event.revision.uid], {
              expand: [{
                resource: 'groups'
                expand: [{
                  resource: 'items'
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
