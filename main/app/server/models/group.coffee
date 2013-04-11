# field model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:      SEQ.INTEGER
    name:    SEQ.STRING
    ordinal: SEQ.INTEGER

    clientUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true
    revisionUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true

  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'belongsTo'
    model: 'revision'
  ,
    relation: 'hasMany'
    model: 'field'
  ]
  options:
    paranoid: true
