_      = require 'underscore'
DB     = require '../config/database'
bcrypt = require 'bcrypt'
mandrill = require('node-mandrill')('0n4PjhB09Eboo0BxH7Hdbw')


Client  = DB.Client
User    = DB.User
Order   = DB.Order
Comment = DB.Comment






retrieveUsers = (req) ->
  if !req.session.user? or req.session.user.type is not 'admin'
    req.io.respond
      success: false
    return

  DB.Client.find(req.session.user.client_id).success (client) ->

    client.getUsers(
      attributes: [
        'client_id'
        'created_at'
        'deleted_at'
        'email'
        'first_name'
        'id'
        'last_name'
        'type'
        'updated_at'
      ]
    ).success (users) ->

      console.log users

      req.io.respond
        success: true
        users: users


addUser = (req) ->
  if !req.session.user? or req.session.user.type is not 'admin'
    req.io.respond
      success: false
    return

  bcrypt.genSalt 12, (err, salt) ->
    bcrypt.hash req.data.temporary_password, salt, (err, hash) ->
      DB.User.create(
        client_id: req.session.user.client_id
        first_name: req.data.first_name
        last_name: req.data.last_name
        email: req.data.email
        password: hash
        type: 'user'
      ).success () ->

        req.io.respond
          success: true

        mandrill '/messages/send', {
            message:
              to: [
                name: req.data.first_name + ' ' + req.data.last_name
                email: req.data.email
              ]
              from_email: 'no-reply@voxtracker.com'
              from_name: 'VoxTracker'
              subject: req.session.user.first_name + ' ' + req.session.user.last_name + ' has created a VoxTracker account for you'
              text: req.session.user.first_name + ' ' + req.session.user.last_name + ' has created a VoxTracker for you. Your username is your email (' + req.data.email + ') and your temporary password is: "' + req.data.temporary_password + '". Sign in at http://app.voxtracker.com/'
          }, (error, response) ->
            console.log arguments



module.exports = (app) ->
  app.io.route 'admin',
    retrieveUsers:    retrieveUsers
    addUser:          addUser




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


