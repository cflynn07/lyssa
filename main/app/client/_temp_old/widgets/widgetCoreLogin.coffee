define [
  'cs!components/clientAuthentication'
  'hbs!views/widgets/widgetCoreLogin/viewWidgetCoreLogin'
  'underscore'
  'backbone'
  'cs!components/conn'
  'cs!models/user'
], (
  ClientAuthentication
  ViewWidgetCoreLogin
  _
  Backbone
  conn
  User
) ->

  #Prevent multiple login submissions
  loginSubmitting = false

  Backbone.View.extend
    initialize: () ->
    render: () ->

      this.$el.addClass 'login'
      #this.$el.html html
      #this.$el.find('input[type=checkbox]').uniform()
      #this.$el.find('div.content').hide().fadeIn 'slow'

      this.$el.html ViewWidgetCoreLogin()

      return this

    close: ->
      this.unbind()
      this.remove()
    events:
      'change input[type=checkbox]': 'change_checkbox'
      'submit form#login_form':      'submit_login'
      'click button#login_btn':      'submit_login'
      'keyup form#login_form input': 'keyup_form'

    submit_form: (e) ->


    change_checkbox: (e) ->


    keyup_form: (e) ->
      if e.keyCode? && e.keyCode == 13
        this.submit_login(e)

    submit_login: (e) ->
      e.preventDefault()
      _this = this

      #Prevent multiple login submissions
      if loginSubmitting
        return
      loginSubmitting = true

      this.$el.find('div.alert').hide()

      #check for password && username
      if this.$el.find('input[name=email]').val().length is 0 || this.$el.find('input[name=password]').val().lenght is 0
        this.$el.find('div.alert span#error_msg').text 'Input your email and password'
        this.$el.find('div.alert').slideDown()
        loginSubmitting = false
        return

      this.$el.find('input[name=email],[name=password]').attr 'disabled', 'disabled'

      this.$el.find('#loading_img').removeClass 'hidden'
      this.$el.find('#login_btn').addClass 'hidden'

      data =
        email:    _this.$el.find('input[name=email]').val()
        password: _this.$el.find('input[name=password]').val()

      ClientAuthentication.authenticate data.email, data.password, (result) ->
        console.log 'callback invoked'
        loginSubmitting = false

        if !result #login failed
          _this.$el.find('#loading_img').addClass 'hidden'
          _this.$el.find('#login_btn').removeClass 'hidden'
          _this.$el.find('input[name=email],[name=password]').removeAttr 'disabled', 'disabled'
          _this.$el.find('div.alert span#error_msg').text 'Incorrect email or password'
          _this.$el.find('div.alert').slideDown()
        else
          Backbone.history.loadUrl()

