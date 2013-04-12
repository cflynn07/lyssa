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
      url:          config.apiSubDir + '/v1/clients'
      method:       'GET'
      headers:      []
      requestType:  'http'
      session:      {}
    #  apiExpand:    {}
    this.response =
      render:         this.spy()
      end:            this.spy()
      trim:           this.spy()
      jsonAPIRespond: this.spy()

    done()
  tearDown: (done) ->
    done()


  # -------------------------------------------
  '--> Returns single resource without "expand" parameter': (done) ->

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

      #should always be object not array
      buster.assert.isObject apiResponse.response

      for val, index of apiResponse.response
        #Assert there are no arrays or objects in the response object
        buster.refute.isObject val
        buster.refute.isArray val

    #Run test
    apiExpand this.request, this.response, client, resourceQueryParams


  # -------------------------------------------
  '--> Returns multiple resources without "expand" parameter': (done) ->

    _this    = this

    testClientId = 2
    #testClientExpectedNumEmployees = 2

    client = ORM.model 'client'
    resourceQueryParams =
      method: 'findAll'
      find: {}
      #  where:
      #    id: testClientId

    #this.request.apiExpand = [{
    #  resource: 'employees'
    #}]

    _this.response.jsonAPIRespond = done (apiResponse) ->

      buster.assert.isObject apiResponse
      buster.assert.same apiResponse.code, 200

      buster.assert.isArray apiResponse.response

      #make sure it didn't attach this...
      buster.refute.isArray apiResponse.response.employees


      for val, index in apiResponse.response
        for subVal of val
          #Assert there are no arrays or objects in the response object
          buster.refute.isObject subVal
          buster.refute.isArray subVal


    #Run test
    apiExpand this.request, this.response, client, resourceQueryParams


  # -------------------------------------------
  '--> Returns multiple resources without "expand" parameter': (done) ->
    done()
  # -------------------------------------------
  '--> Returns multiple resources without "expand" parameter': (done) ->
    done()
  # -------------------------------------------
  '--> Returns multiple resources without "expand" parameter': (done) ->
    done()


  # -------------------------------------------
  #'//--> Circular expansion returns error': (done) ->
  #  done()

  #'//--> Malformed "expand" parameter returns error': (done) ->
  #  done()






