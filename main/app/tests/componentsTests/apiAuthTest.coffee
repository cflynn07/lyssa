###
  Test authentication module
###

config  = require '../../server/config/config'
buster  = require 'buster'
_       = require 'underscore'
apiAuth = require config.appRoot + 'server/components/apiAuth'


#Trying the BDD style of testing
buster.testCase 'Module components/apiAuth',

  setUp: (done) ->
    done()
  tearDown: (done) ->
    done()

  'Blocks unauthenticated HTTP request': ->

    request =
      requestType: 'http'
      session: {}
    response =
      jsonAPIRespond: this.spy()
    callback = this.spy()

    apiAuth(request, response, callback)

    buster.refute.called callback
    buster.assert.calledOnceWith response.jsonAPIRespond,
      error: 'Unauthorized'
      code: 401

  'Blocks unauthenticated socketio request': ->

    request =
      requestType: 'socketio'
      session: {}
    response =
      jsonAPIRespond: this.spy()
    callback = this.spy()

    apiAuth(request, response, callback)

    buster.refute.called callback
    buster.assert.calledOnceWith response.jsonAPIRespond,
      error: 'Unauthorized'
      code: 401


  'Allows authenticated "super_admin" HTTP request': ->

    request =
      requestType: 'http'
      session:
        user:
          type: 'super_admin'

    response =
      jsonAPIRespond: this.spy()
    callback = this.spy()

    apiAuth(request, response, callback)

    buster.assert.called callback
    buster.refute.called response.jsonAPIRespond

  'Allows authenticated "super_admin" socketio request': ->

    request =
      requestType: 'socketio'
      session:
        user:
          type: 'super_admin'

    response =
      jsonAPIRespond: this.spy()
    callback = this.spy()

    apiAuth(request, response, callback)

    buster.assert.called callback
    buster.refute.called response.jsonAPIRespond


  'Allows authenticated "client_super_admin" socketio & HTTP request': () ->

    ((_this) ->
      request =
        requestType: 'socketio'
        session:
          user:
            type: 'client_super_admin'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.assert.called callback
      buster.refute.called response.jsonAPIRespond
    )(this)

    ((_this) ->
      request =
        requestType: 'http'
        session:
          user:
            type: 'client_super_admin'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.assert.called callback
      buster.refute.called response.jsonAPIRespond
    )(this)


  'Allows authenticated "client_admin" socketio & HTTP request': () ->

    ((_this) ->
      request =
        requestType: 'socketio'
        session:
          user:
            type: 'client_admin'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.assert.called callback
      buster.refute.called response.jsonAPIRespond
    )(this)

    ((_this) ->
      request =
        requestType: 'http'
        session:
          user:
            type: 'client_admin'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.assert.called callback
      buster.refute.called response.jsonAPIRespond
    )(this)



  'Allows authenticated "client_delegate" socketio & HTTP request': () ->

    ((_this) ->
      request =
        requestType: 'socketio'
        session:
          user:
            type: 'client_delegate'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.assert.called callback
      buster.refute.called response.jsonAPIRespond
    )(this)

    ((_this) ->
      request =
        requestType: 'http'
        session:
          user:
            type: 'client_delegate'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.assert.called callback
      buster.refute.called response.jsonAPIRespond
    )(this)



  'Allows authenticated "client_auditor" socketio & HTTP request': () ->

    ((_this) ->
      request =
        requestType: 'socketio'
        session:
          user:
            type: 'client_auditor'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.assert.called callback
      buster.refute.called response.jsonAPIRespond
    )(this)

    ((_this) ->
      request =
        requestType: 'http'
        session:
          user:
            type: 'client_auditor'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.assert.called callback
      buster.refute.called response.jsonAPIRespond
    )(this)

  'Does not allow unrecognized authCategory': () ->

    ((_this) ->
      request =
        requestType: 'socketio'
        session:
          user:
            type: 'foobar'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.refute.called callback
      buster.assert.calledOnceWith response.jsonAPIRespond,
        error: 'Unauthorized'
        code: 401
    )(this)

    ((_this) ->
      request =
        requestType: 'http'
        session:
          user:
            type: 'foobar'
      response =
        jsonAPIRespond: _this.spy()
      callback = _this.spy()

      apiAuth(request, response, callback)

      buster.refute.called callback
      buster.assert.calledOnceWith response.jsonAPIRespond,
        error: 'Unauthorized'
        code: 401
    )(this)

