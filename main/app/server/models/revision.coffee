# revision model

orm = require '../components/oRM'
SEQ = orm.SEQ

module.exports =
  model:
    id:            SEQ.INTEGER
    changeSummary: SEQ.TEXT
    scope:         SEQ.TEXT

    clientUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true
    templateUid:
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
    model: 'template'
  ,
    relation: 'belongsTo'
    model: 'employee'
  ,
    relation: 'hasMany'
    model: 'group'
  ]
  options:
    paranoid: true
