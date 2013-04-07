# revision model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:            SEQ.INTEGER
    changeSummary: SEQ.TEXT
    scope:         SEQ.TEXT
  relations: [
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
