define [
  'angular'
  'text!views/viewCoreWidgets.html'
], (
  angular
  viewCoreWidgets
) ->

  ($scope, $templateCache) ->
    $templateCache.put 'viewCoreWidgets', viewCoreWidgets


    $scope.widgetRows = [
      widget: 'viewWidgetBreadCrumbs'
    ,
      widget: 'viewWidgetBreadCrumbs'
    ,
      widget: 'viewWidgetBreadCrumbs'
    ]
