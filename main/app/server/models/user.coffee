# client model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
    model:
        id:       SEQ.INTEGER
        username: SEQ.STRING
        password: SEQ.STRING
        type:     SEQ.STRING
    relations:
        belongsTo: 'employee'
    options: {}
