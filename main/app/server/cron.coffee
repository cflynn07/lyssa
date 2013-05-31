require('./config/envGlobals')(GLOBAL)

config         = require './config/config'
twilioClient   = require './config/twilioClient'
redisClient    = require('./config/redis').createClient()
ORM            = require('./components/oRM')
sequelize      = ORM.setup()
schedule       = require 'node-schedule'
_              = require 'underscore'
activityInsert = require config.appRoot + 'server/components/activityInsert'


express = require 'express.io'
pub     = require('./config/redis').createClient()
sub     = require('./config/redis').createClient()
store   = require('./config/redis').createClient()
redisStore = require('./config/redis').createStore()

app = express().http().io()
app.io.set 'store',
  new express.io.RedisStore
    redis: require 'redis'
    redisPub: pub
    redisSub: sub
    redisClient: store



configureEventJob = (eventObj) ->
  #console.log eventObj.uid
  console.log '------'
  console.log eventObj.name
  console.log eventObj.dateTime

  events[eventObj.uid] = schedule.scheduleJob (new Date(eventObj.dateTime)), () ->
    console.log 'scheduleJob'
    console.log eventObj.name

    activityInsert {
      type:      'eventInitialized'
      eventUid:  eventObj.uid
      clientUid: eventObj.clientUid
    }, app

    twilioClient.sendSms {
      to:   '7745734580'
      from: '6172507514'
      body: 'Scheduler Test Fire: ' + eventObj.name
    }, (error, message) ->
      #console.log arguments

    delete events[eventObj.uid]
    console.log 'events.length == ' + Object.getOwnPropertyNames(events).length

  console.log 'events.length == ' + Object.getOwnPropertyNames(events).length



#Hash of all events stored in memory
events = {}


#When initializing, iterate over all events and set up timers for them
event = ORM.model 'event'
event.findAll(
  where: ['dateTime >= NOW()']
).success (events) ->

  for item in events
    ((item) ->

      configureEventJob(item)

    )(item)




###
twilioClient.sendSms {
  to:   '7745734580'
  from: '6172507514'
  body: 'CobarSystems Themis test message 123 -- server'
}, (error, message) ->
  console.log arguments
###



redisClient.subscribe 'eventCronChannel', () ->
redisClient.on 'message', (channel, message) ->

  if channel == 'eventCronChannel'

    event.find(
      where:
        uid: message
    ).success (eventInstance) ->

      if !eventInstance
        return

      if !_.isUndefined(events[eventInstance.uid]) && _.isFunction(events[eventInstance.uid].cancel)
        events[eventInstance.uid].cancel()

      ((item) ->

        configureEventJob(item)

      )(eventInstance)












