define [], () ->

  ($routeProvider) ->

    $routeProvider.when '/profile',
      root: '/profile'
      group: 'profile'
      subGroup: ''
      widgetViews: [
      ]

    $routeProvider.when '/admin/themis',
      root: '/admin/themis'
      group: 'dashboard'
      subGroup: ''
      widgetViews: [
      #  ['viewWidgetActivityFeed', 'viewWidgetActivityFeed']
        ['viewWidgetBreadCrumbs']
        ['viewWidgetActivityFeed']
        #['viewWidgetActivityExercisesQuizes', 'viewWidgetScheduler']
        #['viewWidgetQuarterlyTestingReport']
      ]



    $routeProvider.when '/admin/themis/templates',
      root: '/admin/themis/templates'
      group: 'templates'
      subGroup: ''
      widgetViews: [
      ]
    $routeProvider.when '/admin/themis/templates/full',
      root: '/admin/themis/templates/full'
      group: 'templatesExercises'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetExerciseBuilder']
      ]
    $routeProvider.when '/admin/themis/templates/full/:templateUid',
      root: '/admin/themis/templates/full'
      group: 'templatesExercises'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetExerciseBuilder']
      ]
    $routeProvider.when '/admin/themis/templates/full/:templateUid/:revisionUid',
      root: '/admin/themis/templates/full'
      group: 'templatesExercises'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetExerciseBuilder']
      ]



    $routeProvider.when '/admin/themis/templates/mini',
      root: '/admin/themis/templates/mini'
      group: 'templatesQuizes'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetExerciseBuilder']
      ]
    $routeProvider.when '/admin/themis/templates/mini/:templateUid',
      root: '/admin/themis/templates/mini'
      group: 'templatesQuizes'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetExerciseBuilder']
      ]
    $routeProvider.when '/admin/themis/templates/mini/:templateUid/:revisionUid',
      root: '/admin/themis/templates/mini'
      group: 'templatesQuizes'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetExerciseBuilder']
      ]


    $routeProvider.when '/admin/themis/schedule',
      root: '/admin/themis/schedule'
      group: 'schedule'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetScheduler']
      ]


    $routeProvider.when '/admin/themis/settings',
      root: '/admin/themis/settings'
      group: 'settings'
      subGroup: ''
      widgetViews: [
      ]
    $routeProvider.when '/admin/themis/settings/dictionaries',
      root: '/admin/themis/settings/dictionaries'
      group: 'settingsDictionaries'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetDictionaryManager']
      ]
    $routeProvider.when '/admin/themis/settings/dictionaries/:dictionaryUid',
      root: '/admin/themis/settings/dictionaries'
      group: 'settingsDictionaries'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetDictionaryManager']
      ]
    $routeProvider.when '/admin/themis/settings/employees',
      root: '/admin/themis/settings/employees'
      group: 'settingsEmployees'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetEmployeeManager']
      ]




    ###
    $routeProvider.when '/quizzes',
      root: '/quizzes'
      group: 'quizSubmit'
      subGroup: ''
      widgetViews: [
      #  ['viewWidgetScheduler']
      ]
    $routeProvider.when '/quizzes/:eventParticipantUid',
      root: '/quizzes'
      group: 'quizSubmit'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetQuizExerciseSubmitter']
      ]
    ###


    $routeProvider.when '/exercises',
      root: '/exercises'
      group: 'exerciseSubmit'
      subGroup: ''
      widgetViews: [
      #  ['viewWidgetScheduler']
      ]
    $routeProvider.when '/exercises/:eventParticipantUid',
      root: '/exercises'
      group: 'exerciseSubmit'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetQuizExerciseSubmitter']
      ]



    $routeProvider.when '/admin/themis/reports/timeline',
      root: '/admin/themis/reports/timeline'
      group: 'reportsTimeline'
      subGroup: ''
      widgetViews: [
        ['viewNoBreadCrumbs']
        ['viewWidgetTimeline', 'viewWidgetScheduler']
      ]
      widgetData: 
        widgetTimeline:  {}
        widgetScheduler: {}
        widgetTabs: 
          tabs: [
            title: 'Summary'
            view:  'viewWidgetTimeline'
          ,
            title: 'Calendar'
            view:  'viewWidgetScheduler'
          ]




    $routeProvider.otherwise
      invalid: true




