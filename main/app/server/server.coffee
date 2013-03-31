#require('nodetime').profile
#  accountKey: '3e685ab0740eddb9a958f950a66bd728df2f1cca'
#  appName:    'Lyssa'


fs = require 'fs'

#If we didn't get to server.js from bootstrap.js
if !GLOBAL.asset_hash?
  GLOBAL.asset_hash = 'main'

#Read dotCloud ENV file if exists
try
  GLOBAL.env = JSON.parse(fs.readFileSync('/home/dotcloud/environment.json', 'utf-8'))
catch error
  GLOBAL.env = false




express         = require 'express.io'
path            = require 'path'
async           = require 'async'
html_minifier   = require 'html-minifier'




#redis clients
pub   = require('./config/redis').createClient()
sub   = require('./config/redis').createClient()
store = require('./config/redis').createClient()
redisStore = require('./config/redis').createStore()
app = express().http().io()


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

  #TODO
  app.use express.favicon()

  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use express.cookieParser()
  app.use express.session
    secret: 'fc5422223ed4bcfdf92ab07ba3c7baf6'
    store:  redisStore

  app.use app.router

  app.configure 'production', () ->
    maxAge = 31536000000
    app.use express.static path.join(__dirname, '../client'), { maxAge: maxAge }

  app.configure 'development', () ->
    maxAge = 0 #Disable caching in development
    app.use express.static path.join(__dirname, '../client'), { maxAge: maxAge }
    app.use express.errorHandler()




#Single page application, only serve '/'
app.get '/', (req, res) ->
  res.end('hi')
  async.map ['header', 'body', 'footer']
  ,(item, callback) ->
    res.render item,
      environment: app.settings.env
      asset_hash: GLOBAL.asset_hash,
      (err, html) ->
        callback err, html
  ,(err, results) ->
    html = results[1] + results[2]
    html = html_minifier.minify html,
      collapseWhitespace: true
      removeComments:     true
    #preseve comments in header
    head = html_minifier.minify results[0],
      collapseWhitespace: true
    html = head + html
    res.send html



#require('./routers/authenticate')(app)
#require('./routers/admin')(app)
#require('./routers/super_admin')(app)
#require('./routers/orders')(app)
#require('./routers/profile')(app)

app.listen app.get 'port'
console.log 'server listening on port: ' + app.get 'port'
