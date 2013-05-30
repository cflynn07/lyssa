define [
  'angular'
  'text!views/widgetActivityFeed/viewWidgetActivityFeed.html'
], (
  angular
  viewWidgetActivityFeed
) ->
  (Module) ->

    Module.run ['$templateCache', ($templateCache) ->-
      $templateCache.put 'viewWidgetActivityFeed', viewWidgetActivityFeed
    ]

    Module.controller 'ControllerWidgetActivityFeed', ['$scope', '$templateCache', 'socket', 'apiRequest', ($scope, $templateCache, socket, apiRequest) ->
      $scope.title    = 'Themis'
      $scope.subtitle = 'by Cobar Systems LLC'

      apiRequest.get 'activity', [], {}, (response) ->
        console.log 'response'
        console.log response
        $scope.activities = response.response.data


    ]
