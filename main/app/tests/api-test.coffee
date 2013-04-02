buster  = require 'buster'
apiAuth = require '../server/components/apiAuth'

#Trying the BDD style of testing
buster.testCase 'Basic API authentication apiAuth module',

  setUp: (done) ->
    done()
  tearDown: (done) ->
    done()

  'Rejects unauthenticated': (done) ->
    setTimeout done () ->
      buster.assert(true)
    , 100

  'Permits authenticated': () ->

