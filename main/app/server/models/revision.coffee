# revision model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:            SEQ.INTEGER
    changeSummary: SEQ.TEXT
    scope:         SEQ.TEXT
  relations:
    belongsTo: 'template'
    belongsTo: 'client'
    belongsTo: 'employee'
    hasMany: 'group'
  options:
    paranoid: true
