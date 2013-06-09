define [
], (
) ->

  (Module) ->
    Module.factory 'authenticate', ['$rootScope', 'socket', 'apiRequest'
    ($rootScope, socket, apiRequest) ->

      factory =
        authenticate: (user) ->
          $rootScope.rootStatus   = 'authenticated'
          $rootScope.rootUser     = user
          $rootScope.rootEmployee = {}

          apiRequest.get 'employee', [user.uid], {}, (response) ->
            if response.code == 200
              $rootScope.rootEmployee = response.response.data
                #$rootScope.rootEmployee = user
                #return

        unauthenticate: () ->

          socket.emit 'authenticate:unauthenticate', {}, () ->
            $rootScope.rootStatus = 'login'
            $rootScope.rootUser   = {}
            #$rootScope.resourcePool           = {}
            #$rootScope.resourceCollectionPool = {}
    ]
