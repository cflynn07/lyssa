define [
  'cs!models/user'
  'backbone'
  'cs!components/conn'
  'hbs!views/widgets/widgetBreadCrumbs/viewWidgetBreadCrumbs'
], (
  User
  Backbone
  conn
  ViewWidgetBreadCrumbs
) ->

  Backbone.View.extend
    initialize: ->
    render: ->

      this.$el.html ViewWidgetBreadCrumbs this.options

      return this
    events: {}
    close: ->
      console.log 'WidgetBreakCrumbs.close()'
      this.unbind()
      this.remove()
