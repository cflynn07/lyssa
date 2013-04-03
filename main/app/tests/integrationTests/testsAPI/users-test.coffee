appDir  = '../../../'
express = require 'express.io' #appDir + 'server/app'
users   = require appDir + 'server/controllers/api/users'
orm     = require appDir + 'server/components/orm'


orm.setup()
console.log orm.model 'dictionary'


app = express().http().io()


buster = require 'buster'

buster.testCase 'API - /users collection',

  setUp: (done) ->

    #this.timeout = 2000

    done()
  tearDown: () ->

    #done()

  '//GET /users - returns something': (done) ->

    buster.assert(true)
    done()

    return



    done(() ->
      buster.assert.equals(1, 1)
    )

    return
    request =
      session:
        user: true
      method: 'get'
      url: '/api/users'
      headers: []

    response =
      jsonAPIRespond: done (args) ->
        buster.assert.equals args, {foo: 'bar'}

    app.router request, response



  '//GET /users/5 - returns something': ->

    request =
      session:
        user: true
      method: 'get'
      url: '/api/users/5'
      headers: []

    response =
      jsonAPIRespond: this.spy()

    callback = this.spy()

    app.router request, response, callback

    buster.assert.calledWith response.jsonAPIRespond,
      foo: 'bar2'
