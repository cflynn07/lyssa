define [], () ->

  (Module) ->

    Module.directive 'animateIn', () ->
      (scope, element, attrs) ->

        loadingHTML = "<div class=\"loading-indicator\">
          <div class=\"progress progress-striped active\">
            <div style=\"width: 100%;\" class=\"bar\"></div>
          </div>
        </div>"
        element.find('> .portlet-body').prepend loadingHTML


        setTimeout(() ->
          num = 0
          $el = element

          timer = setInterval(() ->
            max = 4
            num = num + 1
            $el = element
            init_opacity = 0.4 #parseFloat $el.css 'opacity'

            if num > max
              setTimeout(() ->
                $el.find('.loading-indicator').remove()
              , 200)
              clearTimeout timer
              return

            #$el.find('#loadingIndicator').css
            #  opacity: 1.0 - (num / max)

            $el.css
              'border-right': '0px !important'
              'box-shadow': num + 'px ' + num + 'px 0 0 rgba(0,0,0,0.35)'
              top: (4 - num) + 'px'
              left: (4 - num) + 'px'
              opacity: init_opacity + ((1.0 - init_opacity) * (num / max))
          , 50)
        , 800)


        #element.bind '$destroy', () ->
        #  clearTimeout timer
