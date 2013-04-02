module.exports =
  route: '/users/?'
  callbacks:
    get: () ->
      console.log 'users get'

