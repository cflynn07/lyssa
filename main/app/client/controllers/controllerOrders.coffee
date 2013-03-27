define [
  'backbone'
  'cs!controllers/controllerCore'
  'cs!widgets/widgetBreadCrumbs'
  'cs!widgets/widgetMyOrders'
  'cs!widgets/widgetOrdersToShip'
], (
  Backbone
  ControllerCore
  WidgetBreadCrumbs
  WidgetMyOrders
  WidgetOrdersToShip
) ->

  ordersRouter = Backbone.Router.extend
    initialize: () ->
      console.log 'ordersRouter.initialize'
      this.bind 'all', this.change
    change: ->


    routes:
      'orders':                'index'
      'orders/my_orders':      'my_orders'
      'orders/orders_to_ship': 'orders_to_ship'
    index: ->
      console.log 'orders index'

    my_orders: ->
      console.log 'my_orders'

      ControllerCore.insert_page_widgets [
        view: WidgetBreadCrumbs
        data:
          title: 'My Orders'
          subtitle: 'view incoming orders'
      ,
        view: WidgetMyOrders
        data: {}
      ]

    orders_to_ship: ->
      console.log 'orders_to_ship'

      ControllerCore.insert_page_widgets [
        view: WidgetBreadCrumbs
        data:
          title: 'Orders to Ship'
          subtitle: 'view outgoing orders'
      ,
        view: WidgetOrdersToShip
        data: {}
      ]

  ordersRouterInstance = new ordersRouter()
