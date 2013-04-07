# employee model

config = require '../config/config'
orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:         SEQ.INTEGER
    identifier: SEQ.STRING
    firstName:  SEQ.STRING
    lastName:   SEQ.STRING
    email:      SEQ.STRING
    phone:      SEQ.STRING

    #Migrated from users model
    username: SEQ.STRING
    password: SEQ.STRING
    type:     SEQ.ENUM config.authCategories
  relations:
    belongsTo: 'client'
    hasMany:   'template'
    hasMany:   'revision'
    hasMany:   'event'
    hasMany:   'submission'
  options:
    paranoid: true
