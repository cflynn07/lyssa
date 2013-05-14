define [
  'angular'
  'text!views/widget4oh4/viewWidget4oh4.html'
], (
  angular
  viewWidget4oh4
) ->

  (Module) ->


    Module.run ['$templateCache', ($templateCache) ->
      $templateCache.put 'viewWidget4oh4', viewWidget4oh4
    ]

    Module.controller 'ControllerWidget4oh4', ['$scope', '$route', ($scope, $route) ->

      loadNewRoute = () ->
        return

      loadNewRoute()

      #once = false
      $scope.$on '$routeChangeSuccess', (event, current, previous) ->

      updateShit = () ->
        $scope.widgetRows = [
          widget: 'viewWidgetBreadCrumbs'
        ,
          widget: 'viewWidgetFullExerciseSubmitter'
        ,
          widget: 'viewWidgetScheduler'
        ,
          widget: 'viewWidgetDictionaryManager'
        ,
          widget: 'viewWidgetExerciseBuilder'
        ]
      updateShit()

    ]
