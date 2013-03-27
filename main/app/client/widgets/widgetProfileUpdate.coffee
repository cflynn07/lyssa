define [
  'cs!components/conn'
  'jquery'
#  'bootstrap'
  'backbone'
  'cs!models/user'
  'hbs!views/widgets/widgetProfileUpdate/viewWidgetProfileUpdate'
], (
  conn
  $
#  Bootstrap
  Backbone
  User
  ViewWidgetProfileUpdate
) ->

  Backbone.View.extend
    model: User

    form_submitting: false

    initialize: ->
    render: ->

      this.el.innerHTML = ViewWidgetProfileUpdate this.model.toJSON()

      return this

    close: ->
      this.unbind()
      this.remove()
    events:
      'click *[data-action]': 'click_action'
    click_action: (e) ->

      e.preventDefault()
      $el = $(e.currentTarget)
      action = $el.attr 'data-action'

      switch action
        when 'save'
          this.save_profile(e)



    save_profile: (e) ->

      if this.form_submitting
        return
      this.form_submitting = true

      data = {}
      this.$el.find('input').each () ->
        data[$(this).attr('name')] = $(this).val()

      _this = this
      conn.io.emit 'profile:update', data, (response) ->
        _this.form_submitting = false

        if response.success and response.user

          _this.$el.find('#save_complete_modal').find('#modal_message').html 'You have updated your profile'
          _this.$el.find('#save_complete_modal').modal 'show'

          User.clear
            silent: true
          User.set _.extend {authenticated: true}, response.user


        else if response.error and response.message
          _this.$el.find('#save_complete_modal').find('#modal_message').html response.message
          _this.$el.find('#save_complete_modal').modal 'show'

