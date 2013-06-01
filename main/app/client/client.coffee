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
    'underscore_string':    'vendor/underscore.string'
    'backbone':             'vendor/backbone'
    'jquery':               'vendor/jquery'
    'jquery-ui':            'vendor/jquery-ui'
    'bootstrap':            'vendor/bootstrap'
    'gritter':              'vendor/jquery.gritter'


    'bootstrapFileUpload':      'vendor/bootstrap-fileupload'
    'jqueryFileUpload':         'vendor/file-upload/jquery.fileupload'
    'jqueryFileUploadFp':       'vendor/file-upload/jquery.fileupload-fp'
    'jqueryFileUploadUi':       'vendor/file-upload/jquery.fileupload-ui'
    'jqueryIframeTransport':    'vendor/file-upload/jquery.iframe-transport'
    'jquery.ui.widget':         'vendor/file-upload/jquery.ui.widget'


    'jqueryUniform':            'vendor/jquery.uniform'
    'jqueryBrowser':            'vendor/jquery.browser'
    'jqueryMaskedInput':        'vendor/jquery.maskedinput'
    'datatables':               'vendor/jquery-dataTables'
    'datatables_bootstrap':     'vendor/DT_bootstrap'
    'jqueryDateFormat':         'vendor/jquery-dateFormat'
    'bootstrap-tree':           'vendor/bootstrap-tree'
    'pubsub':                   'vendor/pubsub'
    'fullCalendar':             'vendor/fullcalendar'
    'bootstrap-toggle-buttons': 'vendor/bootstrap-toggle-buttons'
    'uuid':                     'vendor/uuid'
    'ejs':                      'vendor/ejs'
    'async':                    'vendor/async'
    'jqueryTouchPunch':         'vendor/jquery.touch.punch'
    'boostrapDateTimePicker':   'vendor/bootstrap-datetimepicker'
    'soundmanager2':            'vendor/soundmanager2'
    'slimscroll':               'vendor/jquery.slimscroll'
    'moment':                   'vendor/moment'
    'highcharts':               'vendor/highcharts'
  hbs:
    disableI18n:       true
    helperDirectory:   'views/helpers/'
    templateExtension: 'html'
  shim:
    angular:
      deps: ['jquery-ui', 'jqueryUniform', 'bootstrap-toggle-buttons']
      exports: 'angular'
    'angular-ui':
      deps:    ['angular', 'jquery', 'jquery-ui', 'jqueryMaskedInput']
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
    ejs:
      exports: 'EJS'
    uuid:
      exports: 'uuid'
    async:
      exports: 'async'
    underscore_string:
      deps:    ['underscore']
    jqueryMaskedInput:
      deps:    ['jquery', 'jqueryBrowser']
    jqueryTouchPunch:
      deps:    ['jquery']
    boostrapDateTimePicker:
      deps:    ['jquery', 'jquery-ui', 'bootstrap']
    gritter:
      deps:    ['jquery']
    highcharts:
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
    soundmanager2:
      exports: 'soundManager'
    slimscroll:
      deps:    ['jquery']



require [
  'jquery'
  'jquery-ui'
  'gritter'
  'jqueryTouchPunch'
  'bootstrap-toggle-buttons'
  'fullCalendar'
  'bootstrap'
  'angular'
  'cs!config/clientConfig'
  'angular-ui'
  'angular-bootstrap'
  'boostrapDateTimePicker'
  'vendor/fastclick'
  'cs!config/clientRoutes'
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
  'cs!directives/directiveFileUpload'
  'cs!directives/directiveSlider'
  'cs!directives/directiveCalendar'
  'cs!directives/directiveEditEmployee'
  'cs!directives/directiveDateTimePicker'
  'cs!services/serviceSocket'
  'cs!services/servicePubSub'
  'cs!services/serviceAuthenticate'
  'cs!services/serviceAPIRequest'
  'cs!filters/filterToArray'
  'cs!filters/filterDeleted'
  'cs!filters/filterTelephone'
  'cs!filters/filterFromNow'
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
  'cs!controllers/widgets/widgetEmployeeManager/controllerWidgetEmployeeManager'
  'cs!controllers/widgets/widgetQuiz/controllerWidgetQuiz'
  'cs!controllers/widgets/widgetActivityFeed/controllerWidgetActivityFeed'
  'cs!controllers/widgets/widgetActivityExercisesQuizes/controllerWidgetActivityExercisesQuizes'
  'cs!controllers/widgets/widgetQuarterlyTestingReport/controllerWidgetQuarterlyTestingReport'
], (
  $
  jqueryUi
  gritter
  jqueryTouchPunch
  bootstrapToggleButtons
  jqueryFullCalendar
  bootstrap
  angular
  clientConfig
  angularUi
  angularBootstrap
  boostrapDateTimePicker
  FastClick
  ClientRoutes
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
  DirectiveFileUpload
  DirectiveSlider
  DirectiveCalendar
  DirectiveEditEmployee
  DirectiveDateTimePicker
  ServiceSocket
  ServicePubSub
  ServiceAuthenticate
  ServiceAPIRequest
  FilterToArray
  FilterDeleted
  FilterTelephone
  FilterFromNow
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
  ControllerWidgetEmployeeManager
  ControllerWidgetQuiz
  ControllerWidgetActivityFeed
  ControllerWidgetActivityExercisesQuizes
  ControllerWidgetQuarterlyTestingReport
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
  DirectiveFileUpload         CS
  DirectiveSlider             CS
  DirectiveCalendar           CS
  DirectiveEditEmployee       CS
  DirectiveDateTimePicker     CS

  #Services
  ServiceSocket       CS
  ServicePubSub       CS
  ServiceAuthenticate CS
  ServiceAPIRequest   CS

  #Filters
  FilterToArray   CS
  FilterDeleted   CS
  FilterTelephone CS
  FilterFromNow   CS


  CS.config ['$routeProvider', ($routeProvider) ->
    ClientRoutes $routeProvider
  ]


  ControllerApp                           CS
  ControllerCoreWidgets                   CS
  ControllerWidgetCoreLeftMenu            CS
  ControllerWidgetCoreHeader              CS
  ControllerWidgetBreadCrumbs             CS
  ControllerWidgetExerciseBuilder         CS
  ControllerWidgetCoreLogin               CS
  ControllerWidgetDictionaryManager       CS
  ControllerWidgetScheduler               CS
  ControllerWidgetFullExerciseSubmitter   CS
  ControllerWidget4oh4                    CS
  ControllerWidgetCoreFooter              CS
  ControllerWidgetEmployeeManager         CS
  ControllerWidgetQuiz                    CS
  ControllerWidgetActivityFeed            CS
  ControllerWidgetActivityExercisesQuizes CS
  ControllerWidgetQuarterlyTestingReport  CS

  angular.bootstrap document, ['CS']

  window.addEventListener 'load', () ->
    FastClick.attach document.body
  false
