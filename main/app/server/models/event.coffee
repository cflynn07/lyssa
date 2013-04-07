# event model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:       SEQ.INTEGER
    name:     SEQ.STRING
    dateTime: SEQ.DATE
  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'hasMany'
    model: 'submission'
  ]
  options:
    paranoid: true
