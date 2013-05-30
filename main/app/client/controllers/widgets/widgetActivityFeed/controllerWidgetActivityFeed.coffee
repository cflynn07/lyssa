define [
  'angular'
  'jquery'
  'text!views/widgetActivityFeed/viewWidgetActivityFeed.html'
  'text!views/widgetActivityFeed/partials/viewPartialActivityFeedCreateDictionary.html'
  'text!views/widgetActivityFeed/partials/viewPartialActivityFeedCreateEmployee.html'
], (
  angular
  $
  viewWidgetActivityFeed
  viewPartialActivityFeedCreateDictionary
  viewPartialActivityFeedCreateEmployee
) ->
  (Module) ->

    Module.run ['$templateCache', ($templateCache) ->

      $templateCache.put 'viewWidgetActivityFeed',
        viewWidgetActivityFeed
      $templateCache.put 'viewPartialActivityFeedCreateDictionary',
        viewPartialActivityFeedCreateDictionary
      $templateCache.put 'viewPartialActivityFeedCreateEmployee',
        viewPartialActivityFeedCreateEmployee

    ]

    Module.controller 'ControllerWidgetActivityFeed', ['$scope', '$templateCache', 'socket', 'apiRequest', ($scope, $templateCache, socket, apiRequest) ->
      $scope.title    = 'Themis'
      $scope.subtitle = 'by Cobar Systems LLC'


    ]
