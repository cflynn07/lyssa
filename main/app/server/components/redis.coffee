redis      = require 'redis'
express    = require 'express.io'
redisStore = require('connect-redis')(express)

if GLOBAL.env? and GLOBAL.env.DOTCLOUD_DATA_REDIS_HOST?
  redisOptions =
    prefix: 'voxtracker:'
    host: GLOBAL.env.DOTCLOUD_DATA_REDIS_HOST
    port: GLOBAL.env.DOTCLOUD_DATA_REDIS_PORT
    pass: GLOBAL.env.DOTCLOUD_DATA_REDIS_PASSWORD
else
  redisOptions =
    prefix: ''
    host:   'localhost'
    port:   6379
    pass:   ''

createClient = () ->
  client = redis.createClient(redisOptions.port, redisOptions.host)
  client.auth redisOptions.pass, () ->
  return client

createStore = () ->
  store = new redisStore redisOptions

module.exports =
  createClient: createClient
  createStore: createStore
