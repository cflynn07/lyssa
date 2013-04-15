buster       = require 'buster'
config       = require '../../server/config/config'
express      = require 'express.io'
getTemplates = require config.appRoot + 'server/controllers/api/v1/templates/getTemplatesV1'
ORM          = require config.appRoot + 'server/components/orm'
async        = require 'async'
sequelize    = ORM.setup()
app          = express().http().io()

template     = ORM.model 'template'

#Bind the routes
getTemplates(app)



#Helpers
testCorrectMatch = (type, done) ->

  testClientUid      = '44cc27a5-af8b-412f-855a-57c8205d86f5'
  testParamClientUid = '44cc27a5-af8b-412f-855a-57c8205d86f5'

  this.request.url     = config.apiSubDir + '/v1/templates/' + testParamClientUid
  this.request.session =
    user:
      type:      type #'clientAuditor'
      clientUid: testClientUid
  next  = this.spy()
  _this = this

  client.find(
    where:
      uid: testParamClientUid
  ).success (returnClient) ->
    _this.response.jsonAPIRespond = done (apiResult) ->

      buster.assert.isObject apiResult
      buster.assert.same     apiResult.code, 200
      buster.assert.isObject apiResult.response

      buster.assert.same     testParamClientUid, testClientUid, returnClient.id, apiResult.response.id

      buster.refute.called   next

    app.router _this.request, _this.response, next


testCorrectMismatch = (type, done) ->
  testclientUid      = '111'
  testParamclientUid = '555'

  this.request.url     = config.apiSubDir + '/v1/templates/' + testParamclientUid
  this.request.session =
    user:
      type:      type #'clientAuditor'
      clientUid: testclientUid
  next = this.spy()
  _this = this

  _this.response.jsonAPIRespond = done (result) ->

    buster.assert.isObject result
    buster.assert.same     result.code, 401
    buster.assert.same     result.error, config.apiResponseCodes[401]
    buster.refute.called   next

  app.router _this.request, _this.response, next


testReturnCorrectClient = (type, done) ->
  testClientUid = '44cc27a5-af8b-412f-855a-57c8205d86f5'

  this.request.session =
    user:
      type:      type #'clientSuperAdmin'
      clientUid: testClientUid
  next  = this.spy()
  _this = this

  _this.response.jsonAPIRespond = done (apiResponse) ->

    buster.assert.isObject apiResponse
    buster.assert.same     apiResponse.code, 200

    buster.assert.isArray  apiResponse.response
    buster.assert.isObject apiResponse.response[0]
    buster.assert.same     apiResponse.response.length, 1

    buster.assert.same     testClientUid, apiResponse.response[0].uid

    buster.refute.called   next


  app.router _this.request, _this.response, next








buster.testCase 'API V1 GET ' + config.apiSubDir + '/v1/templates & ' + config.apiSubDir + '/v1/templates/:id',
  setUp: (done) ->

    this.request =
      url:          config.apiSubDir + '/v1/templates'
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


  '--> GET v1/templates exists & rejects unauthorized request': (done) ->

    this.response.jsonAPIRespond = done (apiResponse) ->
      buster.refute.called next
      buster.assert.same   JSON.stringify(apiResponse), JSON.stringify(config.errorResponse(401))

    next = this.spy()
    app.router this.request, this.response, next


  '--> GET v1/templates/:id exists & rejects unauthorized request': (done) ->

    this.request.url = config.apiSubDir + '/v1/templates/10'
    this.response.jsonAPIRespond = done (apiResponse) ->
      buster.refute.called  next
      buster.assert.same    JSON.stringify(apiResponse), JSON.stringify(config.errorResponse(401))

    next = this.spy()
    app.router this.request, this.response, next

