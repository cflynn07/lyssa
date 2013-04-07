# dictionary model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:             SEQ.INTEGER
    name:           SEQ.STRING
  relations:
    belongsTo: 'client'
    hasMany: 'dictionaryItem'
  options:
    paranoid: true
