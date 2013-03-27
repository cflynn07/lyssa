define [
  'cs!components/conn'
  'backbone'
  'jquery'
  'datatables'
#  'datatables_bootstrap'
  'cs!models/user'
  'hbs!views/widgets/widgetSuperAdminClients/viewWidgetSuperAdminClients'
  'hbs!views/widgets/widgetSuperAdminClients/viewWidgetSuperAdminClientsDetails'
  'cs!widgets/widgetSuperAdminAddClient'
  #'cs!views/helpers/standardDateTime'
], (
  conn
  Backbone
  $
  DataTables
  User
  ViewWidgetSuperAdminClients
  ViewWidgetSuperAdminClientsDetails
  WidgetSuperAdminAddClient
  HelperStandardDateTime
) ->

  Backbone.View.extend
    sub_views: []
    dataTable: null
    dataTableOpenRows: []
    initialize: ->

      _this = this
      conn.io.emit 'super_admin:retrieveClients', {}, (response)->
        console.log response
        if response.success
          _this.update response.clients

    update: (clients) ->

      this.el.innerHTML = ViewWidgetSuperAdminClients
        clients: clients

      this.dataTable = this.$el.find('#vox_clients').dataTable
        "aLengthMenu": [
            [10, 25, 50, -1],
            [5, 15, 20, "All"]
        ]
        # set the initial value
        "iDisplayLength": 5
        "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>"
        "sPaginationType": "bootstrap"
        "oLanguage":
            "sLengthMenu": "_MENU_ clients per page"
            "oPaginate":
                "sPrevious": "Prev"
                "sNext": "Next"
        "aaData": clients
        "aoColumns": [
          "mDataProp": "name"
        ,
          mDataProp: 'primary_email'
        ,
          "mDataProp": "created_at"
          "mRender": (data, type, full) ->
            return data #HelperStandardDateTime(data)
        ,
          "mDataProp": "updated_at"
          "mRender": (data, type, full) ->
            return data #HelperStandardDateTime(data)
        ,
          "mDataProp": null
          "sDefaultContent": "<a href=\"javascript:;\" data-action=\"view_client_users\">View Users</a>"
          "bSortable": false
        ]
       # "aoColumnDefs": [
       #     'bSortable': false
       #     'aTargets': [0]
       # ]
      this.$el.find('#vox_clients_wrapper .dataTables_filter input').addClass("m-wrap medium") # modify table search input
      this.$el.find('#vox_clients_wrapper .dataTables_length select').addClass("m-wrap xsmall") # modify table per page dropdown


      this.$el.hide().fadeIn 'fast'

    close: ->

      #not really necesary, trying to just get into the groove of doing this

      this.unbind()
      this.remove()

      for v in this.sub_views
        try
          v.close()

    render: ->

       #this.el.innerHTML = ViewWidgetAdminUsers()
       # users: ['a', 'b', 'c']

      return this
    events:
      'click #add_client':    'click_add_client'
      'event-client-add':     'event_client_add'
      'click *[data-action]': 'click_data_action'
    view_client_users: (e) ->

      tr = $(e.currentTarget).parents('tr').get(0)
      i = $.inArray tr, this.dataTableOpenRows

      if i is -1
        this.dataTable.fnOpen tr, ViewWidgetSuperAdminClientsDetails(this.dataTable.fnGetData(tr)), 'details'
        this.dataTableOpenRows.push tr
      else
        this.dataTable.fnClose tr
        this.dataTableOpenRows.splice i, 1

    click_data_action: (e) ->
      e.preventDefault()
      $el = $(e.currentTarget)
      action = $el.attr 'data-action'

      switch action
        when 'view_client_users'
          this.view_client_users(e)

    event_client_add: (e) ->
      this.initialize()


    click_add_client: (e) ->
      e.preventDefault()
      _this = this
      v = new WidgetSuperAdminAddClient()
      _this.$el.find('#holder_add_client').html(v.render().el).hide().slideDown()
      _this.sub_views.push v



