define [
  'app'
  'angular'
  'text!views/viewWidgetCoreFooter.html'
], (
  app
  angular
  viewWidgetCoreFooter
) ->

  app.run [
    '$templateCache'
    ($templateCache) ->
      $templateCache.put 'viewWidgetCoreFooter', viewWidgetCoreFooter
  ]

  app.controller 'ControllerWidgetCoreFooter', [
    '$scope'
    'authenticate'
    ($scope
      authenticate) ->

      $scope.logout = () ->
        authenticate.unauthenticate()

  ]
