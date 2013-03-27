_      = require 'underscore'
DB     = require '../config/database'
bcrypt = require 'bcrypt'






update = (req) ->
  if !req.session.user?
    req.io.respond
      success: false
    return

  DB.User.find(req.session.user.id).success (user) ->

    if !req.data.first_name.length || !req.data.last_name.length || !req.data.email.length
      req.io.respond
        success: false
        message: 'please make sure you have supplied a value for first name, last name, and email'
      return

    if req.data.password? && req.data.password.length > 1 && req.data.password.length < 6
      req.io.respond
        success: false
        message: 'password must be at least 6 characters'
      return

    user.first_name = req.data.first_name
    user.last_name  = req.data.last_name
    user.email      = req.data.email

    save_user = () ->
      user.save().success () ->
        delete user.password
        req.session.user = user
        req.session.save () ->
          req.io.respond
            success: true
            user: user

    if req.data.password? && req.data.password.length > 1
      bcrypt.genSalt 12, (err, salt) ->
        bcrypt.hash req.data.password, salt, (err, hash) ->
          user.password = hash
          save_user()
    else
      save_user()



module.exports = (app) ->
  app.io.route 'profile',
    update:    update
