define [
  'cs!components/clientAuthentication'
  'jquery'
  'backbone'
  'cs!models/user'
  'hbs!views/widgets/widgetCoreHeader/viewWidgetCoreHeader'
], (
  ClientAuthentication
  $
  Backbone
  User
  ViewWidgetCoreHeader
) ->

  Backbone.View.extend
    className: 'header navbar navbar-inverse navbar-fixed-top'
    model: User
    initialize: ->

      this.model.bind 'change', this.render, this

    render: ->

      this.el.innerHTML = ViewWidgetCoreHeader this.model.toJSON()
      return this

    close: ->
      this.unbind()
      this.remove()
    events:
#      'click li.dropdown.user': 'click_user'
      'click *[data-action]': 'click_action'
    click_action: (e) ->

      e.preventDefault()
      $el = $(e.currentTarget)
      action = $el.attr 'data-action'

      switch action
        when 'toggle-user-menu'
          this.toggle_user_menu(e)
        when 'logout'
          ClientAuthentication.unauthenticate()
        when 'expand-main-menu'
          if $('div.page-container div.page-sidebar').hasClass 'in'
            $('div.page-container div.page-sidebar').removeClass('in').css('height', '0')
          else
            $('div.page-container div.page-sidebar').addClass('in').css('height', 'auto')

    click_close: (e) ->

      $('body').unbind('click', this.click_close)
      this.$el.find('li.dropdown.user').removeClass 'open'
      this.$el.find('li.dropdown.user ul').hide()

    toggle_user_menu: (e) ->

      $el = $(e.currentTarget)

      if $el.hasClass 'open'
        $el.removeClass 'open'
        this.$el.find('li.dropdown.user ul').hide()
        $('body').unbind('click', this.click_close)
      else
        $el.addClass 'open'
        this.$el.find('li.dropdown.user ul').show()
        #close if click outside
        $('body').bind('click', this.click_close.bind(this))

      return false
