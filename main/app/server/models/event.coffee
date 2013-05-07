# event model

orm = require '../components/oRM'
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

  #  employeeUid:
  #    type: SEQ.STRING
  #    validate:
  #      isUUID: 4
  #      notNull: true

  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'hasMany'
    model: 'employee'
  ,
    relation: 'hasMany'
    model: 'submission'
  ]
  options:
    paranoid: true
