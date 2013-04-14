###
  Test API expansion module
###

config              = require '../../server/config/config'
testConstants       = require '../testConstants'
buster              = require 'buster'
_                   = require 'underscore'
apiPostVerifyFields = require config.appRoot + 'server/components/apiPostVerifyFields'
ORM                 = require config.appRoot + '/server/components/orm'
sequelize           = ORM.setup()
async               = require 'async'


buster.testCase 'Module components/apiPostVerifyFields',

  setUp: (done) ->


    done()
  tearDown: (done) ->
    done()

  # -------------------------------------------
  '//--> Returns code 400 & error message when required field is not present': (done) ->



