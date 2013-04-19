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

    $templateCache.put 'viewWidgetBreadCrumbs', viewWidgetBreadCrumbs

    $scope.title    = 'Test Title'
    $scope.subtitle = 'Test Subtitle'
