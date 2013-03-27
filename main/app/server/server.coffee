express         = require 'express.io'
path            = require 'path'
bcrypt          = require 'bcrypt'
async           = require 'async'
_               = require 'underscore'
fs              = require 'fs'
html_minifier   = require 'html-minifier'
redis           = require 'redis'
RedisStore      = require('connect-redis')(express)
csv             = require 'csv'



#If we didn't get to server.js from bootstrap.js
if !GLOBAL.asset_hash?
  GLOBAL.asset_hash = 'main'

#Read dotCloud ENV file if exists
GLOBAL.env = false
try
  GLOBAL.env = JSON.parse(fs.readFileSync('/home/dotcloud/environment.json', 'utf-8'))

DB              = require './config/database'
Sequelize       = require 'sequelize'



if GLOBAL.env? and GLOBAL.env.DOTCLOUD_DATA_REDIS_HOST?
  redisOptions =
    prefix: 'voxtracker:'
    host: GLOBAL.env.DOTCLOUD_DATA_REDIS_HOST
    port: GLOBAL.env.DOTCLOUD_DATA_REDIS_PORT
    pass: GLOBAL.env.DOTCLOUD_DATA_REDIS_PASSWORD
else
  redisOptions =
    prefix: ''
    host: 'localhost'
    port: 6379
    pass: ''

pub = redis.createClient redisOptions.port, redisOptions.host
pub.auth redisOptions.pass, () ->
sub = redis.createClient redisOptions.port, redisOptions.host
sub.auth redisOptions.pass, () ->
store = redis.createClient redisOptions.port, redisOptions.host
store.auth redisOptions.pass, () ->


app = express().http().io()


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
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use express.cookieParser()
  app.use express.session
    secret: 'fc5422223ed4bcfdf92ab07ba3c7baf6'
    store: new RedisStore redisOptions

  app.use app.router

  app.configure 'production', () ->
    maxAge = 31536000000
    app.use express.static path.join(__dirname, '../client'), { maxAge: maxAge }

  app.configure 'development', () ->
    maxAge = 0 #Disable caching in development
    app.use express.static path.join(__dirname, '../client'), { maxAge: maxAge }
    app.use express.errorHandler()

app.io.set 'store',
  new express.io.RedisStore
    redis: redis
    redisPub: pub
    redisSub: sub
    redisClient: store

#Single page application, only serve '/'
app.get '/', (req, res) ->
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






