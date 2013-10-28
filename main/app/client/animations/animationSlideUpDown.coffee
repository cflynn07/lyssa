define [
  'app'
  'jquery'
], (
  app
  $
) ->

  app.animation 'slide-up', ['$rootScope', ($rootScope) ->
    animation =
      setup: (element) ->
        #element.css display: 'none'
      start: (element, done) ->
        element.slideUp 'normal', () ->
          done()
  ]

  app.animation 'slide-down', ['$rootScope', ($rootScope) ->
    #console.log 'animationInit'
    animation =
      setup: (element) ->
        element.css display: 'none'
      start: (element, done, memo) ->
        element.slideDown 'normal', () ->
          done()
  ]