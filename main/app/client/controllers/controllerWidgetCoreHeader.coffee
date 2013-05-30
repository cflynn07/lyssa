define [
  'angular'
  'jquery'
  'cs!utils/utilSoundManager'
  'text!views/viewWidgetCoreHeader.html'
], (
  angular
  $
  utilSoundManager
  viewWidgetCoreHeader
) ->
  (Module) ->


    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewWidgetCoreHeader', viewWidgetCoreHeader
    ]

    Module.controller 'ControllerWidgetCoreHeader', ['$scope', '$rootScope', 'authenticate', 'apiRequest'
    ($scope, $rootScope, authenticate, apiRequest) ->

      $scope.$on 'resourcePost', (e, data) ->
        #console.log 'rpost'
        #console.log arguments
        utilSoundManager.alert.play()
        $.gritter.add
          title: 'Something Added - ' + data.resourceName
        #data
        # apiCollectionName
        # resource
        # resourceName


      $scope.$on 'resourcePut', (e, data) ->
        console.log 'rput'
        console.log arguments

      $scope.toggleTopBarOpen = () ->
        console.log 'top'
        $rootScope.topBarOpen = !$rootScope.topBarOpen

      $scope.logout = () ->
        authenticate.unauthenticate()
    ]
