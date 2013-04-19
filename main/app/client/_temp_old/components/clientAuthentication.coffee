define [
  'cs!components/conn'
  'cs!models/user'
  'underscore'

], (
  conn
  User
  _
) ->

  authenticate: (email, password, callback) ->
    conn.io.emit 'authenticate:authenticate',
      email:    email
      password: password,
      (result) ->
        if !result.success? || !result.success || !result.user?
          callback false
        else
          User.set _.extend({authenticated: true}, result.user)

          callback true

  unauthenticate: () ->
    conn.io.emit 'authenticate:unauthenticate', {}, (response) ->
      if response
        User.clear()
