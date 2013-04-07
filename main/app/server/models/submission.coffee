# submission model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id: SEQ.INTEGER
  relations: [
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
