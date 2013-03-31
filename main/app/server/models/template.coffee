# exerciseTemplate model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
    model:
        id:                     SEQ.INTEGER
        name:                   SEQ.STRING
        objective:              SEQ.TEXT
        scopeRequirements:      SEQ.TEXT
        recoveryPointObjective: SEQ.INTEGER
        recoveryTimeObjective:  SEQ.INTEGER
        type:
            type:   SEQ.STRING
            validate:
                isValidExerciseType: (v) ->
                    (v is 'mini' || v is 'full')

    relations:
        belongsTo: 'client'
        belongsTo: 'user'
    options: {}
