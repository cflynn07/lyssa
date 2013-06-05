define [
  'jquery'
  'angular'
  'ejs'
  'text!views/widgetQuizExerciseSubmitter/viewWidgetQuizExerciseSubmitter.html'
  'text!views/widgetQuizExerciseSubmitter/partials/viewPartialQuizExerciseSubmitterOpenResponse.html'
  'text!views/widgetQuizExerciseSubmitter/partials/viewPartialQuizExerciseSubmitterSelectIndividual.html'
  'text!views/widgetQuizExerciseSubmitter/partials/viewPartialQuizExerciseSubmitterSelectMultiple.html'
  'text!views/widgetQuizExerciseSubmitter/partials/viewPartialQuizExerciseSubmitterYesNo.html'
  'text!views/widgetQuizExerciseSubmitter/partials/viewPartialQuizExerciseSubmitterSlider.html'
], (
  $
  angular
  EJS
  viewWidgetQuizExerciseSubmitter
  viewPartialQuizExerciseSubmitterOpenResponse
  viewPartialQuizExerciseSubmitterSelectIndividual
  viewPartialQuizExerciseSubmitterSelectMultiple
  viewPartialQuizExerciseSubmitterYesNo
  viewPartialQuizExerciseSubmitterSlider
) ->

  (Module) ->

    Module.run ['$templateCache',
    ($templateCache) ->

      $templateCache.put 'viewWidgetQuizExerciseSubmitter',
        viewWidgetQuizExerciseSubmitter

      $templateCache.put 'viewPartialQuizExerciseSubmitterOpenResponse',
        viewPartialQuizExerciseSubmitterOpenResponse

      $templateCache.put 'viewPartialQuizExerciseSubmitterSelectIndividual',
        viewPartialQuizExerciseSubmitterSelectIndividual

      $templateCache.put 'viewPartialQuizExerciseSubmitterSelectMultiple',
        viewPartialQuizExerciseSubmitterSelectMultiple

      $templateCache.put 'viewPartialQuizExerciseSubmitterYesNo',
        viewPartialQuizExerciseSubmitterYesNo

      $templateCache.put 'viewPartialQuizExerciseSubmitterSlider',
        viewPartialQuizExerciseSubmitterSlider

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
