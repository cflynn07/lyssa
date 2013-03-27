define [
  'backbone'
  'cs!controllers/controllerCore'
  'cs!widgets/widgetBreadCrumbs'
  'cs!widgets/widgetAdminUsers'
], (
  Backbone
  ControllerCore
  WidgetBreadCrumbs
  WidgetAdminUsers
) ->

  


  adminRouter = Backbone.Router.extend
    initialize: () ->
      console.log 'adminRouter.initialize'
      this.bind 'all', this.change
    change: ->

      console.log 'change'
      console.log arguments

    routes:
      'admin*splat':          'index'
    index: ->
      console.log 'admin index'
      ControllerCore.insert_page_widgets [
        view: WidgetBreadCrumbs
        data:
          title: 'Admin'
          subtitle: 'view user permissions'
      ,
        view: WidgetAdminUsers
        data: {}
      ]


  new adminRouter()
