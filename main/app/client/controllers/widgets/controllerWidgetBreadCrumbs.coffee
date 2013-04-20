define [
  'angular'
  'text!views/widgetBreadCrumbs/viewWidgetBreadCrumbs.html'
], (
  angular
  viewWidgetBreadCrumbs
) ->

  console.log 'viewWidgetBreadCrumbs'
  console.log viewWidgetBreadCrumbs

  ($scope, $templateCache) ->

    console.log 'controller WidgetBreadCrumbs'

    $templateCache.put 'viewWidgetBreadCrumbs', viewWidgetBreadCrumbs

    $scope.title    = 'Test Title'
    $scope.subtitle = 'Test Subtitle'
