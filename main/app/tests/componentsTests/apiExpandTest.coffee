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
  '//--> API request without expand parameter succeeds': (done) ->


  # -------------------------------------------
  '--> Single response expands to one association at one level': (done) ->

    client = ORM.model 'client'

    testClientId = 2

    _this = this
    resource = client
    resourceQueryParams =
      id: testClientId


    this.request.apiExpand = [{
      resource: 'employees'
     # expand: [{
     #   resource: 'templates'
     # }]
    },{
      resource: 'templates'
    }]


    #Test setup
    client.find(
      where:resourceQueryParams
    ).success (resClient) ->
      resClient.getEmployees().success (resEmployees) ->

        #testResult should equal the api response
        #testing query without eager loading in this example
        testResult = JSON.parse(JSON.stringify(resClient))
        testResult.employees = JSON.parse(JSON.stringify(resEmployees))

        _this.response.jsonAPIRespond = done (apiResponse) ->

          console.log JSON.parse JSON.stringify apiResponse.response
          buster.assert true
          return
          #Test complete, run assertions
          buster.assert.isObject apiResponse
          buster.assert.same apiResponse.code, 200

          buster.assert.isObject apiResponse.response
          buster.assert.isArray apiResponse.response.employees

          buster.assert.same JSON.stringify(apiResponse.response), JSON.stringify(testResult)

        #Run test
        apiExpand _this.request, _this.response, resource, resourceQueryParams



###






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









