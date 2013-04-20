if !window.console?
  window.console = {}
if !window.console.log?
  window.console.log = ->

#window.WEB_SOCKET_SWF_LOCATION = '/socket.io/static/flashsocket/WebSocketMain.swf'

requirejs.config
  baseUrl: '/'
  paths:
    'angular':              'vendor/angular'
    'text':                 'vendor/text'
    'coffee-script':        'vendor/coffee-script'
    'cs':                   'vendor/cs'
    'hbs':                  'vendor/hbs'
    'Handlebars':           'vendor/Handlebars'
    'i18nprecompile':       'vendor/hbs/i18nprecompile'
    'json2':                'vendor/hbs/json2'
    'io':                   'vendor/socket.io'
    'underscore':           'vendor/underscore'
    'backbone':             'vendor/backbone'
    'jquery':               'vendor/jquery'
    'bootstrap':            'vendor/bootstrap'
    'bootstrapFileUpload':  'vendor/bootstrap-fileupload'
    'jqueryUniform':        'vendor/jquery.uniform'
    'jqueryBrowser':        'vendor/jquery.browser'
    'datatables':           'vendor/jquery-dataTables'
    'datatables_bootstrap': 'vendor/DT_bootstrap'
    'jqueryDateFormat':     'vendor/jquery-dateFormat'
  hbs:
    disableI18n: true
    helperDirectory: 'views/helpers/'
    templateExtension: 'html'
  shim:
    angular:
      exports: 'angular'
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
    bootstrap:
      deps:    ['jquery']
    datatables:
      deps:    ['jquery']



require [
  'bootstrap'
  'angular'
  'cs!controllers/controllerApp'
  'cs!controllers/controllerWidgetCoreLeftMenu'
  'cs!controllers/controllerWidgetCoreLogin'
  'cs!controllers/controllerWidgetCoreHeader'
  'cs!controllers/widgets/controllerWidgetBreadCrumbs'
  'cs!controllers/controllerCoreWidgets'
], (
  bootstrap
  angular
  ControllerApp
  ControllerWidgetCoreLeftMenu
  ControllerWidgetCoreLogin
  ControllerWidgetCoreHeader
  ControllerWidgetBreadCrumbs
  ControllerCoreWidgets
) ->

  #Modules
  CS = angular.module 'CS', []

  console.log CS

  #Animations
  CS.animation 'animate-enter', () ->
    return {}


  #Routes
  CS.config ($routeProvider) ->
    $routeProvider.when('/home/:id', {
      action: 'standard.test'
    }).when('/admin', {
      action: 'standard.home'
    }).otherwise({
      redirectTo: '/'
    })

  #Controllers
  #Core
  CS.controller 'ControllerApp',                ControllerApp
  CS.controller 'ControllerCoreWidgets',        ControllerCoreWidgets
  CS.controller 'ControllerWidgetCoreLeftMenu', ControllerWidgetCoreLeftMenu
  CS.controller 'ControllerWidgetCoreLogin',    ControllerWidgetCoreLogin
  CS.controller 'ControllerWidgetCoreHeader',   ControllerWidgetCoreHeader

  #Widgets
  CS.controller 'ControllerWidgetBreadCrumbs',  ControllerWidgetBreadCrumbs


  angular.bootstrap document, ['CS']
