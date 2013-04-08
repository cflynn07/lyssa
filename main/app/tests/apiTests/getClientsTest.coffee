###
  Tests anticipated responses for GET requests to /users api
  resource
###

buster     = require 'buster'
config     = require '../../server/config/config'
express    = require 'express.io'
getClients = require config.appRoot + 'server/controllers/api/clients/getClients'
ORM        = require config.appRoot + 'server/components/orm'

sequelize = ORM.setup()
app = express().http().io()

client = ORM.model 'client'

#Bind the routes
getClients(app)


buster.testCase 'API GET ' + config.apiSubDir + '/clients',
  setUp: (done) ->

    this.request =
      url:          config.apiSubDir + '/clients'
      method:       'GET'
      headers:      []
      requestType:  'http'
      session:      {}
    this.response =
      render:         this.spy()
      end:            this.spy()
      trim:           this.spy()
      jsonAPIRespond: this.spy()

    done()
  tearDown: (done) ->
    done()

  '--> GET /clients exists & rejects unauthorized request': (done) ->

    this.response.jsonAPIRespond = done (response) ->
      buster.refute.called next
      buster.assert.same JSON.stringify(response), JSON.stringify(config.errorResponse(401))

    next = this.spy()
    app.router this.request, this.response, next

  '--> GET /clients/:id exists & rejects unauthorized request': (done) ->

    this.request.url = config.apiSubDir + '/clients/10'
    this.response.jsonAPIRespond = done (response) ->
      buster.refute.called next
      buster.assert.same JSON.stringify(response), JSON.stringify(config.errorResponse(401))

    next = this.spy()
    app.router this.request, this.response, next

  '--> GET /clients "super_admin" returns all clients': (done) ->

    this.request.session =
      user:
        type: 'super_admin'
    next = this.spy()
    _this = this

    #known number of example clients in our test database
    expectedNumClientsInDB = 3

    client.findAll().success (clients) ->

      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isArray result.response

        buster.assert.same expectedNumClientsInDB, result.response.length
        buster.assert.same clients.length, result.response.length
        buster.assert.same JSON.stringify(clients), JSON.stringify(result.response)

        buster.refute.called next

      app.router _this.request, _this.response, next

  '--> GET /clients "client_super_admin" returns user client': (done) ->

    testClientId = 1

    this.request.session =
      user:
        type: 'client_super_admin'
        clientId: testClientId
    next = this.spy()
    _this = this


    client.find(testClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)
        buster.assert.same testClientId, result.response.id

        buster.refute.called next

      app.router _this.request, _this.response, next


  '--> GET /clients "client_admin" returns user client': (done) ->

    testClientId = 1

    this.request.session =
      user:
        type: 'client_admin'
        clientId: testClientId
    next = this.spy()
    _this = this


    client.find(testClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)
        buster.assert.same testClientId, result.response.id

        buster.refute.called next

      app.router _this.request, _this.response, next


  '--> GET /clients "client_delegate" returns user client': (done) ->

    testClientId = 1

    this.request.session =
      user:
        type: 'client_delegate'
        clientId: testClientId
    next = this.spy()
    _this = this


    client.find(testClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)
        buster.assert.same testClientId, result.response.id

        buster.refute.called next

      app.router _this.request, _this.response, next

  '--> GET /clients "client_auditor" returns user client': (done) ->

    testClientId = 1

    this.request.session =
      user:
        type: 'client_auditor'
        clientId: testClientId
    next = this.spy()
    _this = this


    client.find(testClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)
        buster.assert.same testClientId, result.response.id

        buster.refute.called next

      app.router _this.request, _this.response, next

  '//--> ': (done) ->

