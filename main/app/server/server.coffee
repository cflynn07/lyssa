fs      = require 'fs'
express = require 'express.io'
path    = require 'path'
config  = require './config/config'

#If we didn't get to server.js from bootstrap.js
if !GLOBAL.asset_hash?
  GLOBAL.asset_hash = 'main'

#Read dotCloud ENV file if exists
try
  GLOBAL.env = JSON.parse fs.readFileSync '/home/dotcloud/environment.json', 'utf-8'
catch error
  GLOBAL.env = false

#set up orm
require('./components/orm').setup()

###
if GLOBAL.env
  require('nodetime').profile
    accountKey: '3e685ab0740eddb9a958f950a66bd728df2f1cca'
    appName:    'Lyssa - Production'
else
  require('nodetime').profile
    accountKey: '3e685ab0740eddb9a958f950a66bd728df2f1cca'
    appName:    'Lyssa - Development'
###



#redis clients
pub   = require('./config/redis').createClient()
sub   = require('./config/redis').createClient()
store = require('./config/redis').createClient()
redisStore = require('./config/redis').createStore()
app = express().http().io()
GLOBAL.app = app

app.io.set 'store',
  new express.io.RedisStore
    redis: require 'redis'
    redisPub: pub
    redisSub: sub
    redisClient: store

#app.io.enable('browser client etag')
app.io.set 'log level', 3
app.io.set 'transports', [
# 'websocket'
# 'flashsocket'
  'htmlfile'
  'xhr-polling'
  'jsonp-polling'
]

app.configure () ->

  app.use express.compress()
  app.disable 'x-powered-by'
  app.set 'port', process.env.PORT || 8080
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'ejs'
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session
    secret: 'c9d7732c0de118325e6de4582b37a4e9'
    store:  redisStore

  #Route parrot middleware
  #match api requests from socket.io & http to same handlers by modifying
  #req & res objects
  app.use require('./components/routeParrot').http
  app.use app.router

  app.configure 'production', () ->
    maxAge = 31536000000
    app.use express.static path.join(__dirname, '../client'), { maxAge: maxAge }

  app.configure 'development', () ->
    maxAge = 0 #Disable caching in development
    app.use express.static path.join(__dirname, '../client'), { maxAge: maxAge }
    app.use express.errorHandler()


#API Requests
app.io.route 'apiRequest', (req) ->
  require('./components/routeParrot').socketio req, {}, (req, res) ->
    app.router req, res, () ->
      req.io.respond
        code: 404
        error: 'not found'


#Mount all controllers (API & Regular)
require('./components/controllers')(app)


app.listen app.get 'port'
console.log 'server listening on port: ' + app.get 'port'
