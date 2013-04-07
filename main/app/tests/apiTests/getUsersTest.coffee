###
  Tests anticipated responses for GET requests to /users api
  resource
###

buster   = require 'buster'
config   = require '../../server/config/config'
express  = require 'express.io'
getUsers = require config.appRoot + 'server/controllers/api/users/getUsers'
ORM      = require config.appRoot + 'server/components/orm'

sequelize = ORM.setup()
#sequelize.sync force: true
app = express().http().io()

###
  bind routes
###
getUsers(app)

buster.testCase 'API GET /users',
  setUp: (done) ->

    this.request =
      url:          '/api/users'
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

  '--> GET /users exists': (done) ->

    this.response.jsonAPIRespond = done (response) ->
      buster.refute.called next
      buster.assert.same response, config.unauthorizedResponse

    next = this.spy()
    app.router this.request, this.response, next

  '--> GET /users/:id exists': (done) ->

    this.request.url = '/api/users/10'
    this.response.jsonAPIRespond = done (response) ->
      buster.refute.called next
      buster.assert.same response, config.unauthorizedResponse

    next = this.spy()
    app.router this.request, this.response, next

  '//GET /api/users "super_admin" returns all users': (done) ->

    this.request.session =
      user:
        type: 'super_admin'

    next = this.spy()

    app.router this.request, this.response, next
    done()
    return
  '//GET /api/users "client_super_admin" returns all users for given client': () ->
    return
  '//GET /api/users "client_admin" returns all users for given client': () ->
    return
  '//GET /api/users "client_delegate" returns all users for given client': () ->
    return
  '//GET /api/users "client_auditor" returns all users for given client': () ->
    return

