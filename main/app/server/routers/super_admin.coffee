_      = require 'underscore'
DB     = require '../config/database'
bcrypt = require 'bcrypt'



retrieveClients = (req) ->
  if !req.session.user? or !req.session.user.super_admin
    req.io.respond
      success: false
    return

  DB.Client.findAll(
    include: [
      'user'
    ]
  ).success (clients) ->

    res = []

    for c in clients
      ctemp = c.values
      ctemp.users = []
      for u in c.users
        delete u.password
        ctemp.users.push u
      res.push ctemp

    req.io.respond
      success: true
      clients: res

addClient = (req) ->
  if !req.session.user? or !req.session.user.super_admin
    req.io.respond
      success: false
    return

  DB.Client.create(
    name: req.data.name
  ).success () ->
    req.io.respond
        success: true



module.exports = (app) ->
  app.io.route 'super_admin',
    retrieveClients:    retrieveClients
    addClient:          addClient




#  app.io.route 'ready', (req) ->
#    t0 = Date.now()

#    if !req.session.last?
#      req.session.last = t0
#    else
#      req.session.last = req.session.now

#    req.session.now = t0
#    req.io.respond req.session

   # bcrypt.genSalt 16, (err, salt) ->
   #   bcrypt.hash "ILikeBunnies", salt, (err, hash) ->
   #     #console.log 'Password hashed: ' + (Date.now() - t0)
   #
   #     bcrypt.compare "ILikeBunnies", hash, (err, res) ->
   #       #console.log 'Finished: ' + res
   #       #console.log 'Password checked: ' +  (Date.now() - t0)


