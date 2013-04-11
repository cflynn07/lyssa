###
  Tests anticipated responses for GET requests to /users and api
  resource
###

buster     = require 'buster'
config     = require '../../server/config/config'
express    = require 'express.io'
getClients = require config.appRoot + 'server/controllers/api/clients/getClients'
ORM        = require config.appRoot + 'server/components/orm'
async      = require 'async'

sequelize  = ORM.setup()


uuid = require 'node-uuid'
console.log uuid.v4()


#employee.create({
#  clientId: 'a3b7b5d7-6ce8-4752-bcb1-7909d5348b36'
#  name: 'Foo'
#  identifier: 'Bar'
#}).success () ->
#  console.log 'done'
#  client.findAll({include: [employee]}).success (clients) ->
#    console.log JSON.parse JSON.stringify clients


#sequelize.sync force: true
return
app        = express().http().io()

client     = ORM.model 'client'

#Bind the routes
getClients(app)

buster.testCase 'API GET ' + config.apiSubDir + '/clients & ' + config.apiSubDir + '/clients/:id',
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

  '--> GET /clients "superAdmin" returns all clients': (done) ->

    this.request.session =
      user:
        type: 'superAdmin'
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


  '--> GET /clients "clientSuperAdmin" returns user client': (done) ->

    testClientId = 1

    this.request.session =
      user:
        type: 'clientSuperAdmin'
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


  '--> GET /clients "clientAdmin" returns user client': (done) ->

    testClientId = 1

    this.request.session =
      user:
        type: 'clientAdmin'
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


  '--> GET /clients "clientDelegate" returns user client': (done) ->

    testClientId = 1

    this.request.session =
      user:
        type: 'clientDelegate'
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

  '--> GET /clients "clientAuditor" returns user client': (done) ->

    testClientId = 1

    this.request.session =
      user:
        type: 'clientAuditor'
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

  '--> GET /clients/:id "superAdmin" returns any client [including other clientId]': (done) ->

    testClientId = 1
    testParamClientId = 2

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'superAdmin'
        clientId: testClientId
    next = this.spy()
    _this = this

    client.find(testParamClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same testParamClientId, returnClient.id, result.response.id
        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)

        buster.refute.same testClientId, result.response.id
        buster.refute.called next

      app.router _this.request, _this.response, next

  '--> GET /clients/:id "superAdmin" returns any client [including same clientId]': (done) ->

    testClientId = 1
    testParamClientId = 1

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'superAdmin'
        clientId: testClientId
    next = this.spy()
    _this = this

    client.find(testParamClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same testParamClientId, returnClient.id, result.response.id
        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)

        buster.assert.same testClientId, result.response.id
        buster.refute.called next

      app.router _this.request, _this.response, next

  '--> GET /clients/:id "superAdmin" returns 404 for client that does not exist': (done) ->

    testClientId = 1
    testParamClientId = 999

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'superAdmin'
        clientId: testClientId
    next = this.spy()
    _this = this

    client.find(testParamClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->

        buster.refute returnClient
        buster.assert.isObject result
        buster.assert.same result.code, 404
        buster.assert.same result.error, config.apiResponseCodes[404]

        buster.refute.called next

      app.router _this.request, _this.response, next

  '--> GET /clients/:id "clientSuperAdmin" returns 401 for :id that does not match clientId': (done) ->

    testClientId = 1
    testParamClientId = 5

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'clientSuperAdmin'
        clientId: testClientId
    next = this.spy()
    _this = this

    _this.response.jsonAPIRespond = done (result) ->

      buster.assert.isObject result
      buster.assert.same result.code, 401
      buster.assert.same result.error, config.apiResponseCodes[401]

      buster.refute.called next

    app.router _this.request, _this.response, next



  '--> GET /clients/:id "clientSuperAdmin" returns 200 & client for match': (done) ->

    testClientId = 1
    testParamClientId = 1

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'clientSuperAdmin'
        clientId: testClientId
    next = this.spy()
    _this = this

    client.find(testParamClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->

        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same testParamClientId, testClientId, returnClient.id, result.response.id
        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)

        buster.refute.called next

      app.router _this.request, _this.response, next

  '--> GET /clients/:id "clientAdmin" returns 401 for :id that does not match clientId': (done) ->

    testClientId = 1
    testParamClientId = 5

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'clientAdmin'
        clientId: testClientId
    next = this.spy()
    _this = this

    _this.response.jsonAPIRespond = done (result) ->

      buster.assert.isObject result
      buster.assert.same result.code, 401
      buster.assert.same result.error, config.apiResponseCodes[401]

      buster.refute.called next

    app.router _this.request, _this.response, next

  '--> GET /clients/:id "clientAdmin" returns 200 & client for match': (done) ->

    testClientId = 3
    testParamClientId = 3

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'clientAdmin'
        clientId: testClientId
    next = this.spy()
    _this = this

    client.find(testParamClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->

        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same testParamClientId, testClientId, returnClient.id, result.response.id
        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)

        buster.refute.called next

      app.router _this.request, _this.response, next

  '--> GET /clients/:id "clientDelegate" returns 401 for :id that does not match clientId': (done) ->

    testClientId = 1
    testParamClientId = 5

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'clientDelegate'
        clientId: testClientId
    next = this.spy()
    _this = this

    _this.response.jsonAPIRespond = done (result) ->

      buster.assert.isObject result
      buster.assert.same result.code, 401
      buster.assert.same result.error, config.apiResponseCodes[401]

      buster.refute.called next

    app.router _this.request, _this.response, next

  '--> GET /clients/:id "clientDelegate" returns 200 & client for match': (done) ->

    testClientId = 2
    testParamClientId = 2

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'clientDelegate'
        clientId: testClientId
    next = this.spy()
    _this = this

    client.find(testParamClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->

        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same testParamClientId, testClientId, returnClient.id, result.response.id
        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)

        buster.refute.called next

      app.router _this.request, _this.response, next


  '--> GET /clients/:id "clientAuditor" returns 401 for :id that does not match clientId': (done) ->

    testClientId = 1
    testParamClientId = 5

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'clientAuditor'
        clientId: testClientId
    next = this.spy()
    _this = this

    _this.response.jsonAPIRespond = done (result) ->

      buster.assert.isObject result
      buster.assert.same result.code, 401
      buster.assert.same result.error, config.apiResponseCodes[401]

      buster.refute.called next

    app.router _this.request, _this.response, next

  '--> GET /clients/:id "clientAuditor" returns 200 & client for match': (done) ->

    testClientId = 1
    testParamClientId = 1

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientId
    this.request.session =
      user:
        type: 'clientAuditor'
        clientId: testClientId
    next = this.spy()
    _this = this

    client.find(testParamClientId).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->

        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same testParamClientId, testClientId, returnClient.id, result.response.id
        buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)

        buster.refute.called next

      app.router _this.request, _this.response, next



























