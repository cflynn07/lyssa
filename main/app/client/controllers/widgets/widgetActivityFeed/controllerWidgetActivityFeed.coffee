define [
  'angular'
  'text!views/widgetActivityFeed/viewWidgetActivityFeed.html'
], (
  angular
  viewWidgetActivityFeed
) ->
  (Module) ->

    Module.run ['$templateCache', ($templateCache) ->
      $templateCache.put 'viewWidgetActivityFeed', viewWidgetActivityFeed
    ]

    Module.controller 'ControllerWidgetActivityFeed', ['$scope', '$templateCache', 'socket', ($scope, $templateCache, socket) ->
      $scope.title    = 'Themis'
      $scope.subtitle = 'by Cobar Systems LLC'
    ]
