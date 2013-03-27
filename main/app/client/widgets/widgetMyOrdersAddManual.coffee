define [

  'cs!components/conn'

  'backbone'
  'jquery'
  'jqueryAutoComplete'

  'cs!models/user'
  'cs!components/conn'
  'hbs!views/widgets/widgetMyOrders/viewWidgetMyOrdersAddManual'

], (
  Conn

  Backbone
  $
  $ac

  User
  conn
  ViewWidgetMyOrdersAddManual
) ->

  Backbone.View.extend
    initialize: ->


    close: ->
      this.unbind()
      this.remove()

    render: ->

      this.el.innerHTML = ViewWidgetMyOrdersAddManual()

      _this = this
      Conn.io.emit 'orders:retrieveClientsEmails', {}, (response) ->
        console.log response
        if response.success
          _this.$el.find('input[name=email]').autocomplete
            source: response.clients
            delay: 0

      return this

    events:
      'click *[data-action]': 'click_data_action'
    click_data_action: (e) ->
      e.preventDefault()
      $el = $ e.currentTarget
      action = $el.attr 'data-action'
      switch action
        when 'close'
          this.close()
        when 'save-manual'
          this.save()
    save: () ->

      data = {}
      this.$el.find('input,textarea').each () ->
        data[$(this).attr('name')] = $(this).val()

      _this = this
      Conn.io.emit 'orders:addManual', data, (response) ->
        if response.success
          User.trigger 'myOrders:change'
          _this.close()
