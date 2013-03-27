define [
  'cs!components/conn'
  'backbone'
  'jquery'
  'cs!models/user'
  'hbs!views/widgets/widgetAdminUsers/viewWidgetAdminUsersAdd'
], (
  conn
  Backbone
  $
  User
  ViewWidgetAdminUsersAdd
) ->

  Backbone.View.extend
    initialize: ->


    close: ->
      this.unbind()
      this.remove()
    render: ->

      this.el.innerHTML = ViewWidgetAdminUsersAdd()
      return this

    events:
      'submit form':    'submit'
      'click #submit':  'submit'
      'click *[data-action]': 'click_data_action'
    submit: (e) ->
      e.preventDefault()


      _this = this

      data = {}
      this.$el.find('input').each () ->
        data[$(this).attr('name')] = $(this).val()

      conn.io.emit 'admin:addUser', data, (response) ->
        if response.success
          User.trigger 'adminUsers:change'
          _this.close()

    click_data_action: (e) ->

      e.preventDefault()
      $el = $(e.currentTarget)
      action = $el.attr 'data-action'

      switch action
        when 'remove', 'close'
          this.close()
        when 'save'
          this.submit(e)






