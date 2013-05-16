define [
  'jquery'
  'angular'
  'ejs'
  'text!views/widgetQuiz/viewWidgetQuiz.html'
], (
  $
  angular
  EJS
  viewWidgetQuiz
) ->

  (Module) ->

    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewWidgetQuiz', viewWidgetQuiz
    ]

    Module.controller 'ControllerWidgetQuiz', ['$scope', '$route', '$routeParams', 'apiRequest'
    ($scope, $route, $routeParams, apiRequest) ->

    ]
