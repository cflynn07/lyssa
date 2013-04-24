define [], () ->

  config =

    routes:
      #Admin Dashboard
      '/admin/themis':
        title:     'Dashboard'
        subRoutes: []
        widgets:   []
      #Admin template builder
      '/admin/themis/templates':
        title:     'Templates'
        subRoutes: [
          '/:templateId/:revisionId':
            title:       'Templates'
            subMenuItem: false
        ]
        widgets:   [
          'viewWidgetExerciseBuilder'
        ]
      #Admin schedule editor
      '/admin/themis/schedule':
        title:     'Schedule'
        subRoutes: []
        widgets:   [
          'viewWidgetScheduler'
        ]
      #Admin dictionaries editor
      '/admin/themis/dictionaries':
        title:     'Dictionaries'
        subRoutes: [
          '/:dictionaryId':
            title:       'Dictionaries'
            subMenuItem: false
        ]
        widgets:   [
          'viewWidgetDictionaryManager'
        ]

      #Delegate dashboard
      '/delegate/themis':
        title:     'Dashboard'
        subRoutes: []
        widgets:   []

      #Delegate exercise submission
      '/delegate/themis/exercises':
        title:     'Exercises'
        subRoutes: [
          '/:exerciseId':
            title:       'Exercises'
            subMenuItem: false
        ]
        widgets:   []

    simplifiedUserCategories:
      'clientSuperAdmin': 'admin'
      'clientAdmin':      'admin'
      'clientDelegate':   'delegate'
    routeMatchClientType: (route, clientType) ->
      return route.indexOf('/' + @simplifiedUserCategories[clientType]) == 0
