# event model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:       SEQ.INTEGER
    name:     SEQ.STRING
    dateTime: SEQ.DATE

    clientUid:
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
    model: 'employee'
  ,
    relation: 'hasMany'
    model: 'submission'
  ]
  options:
    paranoid: true
