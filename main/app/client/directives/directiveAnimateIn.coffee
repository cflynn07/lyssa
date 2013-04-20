define [], () ->

  (Module) ->

    Module.directive 'animateIn', () ->
      (scope, element, attrs) ->

        num = 0
        $el = element

        timer = setInterval(() ->
          max = 4
          num = num + 1
          $el = element
          init_opacity = 0.4 #parseFloat $el.css 'opacity'

          if num > max
            clearTimeout timer
            return

          $el.css
            'box-shadow': num + 'px ' + num + 'px 0 0 rgba(0,0,0,0.35)'
            top: (4 - num) + 'px'
            left: (4 - num) + 'px'
            opacity: init_opacity + ((1.0 - init_opacity) * (num / max))
        ,50)


        element.bind '$destroy', () ->
          clearTimeout timer
