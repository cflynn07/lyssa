define [
  'cs!widgets/abstract/widgetAbstract'
  'cs!components/conn'
  'backbone'
  'jquery'
  'cs!models/user'
  'hbs!views/widgets/widgetAdminUsers/viewWidgetAdminUsers'
  'cs!widgets/widgetAdminUsersAdd'
], (
  WidgetAbstract
  conn
  Backbone
  $
  User
  ViewWidgetAdminUsers
  WidgetAdminUsersAdd
) ->

  WidgetAbstract.extend
  #Backbone.View.extend
    sub_views: []
    initialize: ->

      _this = this

      init = () ->
        conn.io.emit 'admin:retrieveUsers', {}, (response)->
          console.log response
          if response.success
            _this.update response.users
            _this.fadeWidgetIn()
      init()

      User.on 'adminUsers:change', init

    update: (users) ->

      this.el.innerHTML = ViewWidgetAdminUsers
        users: users

      this.$el.hide().fadeIn 'fast'

    close: ->

      User.off 'adminUsers:change'

      for v in this.sub_views
        try
          v.close()

      this.unbind()
      this.remove()
    render: ->

       #this.el.innerHTML = ViewWidgetAdminUsers()
       # users: ['a', 'b', 'c']

      return this
    events:
      'click *[data-action]': 'click_data_action'
    click_data_action: (e) ->

      e.preventDefault()
      $el = $ e.currentTarget
      action = $el.attr 'data-action'

      switch action
        when 'add-new-user'
          v = new WidgetAdminUsersAdd()
          this.$el.find('#holder-add-new-user').html v.render().el
          this.sub_views.push v

