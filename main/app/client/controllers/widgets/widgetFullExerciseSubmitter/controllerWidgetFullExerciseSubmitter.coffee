define [
  'angular'
  'text!views/widgetFullExerciseSubmitter/viewWidgetFullExerciseSubmitter.html'
  'text!views/widgetFullExerciseSubmitter/partials/widgetPartialExerciseSubmitterOverview.html'
  'text!views/widgetFullExerciseSubmitter/partials/widgetPartialExerciseSubmitterExercise.html'
], (
  angular
  viewWidgetFullExerciseSubmitter
  widgetPartialExerciseSubmitterOverview
  widgetPartialExerciseSubmitterExercise
) ->

  (Module) ->

    Module.run ['$templateCache',
      ($templateCache) ->
        $templateCache.put 'viewWidgetFullExerciseSubmitter',
          viewWidgetFullExerciseSubmitter
        $templateCache.put 'widgetPartialExerciseSubmitterOverview',
          widgetPartialExerciseSubmitterOverview
        $templateCache.put 'widgetPartialExerciseSubmitterExercise',
          widgetPartialExerciseSubmitterExercise
    ]

    ###
    Overview of all exercises
    ###
    Module.controller 'ControllerWidgetFullExerciseSubmitterOverview', ['$scope', '$route', '$routeParams',
      ($scope, $route, $routeParams) ->
        $scope.test = 'foo123'
    ]

    ###
    Submit a specific exercise
    ###
    Module.controller 'ControllerWidgetFullExerciseSubmitterExercise', ['$scope', '$route',
      ($scope, $route) ->
        $scope.test = 'foo'
    ]

    ###
    Parent controller
    ###
    Module.controller 'ControllerWidgetFullExerciseSubmitter', ['$scope', '$route',
      ($scope, $route) ->
        $scope.test = 'foo'
    ]
