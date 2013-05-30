async     = require 'async'
_         = require 'underscore'
config    = require '../config/config'
uuid      = require 'node-uuid'
ORM       = require config.appRoot + 'server/components/oRM'
sequelize = ORM.setup()

activity = ORM.model 'activity'

module.exports = () ->

