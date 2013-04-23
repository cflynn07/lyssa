define [
  'jquery'
  'angular'
], (
  $
  angular
) ->

  (Module) ->

    Module.animation 'fade-out', ($rootScope) ->
      animation =
        setup: (element) ->
          #element.css display: 'none'
        start: (element, done) ->
          element.fadeOut 'fast', () ->
            done()

    Module.animation 'fade-in', ($rootScope) ->
      #console.log 'animationInit'
      animation =
        setup: (element) ->
          element.css display: 'none'
        start: (element, done, memo) ->
          element.fadeIn 'fast', () ->
            done()

