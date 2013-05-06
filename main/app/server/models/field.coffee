# field model

config = require '../config/config'
orm = require '../components/oRM'
SEQ = orm.SEQ

module.exports =
  model:
    id:   SEQ.INTEGER
    name:
      type: SEQ.STRING
      validate:
        len: [5, 50]
    type: SEQ.ENUM config.fieldTypes

    clientUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true
    groupUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true

  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'belongsTo'
    model: 'group'
  ]
  options:
    paranoid: true
