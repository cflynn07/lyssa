define [
], (
) ->

  (Module) ->
    Module.factory 'authenticate', ['$rootScope', 'socket',
    ($rootScope, socket) ->

      factory =
        authenticate: (user) ->
          $rootScope.rootStatus = 'authenticated'
          $rootScope.rootUser   = user

        unauthenticate: () ->

          socket.emit 'authenticate:unauthenticate', {}, () ->
            $rootScope.rootStatus = 'login'
            $rootScope.rootUser   = {}
    ]
