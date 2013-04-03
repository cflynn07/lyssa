appDir = '../../../'

buster      = require 'buster'
_           = require 'underscore'
routeParrot = require appDir + 'server/components/routeParrot'
sinon       = require 'sinon'



#Trying the BDD style of testing
buster.testCase 'routeParrot module',

  setUp: (done) ->
    done()
  tearDown: (done) ->
    done()

  'modifies http request to API': () ->

    routerSpy = this.spy()
    request =
      method: 'get'
      url: '/users'
      headers: []
    response = {}
    next = ->

    routeParrot.http request, response, next, routerSpy

    buster.assert.calledWith routerSpy,
      _.extend(request, requestType: 'http'),
      response,
      next
    buster.assert.isFunction response.jsonAPIRespond
    buster.assert.same('http', request.requestType)


  'does not modify http request that is not to API': () ->

    routerSpy = this.spy()
    request =
      method: 'get'
      url: '/users' #<-- not prefixed with '/api'
      headers: []
    response = {}
    next = ->

    routeParrot.http request, response, next, routerSpy

    buster.assert.calledWith routerSpy,
      request,
      response,
      next
    buster.assert.same(request.jsonAPIRespond, undefined)
    buster.assert.same('http', request.requestType)


  'modifies socketio request to API': () ->

    routerSpy = this.spy()
    request =
      data:
        method: 'get'
        url: '/users'
        headers: []
    response = {}
    next = ->

    #Expect request.data to be passed to router as this
    httpEmulatedRequest =
      method: request.data.method
      url: '/api' + request.data.url  #<-- make sure '/api' is prepended
      headers: []

    routeParrot.socketio request, response, next, routerSpy

    buster.assert.calledWith routerSpy,
      httpEmulatedRequest,
      response
      next

    buster.assert.isFunction response.jsonAPIRespond
    buster.assert.same('socketio', request.requestType)


  'forwards socketio & http api requests to same route': () ->

    httpSpy = this.spy()
    socketIOSpy = this.spy()

    httpAPIRequest =
      method: 'get'
      url: '/api/users'
      headers: []

    socketioAPIRequest =
      data:
        method: 'get'
        url: '/users'
        headers: []

    httpResponse = {}
    socketioResponse = {}
    httpNext = ->
    socketioNext = ->

    routeParrot.http(httpAPIRequest, httpResponse, httpNext, httpSpy)
    routeParrot.socketio(socketioAPIRequest, socketioResponse, socketioNext, socketIOSpy)

    buster.assert.same httpSpy.args[0][0].url, socketIOSpy.args[0][0].url, '/api/users'











