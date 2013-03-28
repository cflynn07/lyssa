define [
    'backbone'
], (
    Backbone
) ->

    Backbone.View.extend

        #Fetch data
        activate: () ->
            if this.onActivate
                this.onActivate()

        #Universal fade-in style for all widgets
        fadeWidgetIn: () ->


            _this = this
            num = 0
            timer = setInterval(() ->
                max = 4
                num = num + 1
                $el = _this.$el.find('.widget-themis')
                init_opacity = parseFloat $el.css 'opacity'

                if num > max
                  clearTimeout timer
                  return

                $el.css
                  'box-shadow': num + 'px ' + num + 'px 0 0'
                  top: (4 - num) + 'px'
                  left: (4 - num) + 'px'
                  opacity: init_opacity + ((1.0 - init_opacity) * (num / max))

            , 50);


        #Universal unbind & trigger widget specific actions
        deactivate: () ->
            this.unbind()
            this.remove()
            if this.onDeactivate
                this.onDeactivate()
