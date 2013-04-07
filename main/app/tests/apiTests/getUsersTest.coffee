###
  Tests anticipated responses for GET requests to /users api
  resource
###


buster   = require 'buster'
execSync = require 'exec-sync'
config   = require '../../server/config/config'
express  = require 'express.io'
getUsers = require config.appRoot + 'server/controllers/api/users/getUsers'

ORM      = require config.appRoot + 'server/components/orm'
sequelize = ORM.setup()
#sequelize.sync force: true


app = express().http().io()

#bind routes
getUsers(app)

buster.testCase 'API GET /users',

  setUp: (done) ->
    console.log '1'
    #Okay this works for loading up a database...
    mysql = '/usr/local/mysql/bin/mysql'

    console.log mysql + ' -u root lyssa < ' + config.appRoot + 'tests/apiTests/lyssa.sql'

    output = execSync mysql + ' -u root lyssa < ' + config.appRoot + 'tests/apiTests/lyssa.sql'
    console.log '2'

    this.request =
      url:      '/api/users'
      method:   'GET'
      headers:  []
    this.response =
      render:         this.spy()
      end:            this.spy()
      trim:           this.spy()
      jsonAPIRespond: this.spy()

    done()
  tearDown: (done) ->
    done()


  '--> GET /users exists': () ->

    next = this.spy()
    app.router this.request, this.response, next
    buster.refute.called next


  '--> GET /users/:id exists': () ->

    this.request.url = '/api/users/10'

    next = this.spy()
    app.router this.request, this.response, next
    buster.refute.called next

  '//GET /api/users "super_admin" returns all users': () ->
    return
  '//GET /api/users "client_super_admin" returns all users for given client': () ->
    return
  '//GET /api/users "client_admin" returns all users for given client': () ->
    return
  '//GET /api/users "client_delegate" returns all users for given client': () ->
    return
  '//GET /api/users "client_auditor" returns all users for given client': () ->
    return
