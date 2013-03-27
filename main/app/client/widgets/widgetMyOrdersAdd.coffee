define [
  'backbone'
  'jquery'
  'jqueryFileUpload'


  'cs!models/user'
  'cs!components/conn'
  'hbs!views/widgets/widgetMyOrders/viewWidgetMyOrdersAdd'
], (
  Backbone
  $
  $fup



  User
  conn
  ViewWidgetMyOrdersAdd
) ->

  Backbone.View.extend
    initialize: ->


    close: ->
      this.unbind()
      this.remove()

    render: ->

      _this = this

      this.el.innerHTML = ViewWidgetMyOrdersAdd()
      #this.$el.hide().slideDown
      this.$el.find('#fileupload').fileupload
        url: '/upload'
        progress: (e, data) ->
          progress = parseInt (data.loaded / data.total * 100), 10
          console.log progress
        done: (e, data) ->

          if data.result.success
            User.trigger 'myOrders:change'
          else
            if data.result.message
              alert data.result.message



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
        when 'save-csv'
          return

