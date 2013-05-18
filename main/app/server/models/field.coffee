# field model

config = require '../config/config'
orm = require '../components/oRM'
SEQ = orm.SEQ

module.exports =
  model:
    id:      SEQ.INTEGER
    name:
      type:  SEQ.STRING
      validate:
        len: [5, 50]
    type:    SEQ.ENUM config.fieldTypes
    ordinal: SEQ.INTEGER

    multiSelectCorrectRequirement:
      type: SEQ.ENUM [
        'all'
        'any'
      ]
      defaultValue: 'any'

    clientUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true
    groupUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true
    dictionaryUid:
      type: SEQ.STRING
      validate:
        isUUID: 4

  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'belongsTo'
    model: 'group'
  ,
    relation: 'hasOne'
    model: 'dictionary'
  ,
    relation: 'hasMany'
    model: 'fieldCorrectDictionaryItem'
  ]
  options:
    paranoid: true
