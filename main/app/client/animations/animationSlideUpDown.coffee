define [
  'jquery'
  'angular'
], (
  $
  angular
) ->

  (Module) ->

    Module.animation 'slide-up', ($rootScope) ->
      animation =
        setup: (element) ->
        start: (element, done) ->
          $(element).slideUp()
          done()

    Module.animation 'slide-down', ($rootScope) ->
      #console.log 'animationInit'
      animation =
        setup: (element) ->
          console.log 'startrun'
        start: (element, done, memo) ->
          $(element).slideDown()
          done()
          console.log 'animationrun'