###
  '--> GET v1/templates "superAdmin" returns all clients': (done) ->

    this.request.session =
      user:
        type: 'superAdmin'
    next = this.spy()
    _this = this

    #known number of example clients in our test database
    expectedNumClientsInDB = 3

    client.findAll().success (clients) ->

      _this.response.jsonAPIRespond = done (apiResponse) ->
        buster.assert.isObject apiResponse
        buster.assert.same     apiResponse.code, 200
        buster.assert.isArray  apiResponse.response

        buster.assert.same     expectedNumClientsInDB, apiResponse.response.length
        buster.assert.same     clients.length, apiResponse.response.length

        buster.refute.called   next

      app.router _this.request, _this.response, next


  '--> GET /v1/templates "clientSuperAdmin" returns user client': (done) ->
    testReturnCorrectClient.call(this, 'clientSuperAdmin', done)


  '--> GET /v1/templates "clientAdmin" returns user client': (done) ->
    testReturnCorrectClient.call(this, 'clientAdmin', done)


  '--> GET /templates "clientDelegate" returns user client': (done) ->
    testReturnCorrectClient.call(this, 'clientDelegate', done)


  '--> GET /templates "clientAuditor" returns user client': (done) ->
    testReturnCorrectClient.call(this, 'clientAuditor', done)


  '--> GET /templates/:uid "superAdmin" returns any client [including OTHER clientUid]': (done) ->

    testClientUid      = '44cc27a5-af8b-412f-855a-57c8205d86f5'
    testParamClientUid = '05817084-bc15-4dee-90a1-2e0735a242e1'

    this.request.url     = config.apiSubDir + '/v1/templates/' + testParamClientUid
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
      _this.response.jsonAPIRespond = done (apiResponse) ->

        buster.assert.isObject apiResponse
        buster.assert.same     apiResponse.code, 200
        buster.assert.isObject apiResponse.response

        buster.assert.same     testParamClientUid, returnClient.uid, apiResponse.response.uid

        buster.assert.isString apiResponse.response.uid
        buster.refute.same     testClientUid, apiResponse.response.uid
        buster.refute.called   next

      app.router _this.request, _this.response, next


  '--> GET /templates/:uid "superAdmin" returns any client [including SAME clientUid]': (done) ->

    testClientUid      = '05817084-bc15-4dee-90a1-2e0735a242e1'
    testParamClientUid = '05817084-bc15-4dee-90a1-2e0735a242e1'

    this.request.url     = config.apiSubDir + '/v1/templates/' + testParamClientUid
    this.request.session =
      user:
        type:      'superAdmin'
        clientUid: testClientUid
    next = this.spy()
    _this = this

    client.find(
      where:
        uid: testParamClientUid
    ).success (returnClient) ->

      _this.response.jsonAPIRespond = done (apiResponse) ->

        buster.assert.isObject apiResponse
        buster.assert.same     apiResponse.code, 200
        buster.assert.isObject apiResponse.response

        buster.assert.same     testParamClientUid, returnClient.uid, apiResponse.response.uid

        buster.assert.isString apiResponse.response.uid
        buster.assert.same     testClientUid, apiResponse.response.uid
        buster.refute.called   next

      app.router _this.request, _this.response, next


  '--> GET /templates/:uid "superAdmin" returns 404 for client that does not exist': (done) ->

    testclientUid      = 1
    testParamclientUid = 999

    this.request.url     = config.apiSubDir + '/v1/templates/' + testParamclientUid
    this.request.session =
      user:
        type:     'superAdmin'
        clientUid: testclientUid
    next = this.spy()
    _this = this


    _this.response.jsonAPIRespond = done (apiResult) ->

      buster.assert.isObject apiResult
      buster.assert.same     apiResult.code, 404
      buster.assert.same     apiResult.error, config.apiResponseCodes[404]
      buster.assert.same     JSON.stringify(apiResult.unknownUids), JSON.stringify(["999"])

      buster.refute.called   next

    app.router _this.request, _this.response, next


  '--> GET /templates/:id "clientSuperAdmin" returns 401 for :id that does not match clientUid': (done) ->
    testCorrectMismatch.call(this, 'clientSuperAdmin', done)


  '--> GET /templates/:id "clientSuperAdmin" returns 200 & client for match': (done) ->
    testCorrectMatch.call(this, 'clientSuperAdmin', done)


  '--> GET /templates/:id "clientAdmin" returns 401 for :id that does not match clientUid': (done) ->
    testCorrectMismatch.call(this, 'clientAdmin', done)


  '--> GET /templates/:id "clientAdmin" returns 200 & client for match': (done) ->
    testCorrectMatch.call(this, 'clientAdmin', done)


  '--> GET /templates/:id "clientDelegate" returns 401 for :id that does not match clientUid': (done) ->
    testCorrectMismatch.call(this, 'clientDelegate', done)


  '--> GET /templates/:id "clientDelegate" returns 200 & client for match': (done) ->
    testCorrectMatch.call(this, 'clientDelegate', done)


  '--> GET /templates/:id "clientAuditor" returns 401 for :id that does not match clientUid': (done) ->
    testCorrectMismatch.call(this, 'clientAuditor', done)


  '--> GET /templates/:id "clientAuditor" returns 200 & client for match': (done) ->
    testCorrectMatch.call(this, 'clientAuditor', done)
###




















