define [
  'angular'
  'underscore'
  'jquery'
  'cs!utils/utilSoundManager'
  'text!views/viewWidgetCoreHeader.html'
], (
  angular
  _
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

      $rootScope.rootActivityFeed   = {}
      fetchActivity = (completedCallback = null) ->
        apiRequest.get 'activity', [], {
          expand: [
            resource: 'employee'
          ,
            resource: 'template'
          ,
            resource: 'revision'
          ,
            resource: 'dictionary'
          ,
            resource: 'event'
            expand: [{
              resource: 'revision'
            },{
              resource: 'eventParticipants'
            #  expand: [{
            #    resource: 'employee'
            #  }]
            }]
          ]
        }, (response, rawResponse, fromCache) ->
          console.log 'zis is the act'
          console.log response
          if response.code == 200
            $rootScope.rootActivityFeed = response.response.data
          if _.isFunction(completedCallback) && (fromCache is false)
            completedCallback()

      gritterNotification = (data) ->
        utilSoundManager.alert.play()

        activityItem = $scope.resourcePool[data['resource'].uid]
        switch activityItem.type
          when 'createDictionary'
            $.gritter.add
              title: 'New Dictionary "' + activityItem.dictionary.name + '"'
              text:  'Created by ' + activityItem.employee.firstName + ' ' + activityItem.employee.lastName
          when 'createEmployee'
            $.gritter.add
              title: 'New Employee "' + activityItem.employee.firstName + ' ' + activityItem.employee.lastName + '"'
              #text:  'Created by ' + activityItem.employee.firstName + ' ' + activityItem.employee.lastName
          when 'createEvent'
            $.gritter.add
              title: 'New ' + (if activityItem.event.type == 'full' then 'exercise' else 'quiz') + ' "' + activityItem.event.name + '"'
              text:  'Created by ' + activityItem.employee.firstName + ' ' + activityItem.employee.lastName
          when 'eventInitialized'
            $.gritter.add
              title: (if activityItem.event.type == 'full' then 'Exercise' else 'Quiz') + ' "' + activityItem.event.name + '" initiated'
              text:  'Just now' #'Created by ' + activityItem.employee.firstName + ' ' + activityItem.employee.lastName

      $scope.$on 'resourcePost', (e, data) ->
        if data['resourceName'] != 'activity'
          return
        fetchActivity () ->
          gritterNotification data

      fetchActivity()

      $scope.toggleTopBarOpen = () ->
        console.log 'top'
        $rootScope.topBarOpen = !$rootScope.topBarOpen

      $scope.logout = () ->
        authenticate.unauthenticate()
    ]
