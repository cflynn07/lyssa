# exerciseTemplate model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:   SEQ.INTEGER
    name: SEQ.STRING
    type: SEQ.ENUM 'full', 'mini'

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
    model:    'client'
#  ,
#    relation: 'belongsTo'
#    model:    'employee'
  ]
  options:
    paranoid: true
