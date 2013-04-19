define [
  'cs!components/conn'
  'backbone'
  'cs!controllers/controllerCore'
  'cs!widgets/widgetBreadCrumbs'
  'cs!widgets/widgetProfileUpdate'
], (
  conn
  Backbone
  ControllerCore
  WidgetBreadCrumbs
  WidgetProfileUpdate
) ->

  profileRouter = Backbone.Router.extend
    initialize: () ->
      console.log 'profileRouter.initialize'

    routes:
      'profile/update*splat':          'index'
    index: ->
      console.log 'profile/update index'
      ControllerCore.insert_page_widgets [
        view: WidgetBreadCrumbs
        data:
          title: 'Profile'
          subtitle: 'update your profile settings'
      ,
        view: WidgetProfileUpdate
        data: {}
      ]


  new profileRouter()
