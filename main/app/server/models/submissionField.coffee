# submissionField model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:   SEQ.INTEGER
    name: SEQ.STRING

    clientUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true
    submissionGroupUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true

  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'belongsTo'
    model: 'submissionGroup'
  ]
  options:
    paranoid: true
