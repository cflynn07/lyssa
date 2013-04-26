define [], () ->

  config =

    routes:
      #Admin Dashboard
      '/admin/themis':
        title:     'Dashboard'
        root:      '/admin/themis'
        subRoutes: [

        ]
        widgets:   [

        ]
      #Admin template builder
      '/admin/themis/templates':
        title:     'Templates'
        root:      '/admin/themis/templates'
        subRoutes: [
          '/:templateUid/:revisionUid':
            title:       'Templates'
            subMenuItem: false
        ]
        widgets:   [
          'viewWidgetExerciseBuilder'
        ]
      #Admin schedule editor
      '/admin/themis/schedule':
        title:     'Schedule'
        root:      '/admin/themis/schedule'
        subRoutes: [
        ]
        widgets:   [
          'viewWidgetScheduler'
        ]
      #Admin dictionaries editor
      '/admin/themis/dictionaries':
        title:     'Dictionaries'
        root:       '/admin/themis/dictionaries'
        subRoutes: [
          '/:dictionaryUid':
            title:       'Dictionaries'
            subMenuItem: false
        ]
        widgets:   [
          'viewWidgetDictionaryManager'
        ]

      #Delegate dashboard
      '/delegate/themis':
        title:     'Dashboard'
        root:       '/delegate/themis'
        subRoutes: [
        ]
        widgets:   [
        ]

      #Delegate exercise submission
      '/delegate/themis/exercises':
        title:     'Exercises'
        root:      '/delegate/themis/exercises'
        subRoutes: [
          '/:exerciseUid':
            title:       'Exercises'
            subMenuItem: false
        ]
        widgets:   [
        ]

    simplifiedUserCategories:
      'clientSuperAdmin': 'admin'
      'clientAdmin':      'admin'
      'clientDelegate':   'delegate'
    routeMatchClientType: (route, clientType) ->
      return route.indexOf('/' + @simplifiedUserCategories[clientType]) == 0
