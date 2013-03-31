# field model

orm = require '../components/orm'
SEQ = orm.SEQ

module.exports =
    model:
        id:             SEQ.INTEGER
        name:           SEQ.STRING
        type:
            type:       SEQ.STRING
            validate:
                isValidExerciseType: (v) ->
                    [
                        'openResponse'
                        'selectIndividual'
                        'selectMultiple'
                        'yesNo'
                        'slider'
                    ].indexOf(v) is not -1
    relations: {}
    options: {}
