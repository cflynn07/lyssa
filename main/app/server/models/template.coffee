# exerciseTemplate model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:                     SEQ.INTEGER
    name:                   SEQ.STRING
    objective:              SEQ.TEXT
    scopeRequirements:      SEQ.TEXT
    recoveryPointObjective: SEQ.INTEGER
    recoveryTimeObjective:  SEQ.INTEGER
    type:                   SEQ.ENUM 'full', 'mini'
    relations:
      belongsTo: 'client'
      belongsTo: 'employee'
    options: {}
