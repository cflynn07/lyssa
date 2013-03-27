define [
  'jquery'
  'datatables'

  'backbone'
  'cs!models/user'
  'cs!components/conn'
  'hbs!views/widgets/widgetMyOrders/viewWidgetMyOrders'
  'cs!widgets/widgetMyOrdersAdd'
  'cs!widgets/widgetMyOrdersAddManual'
  'cs!widgets/widgetOrderDetail'
], (
  $
  $datatables

  Backbone
  User
  Conn
  ViewWidgetMyOrders
  WidgetMyOrdersAdd
  WidgetMyOrdersAddManual
  WidgetOrderDetail
) ->

  Backbone.View.extend
    sub_views: []
    dataTableOpenRows: []
    dataTable: null
    flashed: false
    MyOrders: []
    initialize: ->
      _this = this



      init = () ->
        Conn.io.emit 'orders:retrieveMyOrders', {}, (response) ->
          console.log response
          if response.success
            _this.MyOrders = response.MyOrders
            _this.update()
      init()

      User.on 'myOrders:change', init




    close: ->

      for v in this.sub_views
        try
          v.close()

      User.off 'myOrders:change'

      this.unbind()
      this.remove()

    update: ()->

      console.log 'update'

      this.el.innerHTML = ViewWidgetMyOrders
        orders: this.MyOrders


      this.dataTable = this.$el.find('table').dataTable()


      if !this.flashed
        this.flashed = true
        this.$el.hide().fadeIn 'fast'

    render: ->

      return this

    events:
      'click *[data-action]': 'click_data_action'

    click_data_action: (e) ->
      e.preventDefault()
      $el = $ e.currentTarget
      action = $el.attr 'data-action'

      switch action
        when 'add-order-csv'
          v = new WidgetMyOrdersAdd()
          this.$el.find('div#holder_add_order').html v.render().el
          for v in this.sub_views
            try
              v.close()

          this.sub_views.push v

        when 'add-order-manually'
          v = new WidgetMyOrdersAddManual()
          this.$el.find('div#holder_add_order').html v.render().el
          for v in this.sub_views
            try
              v.close()

          this.sub_views.push v




        when 'view-order-detail'
          tr = $(e.currentTarget).parents('tr').get(0)
          i = $.inArray tr, this.dataTableOpenRows

          order_id = $el.attr 'data-order_id'
          status   = $el.attr 'data-order_status'

          if i is -1
            w = new WidgetOrderDetail({order_id: order_id, status: status})
            this.dataTable.fnOpen tr, w.el, 'details'
            this.dataTableOpenRows.push tr
          else
            this.dataTable.fnClose tr
            this.dataTableOpenRows.splice i, 1





        when 'update-order-status'

          order_id = $el.attr 'data-order_id'


          for o in this.MyOrders
            if o.id is order_id
              o.received = !o.received
              break

          this.update()

          Conn.io.emit 'orders:updateMyOrderStaus', {order_id: order_id}, (result) ->
            User.trigger 'myOrders:change'


