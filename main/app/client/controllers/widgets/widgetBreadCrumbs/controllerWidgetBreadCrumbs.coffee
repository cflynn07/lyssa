define [
  'app'
  'text!views/widgetBreadCrumbs/viewWidgetBreadCrumbs.html'
  'text!views/widgetBreadCrumbs/viewNoBreadCrumbs.html'
], (
  app
  viewWidgetBreadCrumbs
  viewNoBreadCrumbs
) ->

  app.run [
    '$templateCache'
    ($templateCache) ->
      $templateCache.put 'viewWidgetBreadCrumbs', viewWidgetBreadCrumbs
      $templateCache.put 'viewNoBreadCrumbs',     viewNoBreadCrumbs
  ]

  app.controller 'ControllerWidgetBreadCrumbs', [
    '$scope'
    '$templateCache'
    'socket'
    ($scope
      $templateCache
      socket) ->

      $scope.title    = 'Themis'
      $scope.subtitle = 'by Cobar Systems LLC'

  ]
