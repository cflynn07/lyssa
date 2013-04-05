config = require '../../config/config'
apiSubDir = config.apiSubDir

module.exports = (app) ->

  app.get apiSubDir + '/users', (req, res) ->
    setTimeout ->
      res.jsonAPIRespond({foo: 'bar'})
    , 10

  app.get apiSubDir + '/users/:id', (req, res) ->
    res.jsonAPIRespond
      foo: 'bar2'
      stuff: req.params.id
