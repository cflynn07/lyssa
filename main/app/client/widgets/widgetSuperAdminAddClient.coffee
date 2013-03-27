define [
  'cs!components/conn'
  'backbone'
  'jquery'
  'cs!models/user'
  'hbs!views/widgets/widgetSuperAdminAddClient/viewWidgetSuperAdminAddClient'
], (
  conn
  Backbone
  $
  User
  ViewWidgetSuperAdminAddClient
) ->

  Backbone.View.extend
    initialize: ->

     # _this = this
     # conn.io.emit 'super_admin:retrieveClients', {}, (response)->
     #   console.log response
     #   if response.success
     #     _this.update response.clients

    update: (clients) ->

      this.el.innerHTML = ViewWidgetSuperAdminClients
        clients: clients

    close: ->
      this.unbind()
      this.remove()
    render: ->

      this.el.innerHTML = ViewWidgetSuperAdminAddClient()
      return this

    events:
      'submit form':    'submit'
      'click #submit':  'submit'
      'click *[data-action]': 'click_data_action'
    submit: (e) ->
      e.preventDefault()
      _this = this
      name = _this.$el.find('input[name=name]').val()
      conn.io.emit 'super_admin:addClient', {name: name}, (response) ->
        if response.success
          _this.$el.trigger 'event-client-add'
          _this.close()

    click_data_action: (e) ->

      e.preventDefault()
      $el = $(e.currentTarget)
      action = $el.attr 'data-action'

      switch action
        when 'remove'
          this.close()
        when 'submit'
          this.submit(e)




