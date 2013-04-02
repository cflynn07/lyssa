director = require 'director'

router = new director.http.Router
  '/hello':
    '/:id':
      get: () ->
        console.log 'hello-get'
        console.log 'hello-get2'
        console.log arguments


req =
  method: 'get'
  url: '/hello/345'
  headers: []

router.dispatch req, '/hello', () ->
  console.log 'router callback'
