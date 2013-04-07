###
  Testing proper parroting of API requests made via socket.io
  & http to same route-handlers
###

config      = require '../../server/config/config'
buster      = require 'buster'
_           = require 'underscore'
routeParrot = require config.appRoot + 'server/components/routeParrot'
sinon       = require 'sinon'


buster.testCase 'Module components/routeParrot',

  setUp: (done) ->
    done()
  tearDown: (done) ->
    done()

  '--> Modifies HTTP request to API': () ->

    nextSpy = this.spy()
    request =
      method: 'get'
      url: config.apiSubDir + '/users'
      headers: []
    response = {}
    next     = this.spy()

    routeParrot.http request, response, nextSpy

    #routeParrot.http modified this request by adding required attributes
    #to req & res objects
    buster.assert.called nextSpy
    buster.assert.isFunction response.jsonAPIRespond
    buster.assert.same('http', request.requestType)


  '--> Does not modify HTTP request that is not to API': () ->

    request =
      method: 'get'
      url: '/users' #<-- not prefixed with '/api'
      headers: []
    response = {}
    nextSpy  = this.spy()

    routeParrot.http request, response, nextSpy

    #routeParrot.http did not modify req & res objects
    buster.assert.called nextSpy
    buster.refute response.jsonAPIRespond
    buster.refute request.requestType


  '--> Modifies socket.io request to API': () ->

    #The client method is responsible for formatting the data object with
    #3 properties - method, url, headers
    request =
      data:
        method: 'get'
        url: '/users'
        headers: []
    #response will be an empty object
    response = {}
    callbackSpy  = this.spy()

    ###
      This is what we expect routeParrot.socketio to mutate request as
    ###
    mergedRequest = _.extend({
      method:  'get'
      url:     config.apiSubDir + '/users'
      headers: []
      requestType: 'socketio'
    }, request)

    routeParrot.socketio request, response, callbackSpy

    buster.assert.calledWith callbackSpy, mergedRequest, response
    buster.assert.isFunction response.jsonAPIRespond
    buster.assert.same('socketio', request.requestType)


  '--> Forwards socketio & http api requests to same route': () ->

    ###
    For the purposes of this test, we assume that if the 'url' property and the
    'method' property of the req object that's passed to app.router is identical,
    the router will pass the request to the same handler. This is a UNIT test not
    an integration test.
    ###

    #SETUP!
    httpNextSpy = this.spy()
    sioNextSpy  = this.spy()

    httpAPIRequest =
      method: 'get'
      url: config.apiSubDir + '/users'
      headers: []

    socketioAPIRequest =
      data:
        method: 'get'
        url: '/users'
        headers: []

    httpResponse = {}
    sioResponse  = {}

    #GO!
    routeParrot.http httpAPIRequest, httpResponse, httpNextSpy
    routeParrot.socketio socketioAPIRequest, sioResponse, sioNextSpy

    #TEST!
    buster.assert.called httpNextSpy
    buster.assert.called sioNextSpy
    buster.assert.same httpAPIRequest.url, sioNextSpy.args[0][0].url, config.apiSubDir + '/users'




