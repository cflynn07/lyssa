fs              = require 'fs'
express         = require 'express.io'
path            = require 'path'

#If we didn't get to server.js from bootstrap.js
if !GLOBAL.asset_hash?
  GLOBAL.asset_hash = 'main'

#Read dotCloud ENV file if exists
try
  GLOBAL.env = JSON.parse(fs.readFileSync('/home/dotcloud/environment.json', 'utf-8'))
catch error
  GLOBAL.env = false

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
app.io.set('log level', 3)
app.io.set('transports', [
#  'websocket'
#  'flashsocket'
  'htmlfile'
  'xhr-polling'
  'jsonp-polling'
])

app.configure () ->
  #TODO store sessions in redis-store rather than memory
  app.use express.compress()
  app.disable 'x-powered-by'
  app.set 'port', process.env.PORT || 8080
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'ejs'


  app.use (req, res, next) ->
    console.log req.headers.host
    next()


  #TODO
  app.use express.favicon()

  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use express.cookieParser()
  app.use express.session
    secret: 'fc5422223ed4bcfdf92ab07ba3c7baf6'
    store:  redisStore

  #Standard requests
  app.use (req, res, next) ->
    res.jsonAPIRespond = (json) ->
      res.json json
    app.router(req, res, next)

  app.configure 'production', () ->
    maxAge = 31536000000
    app.use express.static path.join(__dirname, '../client'), { maxAge: maxAge }

  app.configure 'development', () ->
    maxAge = 0 #Disable caching in development
    app.use express.static path.join(__dirname, '../client'), { maxAge: maxAge }
    app.use express.errorHandler()





#API Requests
app.io.route 'apiRequest', (req) ->

  console.log req

  httpEmulatedRequest =
    method:   if req.data.method then req.data.method else 'get'
    url:      if req.data.url    then req.data.url    else '/api/'
    headers:  []

  response =
    jsonAPIRespond: (json) ->
      req.io.respond json

  app.router httpEmulatedRequest, response, () ->
    console.log 'socket.io api request'





#Regular Routes
app.get '/', require('./controllers/index')

#API Routes
app.get '/apple', (req, res) ->
  console.log 'apple route hit'
  res.jsonAPIRespond
    foo: 'bar'

###
  if res.io? and res.io.respond?
    res.io.respond 'okay!'
  else if res.end?
    res.end 'okay!'
###

app.listen app.get 'port'
console.log 'server listening on port: ' + app.get 'port'
