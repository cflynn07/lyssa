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

uuid       = require 'node-uuid'
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

        buster.refute.called next

      app.router _this.request, _this.response, next


  '--> GET /clients "clientSuperAdmin" returns user client': (done) ->

    testClientUid = '44cc27a5-af8b-412f-855a-57c8205d86f5'

    this.request.session =
      user:
        type: 'clientSuperAdmin'
        clientUid: testClientUid
    next = this.spy()
    _this = this


    client.find(
      where:
        uid: testClientUid
    ).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        #this will fail because apiExpand removes all 'id' properties
        #buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)
        buster.assert.same testClientUid, result.response.uid


        buster.refute.called next

      app.router _this.request, _this.response, next

  '--> GET /clients "clientAdmin" returns user client': (done) ->

    testClientUid = '44cc27a5-af8b-412f-855a-57c8205d86f5'

    this.request.session =
      user:
        type: 'clientAdmin'
        clientUid: testClientUid
    next = this.spy()
    _this = this


    client.find(
      where:
        uid: testClientUid
    ).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        #buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)
        buster.assert.same testClientUid, result.response.uid

        buster.refute.called next

      app.router _this.request, _this.response, next



  '--> GET /clients "clientDelegate" returns user client': (done) ->

    testClientUid = '44cc27a5-af8b-412f-855a-57c8205d86f5'

    this.request.session =
      user:
        type: 'clientDelegate'
        clientUid: testClientUid
    next = this.spy()
    _this = this


    client.find(
      where:
        uid: testClientUid
    ).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        #buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)
        buster.assert.same testClientUid, result.response.uid

        buster.refute.called next

      app.router _this.request, _this.response, next


  '--> GET /clients "clientAuditor" returns user client': (done) ->

    testClientUid = '44cc27a5-af8b-412f-855a-57c8205d86f5'

    this.request.session =
      user:
        type: 'clientAuditor'
        clientUid: testClientUid
    next = this.spy()
    _this = this


    client.find(
      where:
        uid: testClientUid
    ).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        #buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)
        buster.assert.same testClientUid, result.response.uid

        buster.refute.called next

      app.router _this.request, _this.response, next


  '--> GET /clients/:uid "superAdmin" returns any client [including OTHER clientUid]': (done) ->

    testClientUid = '44cc27a5-af8b-412f-855a-57c8205d86f5'
    testParamClientUid = '05817084-bc15-4dee-90a1-2e0735a242e1'

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientUid
    this.request.session =
      user:
        type: 'superAdmin'
        clientUid: testClientUid
    next = this.spy()
    _this = this

    client.find(
      where:
        uid: testParamClientUid
    ).success (returnClient) ->
      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same testParamClientUid, returnClient.uid, result.response.uid
        #buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)

        buster.assert.isString result.response.uid
        buster.refute.same testClientUid, result.response.uid
        buster.refute.called next

      app.router _this.request, _this.response, next


  '--> GET /clients/:uid "superAdmin" returns any client [including SAME clientUid]': (done) ->

    testClientUid = '05817084-bc15-4dee-90a1-2e0735a242e1'
    testParamClientUid = '05817084-bc15-4dee-90a1-2e0735a242e1'

    this.request.url     = config.apiSubDir + '/clients/' + testParamClientUid
    this.request.session =
      user:
        type: 'superAdmin'
        clientUid: testClientUid
    next = this.spy()
    _this = this

    client.find(
      where:
        uid: testParamClientUid
    ).success (returnClient) ->

      _this.response.jsonAPIRespond = done (result) ->
        buster.assert.isObject result
        buster.assert.same result.code, 200
        buster.assert.isObject result.response

        buster.assert.same testParamClientUid, returnClient.uid, result.response.uid
        #buster.assert.same JSON.stringify(returnClient), JSON.stringify(result.response)

        buster.assert.isString result.response.uid
        buster.assert.same testClientUid, result.response.uid
        buster.refute.called next

      app.router _this.request, _this.response, next
###
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



























