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
        getEventParticipant: () ->
          if !viewModel.routeParams.eventParticipantUid
            return
          apiRequest.get 'eventParticipant', [viewModel.routeParams.eventParticipantUid], {
            expand: [{
              resource: 'event'
            }]
          }, (response) ->
            console.log 'eventParticipant'
            console.log response

      viewModel.getEventParticipant()

      $scope.viewModel = viewModel

    ]
