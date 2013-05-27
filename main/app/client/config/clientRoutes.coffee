define [], () ->

  ($routeProvider) ->

    $routeProvider.when '/admin/themis',
      root: '/admin/themis'
      group: 'dashboard'
      subGroup: ''
      widgetViews: [
        'viewWidgetActivityFeed'
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
      ]
