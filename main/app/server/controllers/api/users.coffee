config = require '../../config/config'
subDir = config.apiSubDir

module.exports = (app) ->

  app.get subDir + '/users', (req, res) ->

    setTimeout ->
      res.jsonAPIRespond({foo: 'bar'})
    , 10


  app.get subDir + '/users/:id', (req, res) ->
    res.jsonAPIRespond({foo: 'bar2'})


  app.post subDir + '/users', (req, res) ->
    res.jsonAPIRespond({foo: 'bar3'})


  app.put subDir + '/users', (req, res) ->
    res.jsonAPIRespond({foo: 'bar4'})


  app.delete subDir + '/users', (req, res) ->
    res.jsonAPIRespond({foo: 'bar5'})
