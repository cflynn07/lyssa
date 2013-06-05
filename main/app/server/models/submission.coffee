# submission model

orm = require '../components/oRM'
SEQ = orm.SEQ

module.exports =
  model:
    id: SEQ.INTEGER

    finalized: SEQ.BOOLEAN

    finalizedDateTime:
      type: SEQ.DATE
      validate:
        notNull: false

    clientUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true

    eventParticipantUid:
      type: SEQ.STRING
      validate:
        isUUID: 4
        notNull: true

  relations: [
    relation: 'belongsTo'
    model: 'client'
  ,
    relation: 'belongsTo'
    model: 'eventParticipant'
  ]
  options:
    paranoid: true
