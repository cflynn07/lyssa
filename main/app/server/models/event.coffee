# event model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:       SEQ.INTEGER
    name:     SEQ.STRING
    dateTime: SEQ.DATE
  relations:
    belongsTo: 'client'
    hasMany: 'submission'
  options:
    paranoid: true
