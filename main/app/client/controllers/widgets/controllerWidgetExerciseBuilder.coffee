define [
  'angular'
  #'bootstrap-tree'
  'text!views/widgetExerciseBuilder/viewWidgetExerciseBuilder.html'
], (
  angular
  #bootstrapTree
  viewWidgetExerciseBuilder
) ->
  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetExerciseBuilder', viewWidgetExerciseBuilder

    Module.controller 'ControllerWidgetExerciseBuilder', ($scope, $templateCache, socket) ->

      $scope.collapsed = false
      $scope.reload = () ->
      $scope.toggle = () ->
        $scope.collapsed = !$scope.collapsed


      $scope.exercises = {"code":200,"response":[{"uid":"ccb2a09e-7bc8-448d-ab9c-2011004a72c6","name":"Maric","type":"full","clientUid":"44cc27a5-af8b-412f-855a-57c8205d86f5","employeeUid":"04ad5b05-c9a5-430f-8d5c-8483d5d904e4","createdAt":"2013-04-10T22:20:50.000Z","updatedAt":"2013-04-10T22:20:53.000Z","deletedAt":null,"revisions":[{"uid":"edf9847e-9c18-46b8-a673-1d266a73cab4","changeSummary":"This is a change summary","scope":"This is a scope","clientUid":"44cc27a5-af8b-412f-855a-57c8205d86f5","templateUid":"ccb2a09e-7bc8-448d-ab9c-2011004a72c6","employeeUid":"45b7c719-2049-4a44-ad9c-09e858afc48b","createdAt":"2013-04-13T19:50:42.000Z","updatedAt":"2013-04-13T19:50:44.000Z","deletedAt":null}]},{"uid":"9e5a299b-eea3-46c6-a021-1fa404522e00","name":"dupertemplate","type":"mini","clientUid":"05817084-bc15-4dee-90a1-2e0735a242e1","employeeUid":"0054d814-6d36-4573-bbfc-a2b6644266cc","createdAt":"2013-04-10T22:22:13.000Z","updatedAt":"2013-04-10T22:22:15.000Z","deletedAt":null,"revisions":[{"uid":"dad1065c-91cf-4796-8f8b-74edfc06f2db","changeSummary":"We make lots of changes","scope":null,"clientUid":"05817084-bc15-4dee-90a1-2e0735a242e1","templateUid":"9e5a299b-eea3-46c6-a021-1fa404522e00","employeeUid":"f755b54f-e918-4fcb-9024-2b48370df4a1","createdAt":"2013-04-13T19:51:49.000Z","updatedAt":"2013-04-13T19:51:51.000Z","deletedAt":null}]},{"uid":"7977ab52-cd42-4011-a4a2-6f16d3f73bae","name":"newtestobject","type":"mini","clientUid":"44cc27a5-af8b-412f-855a-57c8205d86f5","employeeUid":"45b7c719-2049-4a44-ad9c-09e858afc48b","createdAt":"2013-04-16T04:08:54.000Z","updatedAt":"2013-04-16T04:08:54.000Z","deletedAt":null,"revisions":[]}]}
      $scope.exercises = $scope.exercises.response
