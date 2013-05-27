define [], () ->

  config =

    isRouteQuiz: (path) ->
      return (path == '/quiz/:uid')

    routes:


      #Mobile Quiz
      '/quiz/:uid':
        title: 'quiz'
        root: '/quiz/:uid'
        subRoutes: []
        widgets:   [
          'viewWidgetQuiz'
        ]




      #User personal admin
      '/profile':
        title: 'Profile'
        root: '/profile'
        widgets: [

        ]
        subRoutes: []

      #Admin Dashboard
      '/admin/themis':
        title:     'Dashboard'
        root:      '/admin/themis'
        subRoutes: [

        ]
        widgets:   [
          'viewWidgetActivityFeed'
        ]





      '/admin/themis/templates':
        title:     'Templates'
        root:      '/admin/themis/templates'
        subRoutes: [

        ]
        widgets:   [
          'viewWidgetExerciseBuilder'
        ]
      '/admin/themis/templates/exercises':
        title:     'Templates'
        root:      '/admin/themis/templates/exercises'
        subRoutes: [
        #  '/:templateUid':
        #    title:       'Templates'
        #    subMenuItem: false
        #,
          '/:templateUid/:revisionUid':
            title:       'Templates'
            subMenuItem: false
        ]
        widgets:   [
          'viewWidgetExerciseBuilder'
        ]
      '/admin/themis/templates/quizes':
        title:     'Templates'
        root:      '/admin/themis/templates/quizes'
        subRoutes: [
        #  '/:templateUid':
        #    title:       'Templates'
        #    subMenuItem: false
        #,
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
          '/:eventUid':
            title: 'Schedule'
            subMenuItem: false
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
            subMenuItem: true
        ]
        widgets:   [
          'viewWidgetDictionaryManager'
        ]

      #Delegate exercise submission
      '/admin/themis/employees':
        title:     'Employees'
        root:      '/delegate/themis/employees'
        subRoutes: [
          '/:employeeUid':
            title:       'Employees'
            subMenuItem: false
        ]
        widgets:   [
          'viewWidgetEmployeeManager'
        ]

      #Delegate exercise submission
      '/admin/themis/exercises':
        title:     'Exercises'
        root:      '/admin/themis/exercises'
        subRoutes: [
          '/:exerciseUid':
            title:       'Exercises'
            subMenuItem: false
        ]
        widgets:   [
          'viewWidgetFullExerciseSubmitter'
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
