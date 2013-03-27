define [
  'backbone'
  'cs!models/user'
  'cs!widgets/widgetCoreLogin'
  'cs!widgets/widgetCoreHeader'
  'cs!widgets/widgetCoreLeftMenu'
  'cs!widgets/widgetCoreFooter'
  'hbs!views/viewBase'
  'jquery'
  'cs!components/conn'
], (
  Backbone
  User
  WidgetCoreLogin
  WidgetCoreHeader
  WidgetCoreLeftMenu
  WidgetCoreFooter
  ViewBase
  $
  conn
) ->

  #holds ref to all Backbone.View objects currently in the DOM
  #Excludes global views like WidgetHeader, WidgetMenu, etc
  registered_views = []

  #Global widgets
  core_views = []

  ControllerCoreInstance = null

  controllerCore = Backbone.View.extend
    el: 'body'

    #jQuery wrapped and DOM reference to page-content area
    $pageContent: null
    pageContent: null

    #cache the ID of the currently logged in user, useful when model updates to know if this is a different user
    currentUserId: null

    initialize: ->

      this.model.bind 'change', this.renderWrapper, this

    renderWrapper: ->

      id = this.model.get 'id'
      if id
        if id is this.currentUserId
          return this
        this.currentUserId = id
      else
        this.currentUserId = null

      #iterate over login, left menu, header, and footer views if present and remove
      for v in core_views
        try
          v.close()
        catch e
          console.log e

      if this.model.get 'authenticated'
        this.renderAuth()
      else
        this.renderLogin()

      this.$el.hide().fadeIn 'fast'

      #If the user just logged in, refire the route to show them the authenticated version of their URL
      try
        Backbone.history.start()
      catch e
        console.log 'History already started'

      #Backbone.history.loadUrl()

    renderAuth: ->
      this.$el.removeClass 'login'
      this.$el.addClass 'fixed-top'

      for v in core_views
        try v.close()

      #create a holder to insert widgets into and append to document
      el = document.createElement 'div'
      el.innerHTML = ViewBase()
      $el = $(el)

      WidgetCoreHeaderInstance    = new WidgetCoreHeader()
      WidgetCoreLeftMenuInstance  = new WidgetCoreLeftMenu()
      WidgetCoreFooterInstance    = new WidgetCoreFooter()
      $el.find('#widgetCoreHeader').replaceWith    WidgetCoreHeaderInstance.render().el
      $el.find('#widgetCoreLeftMenu').replaceWith  WidgetCoreLeftMenuInstance.render().el
      $el.find('#widgetCoreFooter').replaceWith    WidgetCoreFooterInstance.render().el

      core_views = [
        WidgetCoreHeaderInstance
        WidgetCoreLeftMenuInstance
        WidgetCoreFooterInstance
      ]

      this.$pageContent = this.$el.find('div.page-content')
      this.pageContent = this.$pageContent.get(0)

      this.$el.html el

      #default route
      if window.location.hash is '' or window.location.hash is '#'
        window.location.hash = 'orders/my_orders'

    renderLogin: ->
      this.$el.addClass 'login'
      this.$el.removeClass 'fixed-top'

      for v in core_views
        try v.close()

      WidgetCoreLoginInstance = new WidgetCoreLogin model: User

      this.$el.html WidgetCoreLoginInstance.render().el

      core_views = [WidgetCoreLoginInstance]

    events:
      'click .page-sidebar div.sidebar-toggler': 'click_min_max_menu'
    click_min_max_menu: (e) ->
      this.$el.find('div.page-container:first').toggleClass 'sidebar-closed'





# ------ API ------
  initialize: () ->
    if ControllerCoreInstance
      return ControllerCoreInstance

 #   io.on 'user_authenticate', (data) ->
 #     alert 'Hey ' + User.get('first_name') + ', ' + data.first_name + ' ' + data.last_name + ' just signed in.'
 #     console.log data

    return ControllerCoreInstance = new controllerCore model: User




  #Removes any views from DOM & Inserts new batch of widgets in one DOM manipulation for performance
  insert_page_widgets: (widgets) ->

    #Check to make sure user is authenticated and not looking at the login screen
    if !User.get('authenticated')
      return

    for v in registered_views
      try
        v.close()
      catch e
        console.log e

    registered_views = []

    #SLOW, IMPROVE LATER
    $content = $('div.page-content > div.container-fluid')
    for v in widgets
      #ControllerCoreInstance.$pageContent.append v.render().el

      view_instance = new v.view(v.data)
      $content.append view_instance.render().el
      registered_views.push view_instance

    #construct holder template and insert into DOM
    #CoreControllerInstance.el.innerText = 'Test'
