# submission model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id: SEQ.INTEGER

    clientUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true
    eventUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true
    employeeUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true

  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'belongsTo'
    model: 'event'
  ,
    relation: 'belongsTo'
    model: 'employee'
  ,
    relation: 'hasMany'
    model: 'submissionGroup'
  ]
  options:
    paranoid: true
