# field model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:      SEQ.INTEGER
    name:    SEQ.STRING
    ordinal: SEQ.INTEGER
  relations: [
    relation: 'belongsTo'
    model: 'revision'
  ,
    relation: 'hasMany'
    model: 'field'
  ]
  options:
    paranoid: true
