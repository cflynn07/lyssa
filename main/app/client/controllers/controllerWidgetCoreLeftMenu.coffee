define [
  'jquery'
  'angular'
  'text!views/viewWidgetCoreLeftMenu.html'
], (
  $
  angular
  viewWidgetCoreLeftMenu
) ->

  (Module) ->

    Module.run ($templateCache) ->
      $templateCache.put 'viewWidgetCoreLeftMenu', viewWidgetCoreLeftMenu


    Module.controller 'ControllerWidgetCoreLeftMenu', ($scope, $route, $templateCache) ->


      $scope.menuChoices = [{
        hash: 'menu1a'
        title: 'Menu Option 1'
        sub: [{
          hash: 'menu1a'
          title: 'Menu Option 1'
        }]
      },{
        hash: 'menu2'
        title: 'Menu Option 2'
      },{
        hash: 'menu3'
        title: 'Menu Option 3'
      }]


      $scope.activeRoute = ''

      $scope.$on '$routeChangeSuccess', (scope, current, previous) ->

        return
        console.log current
        hash = window.location.hash



        $('.active').removeClass 'active'
        $('.open').removeClass('open')

        #First check if it's a sub menu
        $el = $('ul.sub a[href="' + hash + '"]')
        if $el.length > 0
          $el.parents('li').addClass 'active'
          $el = $el.parents('ul.sub')

          $el.parents('li.has-sub').addClass 'active'
          $el.parents('li.has-sub').find('span.arrow').addClass 'open'

          if !$el.is(':visible')
            $('ul.sub').hide()
            $el.slideDown 200
        else
          $el = $('#sidebar_top > li > a[href="' + hash + '"]')
          $el.parent().addClass 'active'
          $('ul.sub:visible').hide()
