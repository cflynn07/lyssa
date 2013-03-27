define [
  'backbone'
  'jquery'
  'cs!models/user'
  'hbs!views/widgets/widgetCoreFooter/viewWidgetCoreFooter'
], (
  Backbone
  $
  User
  ViewWidgetCoreFooter
) ->

  Backbone.View.extend
    className: 'footer'
    initialize: ->
    render: ->

      this.el.innerHTML = ViewWidgetCoreFooter()
      return this

    close: ->

      console.log 'WidgetCoreFooter.close()'
      this.unbind()
      this.remove()
    events:
      'click span.go-top': 'click_go_top'
    click_go_top: ->
      $('body').animate scrollTop: 0