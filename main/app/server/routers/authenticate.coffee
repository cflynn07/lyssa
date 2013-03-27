_       = require 'underscore'
DB      = require '../config/database'
bcrypt  = require 'bcrypt'


User = DB.User

status = (req) ->
  if req.session.user?
    req.io.respond _.extend
      authenticated: true,
      req.session.user
  else
    req.io.respond
      authenticated: false

authenticate = (req) ->

  #prevent DoS attacks
  if !req.data.email? || !req.data.password? || req.data.password.length > 70
    req.io.respond success: false
    return

  User.find
    where:
      email: req.data.email
  .success (user) ->
    if !user?
      req.io.respond success: false
    else
      bcrypt.compare req.data.password, user.password, (err, res) ->
        if res
          #Dont send hashed password
          delete user.password
          req.session.user = user

          #Hang out with the other cool super admins if you're a super admin
       #   if user.super_admin
       #     req.io.join 'super_admins'

          #Tell all the super cool admins a user just authenticated
       #   req.io.room('super_admins').broadcast 'user_authenticate', user

          req.session.save () ->
            req.io.respond success: true, user: user
        else
          req.io.respond success: false

unauthenticate = (req) ->

  delete req.session.user
  req.session.save () ->
    req.io.respond true


module.exports = (app) ->
  app.io.route 'authenticate',
    status:         status
    authenticate:   authenticate
    unauthenticate:  unauthenticate




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


