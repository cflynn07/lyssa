# field model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
    model:
        id:             SEQ.INTEGER
        name:           SEQ.STRING
        ordinal:        SEQ.INTEGER
    relations:
        belongsTo: 'revision'
        hasMany: 'field'
    options: {}
