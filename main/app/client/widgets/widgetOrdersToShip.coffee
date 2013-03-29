define [
  'cs!widgets/abstract/widgetAbstract'
  'cs!components/orderStatuses'
  'backbone'
  'jquery'
  'datatables'
  'cs!models/user'
  'cs!components/conn'
  'hbs!views/widgets/widgetOrdersToShip/viewWidgetOrdersToShip'
  'cs!widgets/widgetOrderDetail'
], (
  WidgetAbstract
  orderStatuses
  Backbone
  $
  $dt
  User
  Conn
  ViewWidgetOrdersToShip
  WidgetOrderDetail
) ->

  WidgetAbstract.extend
  #Backbone.View.extend
    dataTableOpenRows: []
    dataTable: null
    initialize: ->

      _this = this
      #setTimeout (->
      #  _this.update()
      #), 1500

      Conn.io.emit 'orders:retrieveOrdersToShip', {}, (response) ->
        console.log response
        if response.success
          _this.update response.OrdersToShip
          _this.fadeWidgetIn()

    close: ->
      this.unbind()
      this.remove()
    update: (OrdersToShip)->

      this.el.innerHTML = ViewWidgetOrdersToShip
        orders: OrdersToShip
        statuses: orderStatuses

      this.dataTable = this.$el.find('table').dataTable()

      this.$el.hide().fadeIn 'fast'

    render: ->

      return this

    events:
      'change select': 'change_select'
      'click *[data-action]': 'click_data_action'
    click_data_action: (e) ->
      e.preventDefault()
      $el = $ e.currentTarget
      action = $el.attr 'data-action'



      switch action
        when 'view-order-detail'
          tr = $(e.currentTarget).parents('tr').get(0)
          i = $.inArray tr, this.dataTableOpenRows



          _this = this

          renda = () ->

            order_id = $el.attr 'data-order_id'
            status   = $el.parents('tr').find('select option:selected').val()

            if i is -1
              w = new WidgetOrderDetail({order_id: order_id, status: status})
              _this.dataTable.fnOpen tr, w.el, 'details'
              _this.dataTableOpenRows.push tr
            else
              _this.dataTable.fnClose tr
              _this.dataTableOpenRows.splice i, 1

          $el.parents('tr').find('select').unbind('change')
          $el.parents('tr').find('select').bind('change', (() ->
            renda()
          ))
          renda()






    change_select: (e) ->

      e.preventDefault()
      $el = $(e.currentTarget)
      order_id = $el.attr 'data-order_id'

      status = $el.find(':selected').val()
      Conn.io.emit 'orders:updateOrderToShip', {order_id: order_id, status: status}, (result) ->
        console.log result

