define [
  'angular'
  'jquery'
  'soundmanager2'
  'text!views/viewWidgetCoreHeader.html'
], (
  angular
  $
  soundManager
  viewWidgetCoreHeader
) ->
  (Module) ->



    windowHasFocus = true
    $(window).bind 'blur', () ->
      windowHasFocus = false
      console.log windowHasFocus

    $(window).bind 'focus', () ->
      windowHasFocus = true
      console.log windowHasFocus

    #Temp Stub
    alertSound =
      play: () ->

    soundManager.url = window.location.protocol + '//' + window.location.host + '/assets/soundmanager2/soundmanager2.swf'
    soundManager.beginDelayedInit()
    soundManager.onready () ->
      alertSound = soundManager.createSound({
        id: 'alertSound'
        url: window.location.protocol + '//' + window.location.host + '/assets/gentleRoll.mp3'
        volume: '50'
        autoPlay: false
      })



    Module.run ['$templateCache',
    ($templateCache) ->
      $templateCache.put 'viewWidgetCoreHeader', viewWidgetCoreHeader
    ]

    Module.controller 'ControllerWidgetCoreHeader', ['$scope', '$rootScope', 'authenticate', 'apiRequest'
    ($scope, $rootScope, authenticate, apiRequest) ->

      $scope.$on 'resourcePost', (e, data) ->
        console.log 'rpost'
        console.log arguments
        alertSound.play()
        $.gritter.add
          title: 'something Added - ' + data.resourceName
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
