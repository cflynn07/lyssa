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
  relations:
    hasMany: 'employee'
    hasMany: 'template'
    hasMany: 'dictionary'
    hasMany: 'event'
  options:
    paranoid: true
