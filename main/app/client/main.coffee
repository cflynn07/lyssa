if !window.console?
  window.console = {}
if !window.console.log?
  window.console.log = ->

requirejs.config
  baseUrl: '/'
  paths:
    'angular':                  'vendor/angular'
    'angular-ui':               'vendor/angular-ui'
    'angular-bootstrap':        'vendor/angular-bootstrap'
    'text':                     'vendor/text'
    'coffee-script':            'vendor/coffee-script'
    'cs':                       'vendor/cs'
    'hbs':                      'vendor/hbs'
    'Handlebars':               'vendor/Handlebars'
    'i18nprecompile':           'vendor/hbs/i18nprecompile'
    'json2':                    'vendor/hbs/json2'
    'io':                       'vendor/socket.io'
    'underscore':               'vendor/underscore'
    'underscore_string':        'vendor/underscore.string'
    'backbone':                 'vendor/backbone'
    'jquery':                   'vendor/jquery'
    'jquery-ui':                'vendor/jquery-ui'
    'bootstrap':                'vendor/bootstrap'
    'gritter':                  'vendor/jquery.gritter'

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
    'spacetree':                'vendor/spacetree'
  hbs:
    disableI18n:       true
    helperDirectory:   'views/helpers/'
    templateExtension: 'html'
  shim:
    angular:
      deps:    ['jquery-ui', 'jqueryUniform', 'bootstrap-toggle-buttons']
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
      deps:    ['jquery', 'bootstrap']
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
    spacetree:
      exports: '$jit'

require [

  #Main AngularJS Module
  'app'
  'angular'

  'jqueryTouchPunch'

  'config/clientConfig'
  'config/clientRoutes'

  'vendor/fastclick'

  #Animations
  'animations/animationSlideUpDown'
  'animations/animationFadeInOut'

  #Directives
  'directives/directiveAnimateIn'
  'directives/directiveCollapseWidget'
  'directives/directiveAnimateRouteChange'
  'directives/directiveDatePicker'
  'directives/directiveToggleButton'
  'directives/directiveInlineEdit'
  'directives/directiveUniqueField'
  'directives/directiveDataTable'
  'directives/directiveFileUpload'
  'directives/directiveSlider'
  'directives/directiveCalendar'
  'directives/directiveEditEmployee'
  'directives/directiveDateTimePicker'
  'directives/directiveSpaceTree'
  'directives/directiveJqueryAutoComplete'

  #Services
  'services/serviceSocket'
  'services/servicePubSub'
  'services/serviceAuthenticate'
  'services/serviceAPIRequest'

  #Filters
  'filters/filterToArray'
  'filters/filterDeleted'
  'filters/filterTelephone'
  'filters/filterFromNow'

  #Controllers
  'controllers/controllerApp'
  'controllers/controllerCoreWidgets'
  'controllers/controllerWidgetCoreLeftMenu'
  'controllers/controllerWidgetCoreLogin'
  'controllers/controllerWidgetCoreHeader'
  'controllers/controllerWidgetCoreFooter'
  'controllers/widgets/widgetBreadCrumbs/controllerWidgetBreadCrumbs'
  'controllers/widgets/widgetExerciseBuilder/controllerWidgetExerciseBuilder'
  'controllers/widgets/widgetDictionaryManager/controllerWidgetDictionaryManager'
  'controllers/widgets/widgetScheduler/controllerWidgetScheduler'
  #'controllers/widgets/widgetFullExerciseSubmitter/controllerWidgetFullExerciseSubmitter'
  'controllers/widgets/widget4oh4/controllerWidget4oh4'
  'controllers/widgets/widgetEmployeeManager/controllerWidgetEmployeeManager'
  'controllers/widgets/widgetQuizExerciseSubmitter/controllerWidgetQuizExerciseSubmitter'
  'controllers/widgets/widgetActivityFeed/controllerWidgetActivityFeed'
  'controllers/widgets/widgetActivityExercisesQuizes/controllerWidgetActivityExercisesQuizes'
  'controllers/widgets/widgetQuarterlyTestingReport/controllerWidgetQuarterlyTestingReport'
  'controllers/widgets/widgetTimeline/controllerWidgetTimeline'
  'controllers/widgets/widgetTabs/controllerWidgetTabs'
  'controllers/widgets/widgetExerciseScheduleCalendar/controllerWidgetExerciseScheduleCalendar'

], (
  app
  angular
) ->

  app.config ['$routeProvider', ($routeProvider) ->
    ClientRoutes $routeProvider
  ]



#  ControllerWidgetCoreLogin                CS
#  ControllerWidgetDictionaryManager        CS
#  ControllerWidgetScheduler                CS
#  ControllerWidgetFullExerciseSubmitter    CS
#  ControllerWidget4oh4                     CS
#  ControllerWidgetCoreFooter               CS
#  ControllerWidgetEmployeeManager          CS
#  ControllerWidgetQuiz                     CS
  ControllerWidgetActivityFeed             CS
  ControllerWidgetActivityExercisesQuizes  CS
  ControllerWidgetQuarterlyTestingReport   CS
  ControllerWidgetQuizExerciseSubmitter    CS
  ControllerWidgetTimeline                 CS
  ControllerWidgetTabs                     CS
  ControllerWidgetExerciseScheduleCalendar CS


  #Start the party!
  angular.bootstrap document, ['app']

  #Helper to remove 300ms delay from touch events on iOS devices
  window.addEventListener 'load', () ->
    FastClick.attach document.body
  false
