define [
  'backbone'
  'cs!models/user'
  'cs!controllers/controllerCore'
  'cs!widgets/widgetBreadCrumbs'
  'cs!widgets/widgetSuperAdminClients'
], (
  Backbone
  User
  ControllerCore
  WidgetBreadCrumbs
  WidgetSuperAdminClients
) ->

  superAdminRouter = Backbone.Router.extend
    initialize: () ->
      console.log 'superAdminRouter.initialize'
      this.bind 'all', this.change
    change: ->

      #console.log 'change'
      #console.log arguments

    routes:
      'super_admin*splat':          'index'
    index: ->

      if !User.get 'super_admin'
        return false

      console.log 'admin index'
      ControllerCore.insert_page_widgets [
        view: WidgetBreadCrumbs
        data:
          title: 'Super Admin'
          subtitle: 'do anything you want'
      ,
        view: WidgetSuperAdminClients
        data: {}
      ]


  new superAdminRouter()
