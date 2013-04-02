module.exports = (app) ->

  app.get GLOBAL.apiSubDir + '/users', (req, res) ->
    res.jsonAPIRespond({foo: 'bar'})


