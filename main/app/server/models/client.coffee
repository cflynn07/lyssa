# dictionary model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
  model:
    id:            SEQ.INTEGER
    name:          SEQ.STRING

    indentifier:
      type:        SEQ.STRING
      unique:      true

    address1:      SEQ.STRING
    address2:      SEQ.STRING
    address3:      SEQ.STRING
    city:          SEQ.STRING
    stateProvince: SEQ.STRING
    country:       SEQ.STRING
    telephone:     SEQ.STRING
    fax:           SEQ.STRING
  relations: [
    relation: 'hasMany'
    model: 'employee'
  ,
    relation: 'hasMany'
    model: 'template'
  ,
    relation: 'hasMany'
    model: 'dictionary'
  ,
    relation: 'hasMany'
    model: 'event'
  ]
  options:
    paranoid: true
