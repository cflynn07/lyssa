if !window.console?
  window.console = {}
if !window.console.log?
  window.console.log = ->


requirejs.config
  baseUrl: '/'
  paths:
    'angular':              'vendor/angular'
    'angular-ui':           'vendor/angular-ui'
    'angular-bootstrap':    'vendor/angular-bootstrap'
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
    'jquery-ui':            'vendor/jquery-ui'
    'bootstrap':            'vendor/bootstrap'
    'bootstrapFileUpload':  'vendor/bootstrap-fileupload'
    'jqueryUniform':        'vendor/jquery.uniform'
    'jqueryBrowser':        'vendor/jquery.browser'
    'datatables':           'vendor/jquery-dataTables'
    'datatables_bootstrap': 'vendor/DT_bootstrap'
    'jqueryDateFormat':     'vendor/jquery-dateFormat'
    'bootstrap-tree':       'vendor/bootstrap-tree'
    'pubsub':               'vendor/pubsub'
    'fullCalendar':         'vendor/fullcalendar'
    'bootstrap-toggle-buttons': '/vendor/bootstrap-toggle-buttons'
    'uuid':                     'vendor/uuid'
  hbs:
    disableI18n: true
    helperDirectory: 'views/helpers/'
    templateExtension: 'html'
  shim:
    angular:
      deps: ['jquery-ui']
      exports: 'angular'
    'angular-ui':
      deps:    ['angular', 'jquery', 'jquery-ui']
      exports: 'angular'
    'angular-bootstrap':
      deps:    ['angular', 'jquery', 'jquery-ui', 'bootstrap']
      exports: 'angular'
    underscore:
      exports: '_'
    io:
      exports: 'io'
    cs:
      deps:    ['coffee-script']
    jquery:
      exports: '$'
    'jquery-ui':
      deps:    ['jquery']
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
    fullCalendar:
      deps:    ['jquery']
    pubsub:
      exports: 'pubsub'
    'bootstrap-toggle-buttons':
      deps:     ['jquery', 'bootstrap']


require [
  'jquery'
  'jquery-ui'
  'bootstrap-toggle-buttons'
  'fullCalendar'
  'bootstrap'
  'angular'
  'cs!config/clientConfig'
  'angular-ui'
  'angular-bootstrap'
  'cs!animations/animationSlideUpDown'
  'cs!animations/animationFadeInOut'
  'cs!directives/directiveAnimateIn'
  'cs!directives/directiveCollapseWidget'
  'cs!directives/directiveAnimateRouteChange'
  'cs!directives/directiveDatePicker'
  'cs!directives/directiveToggleButton'
  'cs!directives/directiveInlineEdit'
  'cs!directives/directiveUniqueField'
  'cs!directives/directiveDataTable'
  'cs!services/serviceSocket'
  'cs!services/servicePubSub'
  'cs!services/serviceAuthenticate'
  'cs!services/serviceAPIRequest'
  'cs!filters/filterToArray'
  'cs!controllers/controllerApp'
  'cs!controllers/controllerCoreWidgets'
  'cs!controllers/controllerWidgetCoreLeftMenu'
  'cs!controllers/controllerWidgetCoreLogin'
  'cs!controllers/controllerWidgetCoreHeader'
  'cs!controllers/controllerWidgetCoreFooter'
  'cs!controllers/widgets/widgetBreadCrumbs/controllerWidgetBreadCrumbs'
  'cs!controllers/widgets/widgetExerciseBuilder/controllerWidgetExerciseBuilder'
  'cs!controllers/widgets/widgetDictionaryManager/controllerWidgetDictionaryManager'
  'cs!controllers/widgets/widgetScheduler/controllerWidgetScheduler'
  'cs!controllers/widgets/widgetFullExerciseSubmitter/controllerWidgetFullExerciseSubmitter'
  'cs!controllers/widgets/widget4oh4/controllerWidget4oh4'
], (
  $
  jqueryUi
  bootstrapToggleButtons
  jqueryFullCalendar
  bootstrap
  angular
  clientConfig
  angularUi
  angularBootstrap
  AnimationSlideUpDown
  AnimationFadeInOut
  DirectiveAnimateIn
  DirectiveCollapseWidget
  DirectiveAnimateRouteChange
  DirectiveDatePicker
  DirectiveToggleButton
  DirectiveInlineEdit
  DirectiveUniqueField
  DirectiveDataTable
  ServiceSocket
  ServicePubSub
  ServiceAuthenticate
  ServiceAPIRequest
  FilterToArray
  ControllerApp
  ControllerCoreWidgets
  ControllerWidgetCoreLeftMenu
  ControllerWidgetCoreLogin
  ControllerWidgetCoreHeader
  ControllerWidgetCoreFooter
  ControllerWidgetBreadCrumbs
  ControllerWidgetExerciseBuilder
  ControllerWidgetDictionaryManager
  ControllerWidgetScheduler
  ControllerWidgetFullExerciseSubmitter
  ControllerWidget4oh4
) ->

  #Modules
  CS = angular.module 'CS', ['ui', 'ui.bootstrap']

  #Animations
  AnimationSlideUpDown CS
  AnimationFadeInOut   CS

  #Directives
  DirectiveCollapseWidget     CS
  DirectiveAnimateIn          CS
  DirectiveAnimateRouteChange CS
  DirectiveDatePicker         CS
  DirectiveToggleButton       CS
  DirectiveInlineEdit         CS
  DirectiveUniqueField        CS
  DirectiveDataTable          CS

  #Services
  ServiceSocket CS
  ServicePubSub CS
  ServiceAuthenticate CS
  ServiceAPIRequest   CS

  #Filters
  FilterToArray CS

  #Routes
  CS.config ($routeProvider) ->
    for key, value of clientConfig.routes
      $routeProvider.when key,
        path: key
        pathValue: value
      if _.isArray value.subRoutes
        for value2 in value.subRoutes
          for objectKey, objectValue of value2
            console.log key + objectKey
            $routeProvider.when key + objectKey,
              path:      key + objectKey
              pathValue: _.extend(value, objectValue)
    $routeProvider.otherwise
      invalid: true

  ControllerApp                         CS
  ControllerCoreWidgets                 CS
  ControllerWidgetCoreLeftMenu          CS
  ControllerWidgetCoreHeader            CS
  ControllerWidgetBreadCrumbs           CS
  ControllerWidgetExerciseBuilder       CS
  ControllerWidgetCoreLogin             CS
  ControllerWidgetDictionaryManager     CS
  ControllerWidgetScheduler             CS
  ControllerWidgetFullExerciseSubmitter CS
  ControllerWidget4oh4                  CS
  ControllerWidgetCoreFooter            CS

  angular.bootstrap document, ['CS']