#das_body = { mandrill_events: '[{"event":"inbound","ts":1364371435,"msg":{"raw_msg":"Received: from mail-la0-f48.google.com (mail-la0-f48.google.com [209.85.215.48])\\n\\tby ip-10-244-148-99 (Postfix) with ESMTPS id 1D59C3A004B\\n\\tfor <inbound@app.voxtracker.com>; Wed, 27 Mar 2013 08:03:54 +0000 (UTC)\\nReceived: by mail-la0-f48.google.com with SMTP id fq13so14963051lab.21\\n        for <inbound@app.voxtracker.com>; Wed, 27 Mar 2013 01:03:52 -0700 (PDT)\\nX-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed\\/relaxed;\\n        d=google.com; s=20120113;\\n        h=mime-version:x-received:date:message-id:subject:from:to\\n         :content-type:x-gm-message-state;\\n        bh=sJu6RaJdkqKBmmcdlAWhMylUIZX0KHGTS\\/OgNZQFPdM=;\\n        b=JLTQj4stN9RpPdeynpMRPBDu\\/11EItCeu3w60jVYA4u3bMqP9g5CKb83HS5vq7nXnA\\n         KDdrLJnE+engEtk2g6dfr78zftHIqOIXtsUyRY4YNjHUh5p0qp7eX31Z6hjJCz+\\/Zo3r\\n         2lYCiKc4dpJYQsoX1+O1gvqlBAdFAO2fumpeT3VN2zj1JgYp6LJbycKDzAGxECWL20s5\\n         xo5EQ5MzqHXJ0iJn4xFpFoa\\/7aqOcyf0iUy5n3KO3MShwGcQBeM6XJ8e0aXdwqM3iHmU\\n         TCaixeFvhXAniTAALC8q4sG6mT4u3RmyFC0SwIZCjAJgILCnGC\\/DU9c5hUjWUZkrkTf3\\n         XQiw==\\nMIME-Version: 1.0\\nX-Received: by 10.112.145.35 with SMTP id sr3mr7183772lbb.51.1364371432820;\\n Wed, 27 Mar 2013 01:03:52 -0700 (PDT)\\nReceived: by 10.112.131.233 with HTTP; Wed, 27 Mar 2013 01:03:52 -0700 (PDT)\\nDate: Wed, 27 Mar 2013 04:03:52 -0400\\nMessage-ID: <CAEnmB1g4iE63jw=kc3DCT7Lo4ewOLYRV75-HBNSD4o+0pQ+dAQ@mail.gmail.com>\\nSubject: 67-Order Confirmed\\nFrom: Casey Flynn <casey.flynn@voxsupplychain.com>\\nTo: inbound@app.voxtracker.com\\nContent-Type: multipart\\/alternative; boundary=047d7b34380098651c04d8e37a21\\nX-Gm-Message-State: ALoCoQnBC\\/pcN5e1z+uiXIm3afstWoivBs25WpsGUgkSCoxadPdsgFe1HalDzgy6ZwMXMZ6lwEc7\\n\\n--047d7b34380098651c04d8e37a21\\nContent-Type: text\\/plain; charset=ISO-8859-1\\n\\nThis is a public comment test 123 abc\\n--X--\\n\\nWrite anything you want above this line.\\n\\n--047d7b34380098651c04d8e37a21\\nContent-Type: text\\/html; charset=ISO-8859-1\\n\\n<div dir=\\"ltr\\"><div style>This is a public comment test 123 abc<\\/div>--X--<br><br>Write anything you want above this line.<\\/div>\\n\\n--047d7b34380098651c04d8e37a21--","headers":{"Received":["from mail-la0-f48.google.com (mail-la0-f48.google.com [209.85.215.48]) by ip-10-244-148-99 (Postfix) with ESMTPS id 1D59C3A004B for <inbound@app.voxtracker.com>; Wed, 27 Mar 2013 08:03:54 +0000 (UTC)","by mail-la0-f48.google.com with SMTP id fq13so14963051lab.21 for <inbound@app.voxtracker.com>; Wed, 27 Mar 2013 01:03:52 -0700 (PDT)","by 10.112.131.233 with HTTP; Wed, 27 Mar 2013 01:03:52 -0700 (PDT)"],"X-Google-Dkim-Signature":"v=1; a=rsa-sha256; c=relaxed\\/relaxed; d=google.com; s=20120113; h=mime-version:x-received:date:message-id:subject:from:to :content-type:x-gm-message-state; bh=sJu6RaJdkqKBmmcdlAWhMylUIZX0KHGTS\\/OgNZQFPdM=; b=JLTQj4stN9RpPdeynpMRPBDu\\/11EItCeu3w60jVYA4u3bMqP9g5CKb83HS5vq7nXnA KDdrLJnE+engEtk2g6dfr78zftHIqOIXtsUyRY4YNjHUh5p0qp7eX31Z6hjJCz+\\/Zo3r 2lYCiKc4dpJYQsoX1+O1gvqlBAdFAO2fumpeT3VN2zj1JgYp6LJbycKDzAGxECWL20s5 xo5EQ5MzqHXJ0iJn4xFpFoa\\/7aqOcyf0iUy5n3KO3MShwGcQBeM6XJ8e0aXdwqM3iHmU TCaixeFvhXAniTAALC8q4sG6mT4u3RmyFC0SwIZCjAJgILCnGC\\/DU9c5hUjWUZkrkTf3 XQiw==","Mime-Version":"1.0","X-Received":"by 10.112.145.35 with SMTP id sr3mr7183772lbb.51.1364371432820; Wed, 27 Mar 2013 01:03:52 -0700 (PDT)","Date":"Wed, 27 Mar 2013 04:03:52 -0400","Message-Id":"<CAEnmB1g4iE63jw=kc3DCT7Lo4ewOLYRV75-HBNSD4o+0pQ+dAQ@mail.gmail.com>","Subject":"67-Order Confirmed","From":"Casey Flynn <casey.flynn@voxsupplychain.com>","To":"inbound@app.voxtracker.com","Content-Type":"multipart\\/alternative; boundary=047d7b34380098651c04d8e37a21","X-Gm-Message-State":"ALoCoQnBC\\/pcN5e1z+uiXIm3afstWoivBs25WpsGUgkSCoxadPdsgFe1HalDzgy6ZwMXMZ6lwEc7"},"text":"This is a public comment test 123 abc\\n--X--\\n\\nWrite anything you want above this line.\\n\\n","html":"<div dir=\\"ltr\\"><div style>This is a public comment test 123 abc<\\/div>--X--<br><br>Write anything you want above this line.<\\/div>\\n\\n","from_email":"casey.flynn@voxsupplychain.com","from_name":"Casey Flynn","to":[["inbound@app.voxtracker.com",null]],"subject":"67-Order Confirmed","spam_report":{"score":-0.7,"matched_rules":[{"name":"RCVD_IN_DNSWL_LOW","score":-0.7,"description":"RBL: Sender listed at http:\\/\\/www.dnswl.org\\/, low"},{"name":null,"score":0,"description":null},{"name":"listed","score":0,"description":"in list.dnswl.org]"},{"name":"HTML_MESSAGE","score":0,"description":"BODY: HTML included in message"}]},"email":"inbound@app.voxtracker.com","tags":[],"sender":null}}]' }





