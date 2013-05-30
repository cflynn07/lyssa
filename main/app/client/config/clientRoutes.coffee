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
        ['viewWidgetActivityFeed', 'viewWidgetActivityFeed']
        ['viewWidgetActivityFeed']
      ]



    $routeProvider.when '/admin/themis/templates',
      root: '/admin/themis/templates'
      group: 'templates'
      subGroup: ''
      widgetViews: [
      ]
    $routeProvider.when '/admin/themis/templates/exercises',
      root: '/admin/themis/templates/exercises'
      group: 'templatesExercises'
      subGroup: ''
      widgetViews: [
        ['viewWidgetExerciseBuilder']
      ]
    $routeProvider.when '/admin/themis/templates/exercises/:templateUid',
      root: '/admin/themis/templates/exercises'
      group: 'templatesExercises'
      subGroup: ''
      widgetViews: [
        ['viewWidgetExerciseBuilder']
      ]
    $routeProvider.when '/admin/themis/templates/exercises/:templateUid/:revisionUid',
      root: '/admin/themis/templates/exercises'
      group: 'templatesExercises'
      subGroup: ''
      widgetViews: [
        ['viewWidgetExerciseBuilder']
      ]



    $routeProvider.when '/admin/themis/templates/quizes',
      root: '/admin/themis/templates/quizes'
      group: 'templatesQuizes'
      subGroup: ''
      widgetViews: [
        ['viewWidgetExerciseBuilder']
      ]
    $routeProvider.when '/admin/themis/templates/quizes/:templateUid',
      root: '/admin/themis/templates/quizes'
      group: 'templatesQuizes'
      subGroup: ''
      widgetViews: [
        ['viewWidgetExerciseBuilder']
      ]
    $routeProvider.when '/admin/themis/templates/quizes/:templateUid/:revisionUid',
      root: '/admin/themis/templates/quizes'
      group: 'templatesQuizes'
      subGroup: ''
      widgetViews: [
        ['viewWidgetExerciseBuilder']
      ]


    $routeProvider.when '/admin/themis/schedule',
      root: '/admin/themis/schedule'
      group: 'schedule'
      subGroup: ''
      widgetViews: [
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
        ['viewWidgetDictionaryManager']
      ]
    $routeProvider.when '/admin/themis/settings/dictionaries/:dictionaryUid',
      root: '/admin/themis/settings/dictionaries'
      group: 'settingsDictionaries'
      subGroup: ''
      widgetViews: [
        ['viewWidgetDictionaryManager']
      ]
    $routeProvider.when '/admin/themis/settings/employees',
      root: '/admin/themis/settings/employees'
      group: 'settingsEmployees'
      subGroup: ''
      widgetViews: [
        ['viewWidgetEmployeeManager']
      ]

    $routeProvider.otherwise
      invalid: true




