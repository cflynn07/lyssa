# employee model

config = require '../config/config'
orm = require '../components/oRM'
SEQ = orm.SEQ

module.exports =
  model:
    id:        SEQ.INTEGER
    identifier:
      type: SEQ.STRING
      validate:
        isAlphanumeric: true
        len: [5, 100]
    firstName:
      type: SEQ.STRING
      validate:
    #    isAlphanumeric: true
        len: [1, 100]
    lastName:
      type: SEQ.STRING
      validate:
    #    isAlphanumeric: true
        len: [1, 100]
    email:
      type: SEQ.STRING
      validate:
        len: [5, 100]
    phone:
      type: SEQ.STRING
      validate:
        len: [5, 100]
    username:
      type: SEQ.STRING
      validate:
        isAlphanumeric: true
        len: [5, 100]
    password:
      type: SEQ.STRING
      validate:
        isAlphanumeric: true
        len: [5, 200]
    type: SEQ.ENUM config.authCategories

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
    model: 'eventParticipant'
  ,
    relation: 'hasMany'
    model: 'submission'
  ]
  options:
    paranoid: true
