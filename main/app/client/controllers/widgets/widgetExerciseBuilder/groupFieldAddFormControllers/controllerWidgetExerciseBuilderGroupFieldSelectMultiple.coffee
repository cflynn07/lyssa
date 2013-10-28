define [
  'app'
], (
  app
) ->

  app.controller 'ControllerWidgetExerciseBuilderGroupFieldSelectMultiple', [
    '$scope'
    'apiRequest'
    '$dialog'
    ($scope
      apiRequest
      $dialog) ->

      $scope.form = {}

      $scope.cancelAddNewField = () ->
        $scope.form = {}
        $scope.formSelectMultipleAdd.$setPristine()
        $scope.$parent.viewModel.cancelAddNewField()

  ]