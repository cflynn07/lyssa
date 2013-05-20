define [
  'jquery'
  'jquery-ui'
  'underscore'
], (
  $
  jqueryUi
  _
) ->

  (Module) ->

    Module.directive 'calendar', () ->
      directive =
        restrict: 'A'
        template: '<div class="calendar"></div>'
        scope:
          options: '=options'
          refetchOnPost: '@refetchOnPost'
          refetchOnPut:  '@refetchOnPut'
        link: ($scope, element, attrs) ->

          calendarElem = element.find('.calendar')
          calendarElem.fullCalendar $scope.options


          #Listen for events to refetch events
          $scope.$on 'resourcePost', (e, data) ->
            if data['resourceName'] == $scope.refetchOnPost
              calendarElem.fullCalendar 'refetchEvents'
          $scope.$on 'resourcePut', (e, data) ->
            if data['resourceName'] == $scope.refetchOnPut
              calendarElem.fullCalendar 'refetchEvents'
