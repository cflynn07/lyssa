config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                     = require 'async'
uuid                      = require 'node-uuid'
ORM                       = require config.appRoot + 'server/components/oRM'
sequelize                 = ORM.setup()
_                         = require 'underscore'
insertHelper              = require config.appRoot + 'server/components/insertHelper'
activityInsert            = require config.appRoot + 'server/components/activityInsert'


redisClient  = require(config.appRoot + 'server/config/redis').createClient()


module.exports = (app) ->

  employee         = ORM.model 'employee'
  client           = ORM.model 'client'
  event            = ORM.model 'event'
  revision         = ORM.model 'revision'
  eventParticipant = ORM.model 'eventParticipant'
  submission       = ORM.model 'submission'
  submissionField  = ORM.model 'submissionField'
  field            = ORM.model 'field'
  group            = ORM.model 'group'

  app.put config.apiSubDir + '/v1/submissionfields', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType    = req.session.user.type
        clientUid   = req.session.user.clientUid
        employeeUid = req.session.user.uid

      #  config.resourceModelUnknownFieldsExceptions['submission'] = ['submissionFields']

        helperCheckFieldUid = (val, objectKey, object, callback) ->
          eventParticipantUid = object['eventParticipantUid']
          fieldUid            = val

          if _.isUndefined(fieldUid)
            callback null,
              success: false
              message:
                fieldUid: 'required'
            return

          if _.isUndefined(eventParticipantUid)
            callback null,
              success: false
            return

          async.parallel [
            (subCallback) ->

              eventParticipant.find(
                where:
                  uid:         eventParticipantUid
                  clientUid:   clientUid
                  employeeUid: employeeUid
              ).success (resultEventParticipant) ->

                if !resultEventParticipant
                  subCallback null, [resultEventParticipant]
                  return

                event.find(
                  where:
                    uid: resultEventParticipant.eventUid
                    clientUid: clientUid
                ).success (resultEvent) ->
                  subCallback null, [resultEventParticipant, resultEvent]

            (subCallback) ->
              field.find(
                where:
                  uid: fieldUid
                  clientUid: clientUid
              ).success (resultField) ->

                if !resultField
                  subCallback null, [resultField]
                  return

                group.find(
                  where:
                    uid:       resultField.groupUid
                    clientUid: clientUid
                ).success (resultGroup) ->

                  if !resultGroup
                    subCallback null, [resultGroup]
                    return

                  revision.find(
                    where:
                      uid:       resultGroup.revisionUid
                      clientUid: clientUid
                  ).success (resultRevision) ->

                    if !resultRevision
                      subCallback null, [resultRevision]
                      return

                    subCallback null, [resultField, resultGroup, resultRevision]

          ], (err, results) ->
            resultEventParticipant = results[0][0]
            resultField            = results[1][0]
            if resultEventParticipant
              resultEvent            = results[0][1]

            if resultField
              resultGroup            = results[1][1]
              resultRevision         = results[1][2]

            messages = {}

            if !resultField
              messages.resultField = 'unknown'

            if !resultEventParticipant
              messages.resultEventParticipant = 'unknown'

            if !(resultEvent) || !(resultRevision) || (resultRevision.uid != resultEvent.revisionUid)
              messages.resultEventParticipant = 'unknown'
              messages.resultField            = 'unknown'

            if Object.keys(messages).length > 0

              callback null,
                success: false
                message: messages

            else
              mapObj = {}
              mapObj[resultEventParticipant.uid] = resultEventParticipant
              mapObj[resultField.uid]            = resultField
              mapObj[resultGroup.uid]            = resultGroup
              mapObj[resultRevision.uid]         = resultRevision
              mapObj[resultEvent.uid]            = resultEvent
              callback null,
                success: true
                uidMapping: mapObj

        helperCheckEventParticipantUid = (val, objectKey, object, callback) ->
          if _.isUndefined(val)
            callback null,
              success: false
              message:
                eventParticipantUid: 'required'
            return
          callback null,
            success: true
          return










        switch userType
          when 'superAdmin'

            insertMethod = (item, insertMethodCallback = false) ->
              apiVerifyObjectProperties this, submissionField, item, req, res, insertMethodCallback, {
                requiredProperties:
                  'openResponseValue': (val, objectKey, object, callback) ->
                    if !_.isUndefined val
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message:
                          openResponseValue: 'required'

                  'sliderValue': (val, objectKey, object, callback) ->
                    if !_.isUndefined val
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message:
                          sliderValue: 'required'

                  'yesNoValue': (val, objectKey, object, callback) ->
                    if !_.isUndefined val
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message:
                          yesNoValue: 'required'

                  'clientUid': (val, objectKey, object, callback) ->
                    if !_.isUndefined(val)
                      callback null,
                        success: false
                        message:
                          clientUid: 'invalid'
                      return

                    callback null,
                      success: true

                  'fieldUid': (val, objectKey, object, callback) ->
                    helperCheckFieldUid val, objectKey, object, callback

                  'eventParticipantUid': (val, objectKey, object, callback) ->
                    helperCheckEventParticipantUid val, objectKey, object, callback

              }, (objects) ->

                console.log 'objects'
                console.log objects

            if _.isArray req.body
              async.mapSeries req.body, (item, callback) ->
                insertMethod item, (createdUid) ->
                  callback null, createdUid
              , (err, results) ->
                config.apiSuccessPostResponse res, results

            else
              insertMethod(req.body)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            insertMethod = (item, insertMethodCallback = false) ->
              apiVerifyObjectProperties this, submissionField, item, req, res, insertMethodCallback, {
                requiredProperties:
                  'openResponseValue': (val, objectKey, object, callback) ->

                    if !_.isUndefined val
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message:
                          openResponseValue: 'required'

                  'sliderValue': (val, objectKey, object, callback) ->
                    if !_.isUndefined val
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message:
                          sliderValue: 'required'

                  'yesNoValue': (val, objectKey, object, callback) ->
                    if !_.isUndefined val
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message:
                          yesNoValue: 'required'

                  'clientUid': (val, objectKey, object, callback) ->
                    if !_.isUndefined(val)
                      callback null,
                        success: false
                        message:
                          clientUid: 'invalid'
                      return

                    callback null,
                      success: true

                  'fieldUid': (val, objectKey, object, callback) ->
                    helperCheckFieldUid val, objectKey, object, callback

                  'eventParticipantUid': (val, objectKey, object, callback) ->
                    helperCheckEventParticipantUid val, objectKey, object, callback

              }, (objects) ->

                console.log 'objects'
                console.log objects


            if _.isArray req.body
              async.mapSeries req.body, (item, callback) ->
                insertMethod item, (createdUid) ->
                  callback null, createdUid
              , (err, results) ->
                config.apiSuccessPostResponse res, results

            else
              insertMethod(req.body)

    ]
