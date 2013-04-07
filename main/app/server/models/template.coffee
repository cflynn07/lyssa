# exerciseTemplate model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:   SEQ.INTEGER
    name: SEQ.STRING
    type: SEQ.ENUM 'full', 'mini'
  relations: [
    relation: 'belongsTo'
    model:    'client'
  ,
    relation: 'belongsTo'
    model:    'employee'
  ]
  options:
    paranoid: true
