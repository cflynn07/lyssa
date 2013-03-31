# employee model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
    model:
        id:         SEQ.INTEGER
        identifier: SEQ.STRING
        firstName:  SEQ.STRING
        lastName:   SEQ.STRING
        email:      SEQ.STRING
        phone:      SEQ.STRING
    relations:
        belongsTo: 'client'
    options: {}
