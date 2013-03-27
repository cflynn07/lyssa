if !window.console?
  window.console = {}
if !window.console.log?
  window.console.log = ->

window.WEB_SOCKET_SWF_LOCATION = '/socket.io/static/flashsocket/WebSocketMain.swf'

requirejs.config
  baseUrl: '/'
  paths:
    text:                 'vendor/text'
    'coffee-script':      'vendor/coffee-script'
    cs:                   'vendor/cs'
    hbs:                  'vendor/hbs'
    Handlebars:           'vendor/Handlebars'
    i18nprecompile:       'vendor/hbs/i18nprecompile'
    json2:                'vendor/hbs/json2'
    io:                   'vendor/socket.io'
    underscore:           'vendor/underscore'
    backbone:             'vendor/backbone'
    jquery:               'vendor/jquery'
    bootstrap:            'vendor/bootstrap'
    bootstrapFileUpload:  'vendor/bootstrap-fileupload'
    jqueryUniform:        'vendor/jquery.uniform'
    jqueryBrowser:        'vendor/jquery.browser'
    datatables:           'vendor/jquery-dataTables'
    datatables_bootstrap: 'vendor/DT_bootstrap'
    jqueryDateFormat:     'vendor/jquery-dateFormat'

    #File-upload assets
    jqueryFileUpload:       'vendor/file-upload/jquery.fileupload'
    jqueryFileUploadFp:     'vendor/file-upload/jquery.fileupload-fp'
    jqueryFileUploadUi:     'vendor/file-upload/jquery.fileupload-ui'
    jqueryIframeTransport:  'vendor/file-upload/jquery.iframe-transport'
    'jquery.ui.widget':     'vendor/file-upload/jquery.ui.widget'
    tmplMin:                'tmpl.min'

    jqueryAutoComplete:     'vendor/jquery-autocomplete/jquery-ui-1.10.2.custom'

  #config:
   hbs:
    disableI18n: true
    helperDirectory: 'views/helpers/'
#   templateExtension: 'hbs'
  shim:
    underscore:
      exports: '_'
    io:
      exports: 'io'
    cs:
      deps:    ['coffee-script']
    jquery:
      exports: '$'
    jqueryBrowser:
      deps:    ['jquery']
    jqueryUniform:
      deps:    ['jqueryBrowser', 'jquery']
    backbone:
      deps:    ['underscore', 'jquery']
      exports: 'Backbone'
    bootstrap:
      deps:    ['jquery']
    datatables:
      deps:    ['jquery']

    #File-upload assets
    jqueryFileUpload:
      deps:    ['jquery']
    jqueryFileUploadFp:
      deps:    ['jquery']
    jqueryFileUploadUi:
      deps:    ['jquery']
    jqueryIframeTransport:
      deps:    ['jquery']
    'jquery.ui.widget':
      deps:    ['jquery']
    tmplMin:
      deps:    ['jquery']

    jqueryAutoComplete:
      deps:    ['jquery']

require [
  'cs!components/conn'
  'cs!models/user'
  'cs!controllers/controllerOrders'
  'cs!controllers/controllerAdmin'
  'cs!controllers/controllerSuperAdmin'
  'cs!controllers/controllerProfile'
  'cs!controllers/controllerCore'
  'backbone'
  'jquery'
  'jqueryBrowser'
  'jqueryUniform'
  'datatables_bootstrap'
], (
  conn
  User
  ControllerOrders
  ControllerAdmin
  ControllerSuperAdmin
  ControllerProfile
  ControllerCore
  Backbone


  $
  $browser
  $uniform
  datatables_bootstrap
) ->

  $('#status').text 'Establishing Secure Connection...'

  #Must make sure socketio has done it's thing before starting the rest of the app
  start = () ->
    ControllerCore.initialize()
    conn.io.emit 'authenticate:status', {}, (response) ->
      User.set response

  conn.initialize () ->
    start()

