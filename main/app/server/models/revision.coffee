# revision model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
    model:
        id:             SEQ.INTEGER
        name:           SEQ.STRING
        changeSummary:  SEQ.TEXT
        type:           SEQ.STRING
    relations:
        belongsTo: 'client'
        belongsTo: 'user'
        hasMany: 'group'
    options: {}