app.get '/inbound', (req, res) ->
  res.end ''

app.post '/inbound', (req, res) ->

  #console.log 'Mandrill'
  #console.log '--------'
  #console.log req.body
  #res.end 'ok'

  #req.body = das_body

  #console.log '-----body orig-----'
  #console.log req.body
  #console.log typeof req.body

  if typeof req.body is 'string'
    body = JSON.parse req.body
  else
    body = req.body

  #console.log '-----body json-----'
  #console.log body
  #console.log typeof body

  #console.log '-------body.mandrill_events------'
  #console.log body.mandrill_events
  #console.log 'type'
  #console.log typeof body.mandrill_events

  res.json
    success: true

  if body.mandrill_events?


    if typeof body.mandrill_events is 'string'
      body.mandrill_events = JSON.parse body.mandrill_events


    for event in body.mandrill_events

      #console.log '--event--'
      #console.log typeof event
      #console.log event


      if typeof event is 'string'
        event = JSON.parse event


      if event.event is 'inbound'

        #sub_parts[0] == order_id
        #sub_parts[1] == status
        sub_parts = event.msg.subject.split '-'

        #body_parts[0] == comment
        body_parts = event.msg.html.split '--X--'

        console.log 'sub_parts'
        console.log sub_parts

        console.log 'body_parts'
        console.log body_parts

        DB.Client.find(
          where:
            primary_email: event.msg.from_email
        ).success (client) ->

          if client
            DB.Order.find(
              where:
                id: sub_parts[0]
            ).success (order) ->

              if order

                order.status = sub_parts[1]
                order.save().success () ->

                  #strip html & trim whitespace
                  comment = body_parts[0].replace(/<[^>]*>/g, '').replace(/(^\s+|\s+$)/g, '')
                  console.log '--comment--'
                  console.log comment

                  if comment
                    DB.Comment.create
                      text: comment
                      order_id: order.id
                      client_id: client.id
                      hidden: false




#Handle CSV Uploads
app.post '/upload', (req, res) ->
  res.setHeader 'Content-Type', 'text/json'

  if !req.session.user?
    res.json
      success: false
    return

  if !req.files.files? || !req.files.files.length
    res.json
      success: false
      message: 'No Files Uploaded'
    return

  file = req.files.files[0]

  if file.mime is not 'text/csv'
    res.json
      success: false
      message: 'Invalid Upload Type'
    return








  #Find IDs of all shippers referenced in this csv
  client_shippers_ids = []
  orders = []

  chainer = new Sequelize.Utils.QueryChainer

  csv()
    .from.stream(fs.createReadStream(file.path))
    .to.path('/tmp/tempcsv.out')
    .transform((row) ->

      return row

    ).on('record', (row, index)->

      orders.push row
      #return
      #chainer.add DB.Order.create
      #  po_num:      Math.random() + ''
      #  description: Math.random() + ''
      #  requested_by: ''
      #  received:    false
      #  status:      'Purchase Order Received'

    ).on('end', (count)->
      #console.log 'end'
      #console.log count
      #chainer.run().success () ->
      #  console.log 'chainer fin'
      #  res.end
      #    success: true
      #    message: 'complete'

      methods = []
      for o in orders

        ((order)->
          methods.push (callback) ->

            DB.Client.find(
              where:
                primary_email: order[2]
            ).success (result) ->

              if result

                DB.Order.create(
                  po_num:       order[0] #Math.random() + ''
                  description:  order[1] #Math.random() + ''
                  requested_by: order[3]
                  received:     false
                  status:       'Purchase Order Received'
                  client_id_shipping:   result.values.id
                  client_id_recieving:  req.session.user.client_id
                ).success () ->
                  callback()

              else

                DB.Client.create(
                  name: order[2]
                  primary_email: order[2]
                ).success (client) ->

                  #TODO: Also create a user for this account
                   DB.Order.create(
                     po_num:       order[0]
                     description:  order[1]
                     requested_by: order[3]
                     status:       'Purchase Order Received'
                     client_id_shipping:   client.values.id
                     client_id_recieving:  req.session.user.client_id
                   ).success () ->
                     callback()

        )(o)

      async.series methods, () ->
        console.log 'async.series finished'
        res.json
          success: true
          message: 'complete'

    )









require('./routers/authenticate')(app)
require('./routers/admin')(app)
require('./routers/super_admin')(app)
require('./routers/orders')(app)
require('./routers/profile')(app)

app.listen app.get 'port'
console.log 'server listening on port: ' + app.get 'port'
