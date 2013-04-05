###
  Test authentication module
###

appDir = '../../'
buster  = require 'buster'
_       = require 'underscore'
apiAuth = require appDir + 'server/components/apiAuth'


#Trying the BDD style of testing
buster.testCase 'Module components/apiAuth',

  setUp: (done) ->
    done()
  tearDown: (done) ->
    done()

  'blocks unauthenticated http request': ->

    request =
      requestType: 'http'
      session: {}
    response =
      jsonAPIRespond: this.spy()

    router = this.spy()
    next   = this.spy()

    apiAuth(request, response, next, router)

    buster.refute.called callback
    buster.assert.calledOnceWith response.jsonAPIRespond,
      error: 'Unauthorized'
      code: 401

  'blocks unauthenticated socketio request': ->

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


  'allows authenticated http request': ->

    request =
      requestType: 'http'
      session:
        user: true
    response =
      jsonAPIRespond: this.spy()
    callback = this.spy()

    apiAuth(request, response, callback)

    buster.assert.called callback
    buster.refute.called response.jsonAPIRespond

  'allows authenticated socketio request': ->

    request =
      requestType: 'socketio'
      session:
        user: true
    response =
      jsonAPIRespond: this.spy()
    callback = this.spy()

    apiAuth(request, response, callback)

    buster.assert.called callback
    buster.refute.called response.jsonAPIRespond







