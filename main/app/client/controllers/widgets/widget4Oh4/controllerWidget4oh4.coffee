define [
  'angular'
  'text!views/widget4oh4/viewWidget4oh4.html'
], (
  angular
  viewWidget4oh4
) ->

  (Module) ->


    Module.run ($templateCache) ->
      $templateCache.put 'viewWidget4oh4', viewWidget4oh4


    Module.controller 'ControllerWidget4oh4', ($scope, $route) ->


      loadNewRoute = () ->
        return




      loadNewRoute()


      console.log $scope.rootUser
      console.log $route


      #once = false
      $scope.$on '$routeChangeSuccess', (event, current, previous) ->

        console.log 'route change success'
        console.log current
        console.log $scope.rootUser



        #if current && (current.redirectTo is not undefined)
        #  console.log '$routeChangeSuccess'

        #updateShit()





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
