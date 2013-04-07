# field model

config = require '../config/config'
orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:   SEQ.INTEGER
    name: SEQ.STRING
    type: SEQ.ENUM config.fieldTypes
  relations:
    belongsTo: 'group'
  options:
    paranoid: true
