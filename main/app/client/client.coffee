if !window.console?
  window.console = {}
if !window.console.log?
  window.console.log = ->


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
    'bootstrap-tree':       'vendor/bootstrap-tree'
    'pubsub':               'vendor/pubsub'
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
    'bootstrap-tree':
      deps:    ['jquery']
    pubsub:
      exports: 'pubsub'

require [
  'jquery'
  'bootstrap'
  'angular'
  'cs!animations/animationSlideUpDown'
  'cs!directives/directiveAnimateIn'
  'cs!directives/directiveAnimateRouteChange'
  'cs!services/serviceSocket'
  'cs!services/servicePubSub'
  'cs!services/serviceAuthenticate'
  'cs!controllers/controllerApp'
  'cs!controllers/controllerCoreWidgets'
  'cs!controllers/controllerWidgetCoreLeftMenu'
  'cs!controllers/controllerWidgetCoreLogin'
  'cs!controllers/controllerWidgetCoreHeader'
  'cs!controllers/widgets/controllerWidgetBreadCrumbs'
  'cs!controllers/widgets/ControllerWidgetExerciseBuilder'
], (
  $
  bootstrap
  angular

  AnimationSlideUpDown

  DirectiveAnimateIn
  DirectiveAnimateRouteChange
  ServiceSocket
  ServicePubSub
  ServiceAuthenticate
  ControllerApp
  ControllerCoreWidgets
  ControllerWidgetCoreLeftMenu
  ControllerWidgetCoreLogin
  ControllerWidgetCoreHeader
  ControllerWidgetBreadCrumbs
  ControllerWidgetExerciseBuilder
) ->

  #Modules
  CS = angular.module 'CS', []

  #Animations
  AnimationSlideUpDown CS

  #Directives
  DirectiveAnimateIn          CS
  DirectiveAnimateRouteChange CS

  #Services
  ServiceSocket CS
  ServicePubSub CS
  ServiceAuthenticate CS

  #Routes
  CS.config ($routeProvider) ->
    $routeProvider
      .when('/menu1a', {
        action: 'menu.1.a'
      })
      .when('/menu1a/sub1', {
        action: 'menu.1.SUB'
      })
      .when('/menu1b', {
        action: 'menu.1.b'
      })
      .when('/menu2', {
        action: 'menu.2'
      })
      .when('/menu3', {
        action: 'menu.3'
      })

      .when('/templates', {
        action: 'menu.3'
      })
      .when('/templates/:templateId', {
        action: 'menu.3'
      })
      .when('/templates/:templateId/:revisionId', {
        action: 'menu.3'
      })

      .otherwise({
        redirectTo: '/menu1a'
      })

  ControllerApp                   CS
  ControllerCoreWidgets           CS
  ControllerWidgetCoreLeftMenu    CS
  ControllerWidgetCoreHeader      CS
  ControllerWidgetBreadCrumbs     CS
  ControllerWidgetExerciseBuilder CS
  ControllerWidgetCoreLogin       CS

  angular.bootstrap document, ['CS']
