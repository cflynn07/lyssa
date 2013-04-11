# employee model

config = require '../config/config'
orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:        SEQ.INTEGER


    identifier: SEQ.STRING
    firstName:  SEQ.STRING
    lastName:   SEQ.STRING
    email:      SEQ.STRING
    phone:      SEQ.STRING

    #Migrated from users model
    username: SEQ.STRING
    password: SEQ.STRING
    type:     SEQ.ENUM config.authCategories




    clientUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true




  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'hasMany'
    model: 'template'

  ,
    relation: 'hasMany'
    model: 'revision'
  ,
    relation: 'hasMany'
    model: 'event'
  ,
    relation: 'hasMany'
    model: 'submission'
  ]
  options:
    paranoid: true
