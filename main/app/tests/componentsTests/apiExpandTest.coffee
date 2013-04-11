###
  Test API expansion module
###

config    = require '../../server/config/config'
buster    = require 'buster'
_         = require 'underscore'
apiExpand = require config.appRoot + 'server/components/apiExpand'
ORM       = require config.appRoot + '/server/components/orm'
sequelize = ORM.setup()
async     = require 'async'


buster.testCase 'Module components/apiExpand',

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

  # -------------------------------------------
  '--> API request without expand parameter succeeds': (done) ->

    _this    = this

    testClientId = 2
    #testClientExpectedNumEmployees = 2

    client = ORM.model 'client'
    resourceQueryParams =
      method: 'findAll'
      find:
        where:
          id: testClientId

    #this.request.apiExpand = [{
    #  resource: 'employees'
    #}]

    _this.response.jsonAPIRespond = done (apiResponse) ->

      buster.assert.isObject apiResponse
      buster.assert.same apiResponse.code, 200

      buster.assert.isObject apiResponse.response
      buster.refute.isArray apiResponse.response.employees


    #Run test
    apiExpand this.request, this.response, client, resourceQueryParams


  # -------------------------------------------
  '--> Single response object expands to one associated resource': (done) ->

    _this    = this

    testClientId = 2
    testClientExpectedNumEmployees = 2


    client = ORM.model 'client'
    resourceQueryParams =
      method: 'findAll'
      find:
        where:
          id: testClientId


    this.request.apiExpand = [{
      resource: 'employees'
    }]


    _this.response.jsonAPIRespond = done (apiResponse) ->

      buster.assert.isObject apiResponse
      buster.assert.same apiResponse.code, 200

      buster.assert.isObject apiResponse.response
      buster.assert.isArray apiResponse.response.employees
      buster.assert.same apiResponse.response.employees.length, testClientExpectedNumEmployees


    #Run test
    apiExpand this.request, this.response, client, resourceQueryParams






  # -------------------------------------------
  '//--> Single response expands to two associations at one level': (done) ->
    done()
  # -------------------------------------------
  '//--> Single response expands to three associations at one level': (done) ->
    done()


  # -------------------------------------------
  '//--> Plural response expands to one associations at one level': (done) ->
    done()
  # -------------------------------------------
  '//--> Plural response expands to two associations at one level': (done) ->
    done()
  # -------------------------------------------
  '//--> Plural response expands to three associations at one level': (done) ->
    done()


  # -------------------------------------------
  '//--> Single response expands to multiple associations at two levels': (done) ->
    done()
  # -------------------------------------------
  '//--> Plural response expands to multiple associations at two levels': (done) ->
    done()


  # -------------------------------------------
  '//--> Single response expands to multiple associations at three levels': (done) ->
    done()
  # -------------------------------------------
  '//--> Plural response expands to multiple associations at three levels': (done) ->
    done()


  # -------------------------------------------
  '//--> Circular expansion returns error': (done) ->
    done()
  # -------------------------------------------
  '//--> Unknown associations returns error': (done) ->
    done()
  # -------------------------------------------
  '//--> Malformed "expand" parameter returns error': (done) ->
    done()









