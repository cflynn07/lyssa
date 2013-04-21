define [
  'jquery'
  'text!views/viewsDirectives/viewCollapseWidget.html'
], (
  $
  viewCollapseWidget
) ->

  (Module) ->

    Module.directive 'collapseWidget', () ->
      directive =
        restrict:   'A'
        transclude: true
        template:   viewCollapseWidget
        scope:
          title:        '@title'
          widgetThemis: '@widgetThemis'
          color:        '@color'
        replace: true
        compile: (element, attrs, transclusionFunc) ->
          (scope, iterStartElement, attrs) ->

            scope.collapsed = false
            scope.toggle = () ->
              scope.collapsed = !scope.collapsed

            origElem   = transclusionFunc scope
            content    = origElem.text()
            scope.orig = content
            #scope.obj = my_custom_parsing(content)
            scope.obj  = content
