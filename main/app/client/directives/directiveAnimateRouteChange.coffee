define [
  'jquery'
], (
  $
) ->
  (Module) ->

    Module.directive 'animateRouteChange', () ->
      (scope, element, attrs) ->

        #scope.$on '$routeChangeSuccess', (event, current, previous) ->
        #  if element.hasClass 'active'
        #    element.find('ul.sub').hide().slideDown()
