path        = require 'path'
fs          = require 'fs'
existsSync  = fs.existsSync
formidable  = require 'formidable'


module.exports = (app) ->
  app.post '/upload', (req, res) ->
    #