# dictionary model

orm = require '../components/oRM'
SEQ = orm.SEQ

module.exports =
  model:
    id:   SEQ.INTEGER
    name:
      type: SEQ.STRING
      validate:
        len: [2, 100]

    clientUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true
    dictionaryUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true

  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'belongsTo'
    model: 'dictionary'
  ]
  options:
    paranoid: true
