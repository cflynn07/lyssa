# submission model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:             SEQ.INTEGER

  relations:
    belongsTo: 'event'
    #hasMany: ''
  options: {}
