define [
  'jquery'
  'backbone'
  'cs!models/user'
  'hbs!views/widgets/widgetCoreLeftMenu/viewWidgetCoreLeftMenu'
], (
  $
  Backbone
  User
  ViewWidgetCoreLeftMenu
) ->

  Backbone.View.extend
    className: 'page-sidebar nav-collapse collapse'
    model: User
    initialize: ->

      $(window).bind 'hashchange', this.hash_change.bind(this)

    render: ->

      this.el.innerHTML = ViewWidgetCoreLeftMenu _.extend {super_admin: User.get('super_admin')}, this.model.toJSON()
      this.hash_change()
      return this

    close: ->

      this.unbind()
      this.remove()
      $(window).unbind 'hashchange', this.hash_change

    events: {}

    hash_change: () ->
      hash = window.location.hash

      this.$el.find('.active').removeClass 'active'
      this.$el.find('.open').removeClass('open')

      #First check if it's a sub menu
      $el = this.$el.find('ul.sub a[href="' + hash + '"]')
      if $el.length > 0
        $el.parents('li').addClass 'active'
        $el = $el.parents('ul.sub')

        $el.parents('li.has-sub').addClass 'active'
        $el.parents('li.has-sub').find('span.arrow').addClass 'open'

        if !$el.is(':visible')
          this.$el.find('ul.sub').hide()
          $el.slideDown 200
      else
        $el = this.$el.find('#sidebar_top > li > a[href="' + hash + '"]')
        $el.parent().addClass 'active'
        this.$el.find('ul.sub:visible').hide()














