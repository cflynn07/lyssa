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

  app.post config.apiSubDir + '/v1/submissions', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType    = req.session.user.type
        clientUid   = req.session.user.clientUid
        employeeUid = req.session.user.uid


      #  config.resourceModelUnknownFieldsExceptions['submission'] = ['submissionFields']













        switch userType
          when 'superAdmin'

            insertMethod = (item, insertMethodCallback = false) ->
              apiVerifyObjectProperties this, submission, item, req, res, insertMethodCallback, {
                requiredProperties:
                  'name': (val, objectKey, object, callback) ->

                    if !_.isUndefined val
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message:
                          name: 'required'

                  'dateTime': (val, objectKey, object, callback) ->

                    if !_.isUndefined val
                      callback null,
                        success: true
                        transform: [objectKey, 'dateTime', (new Date(val))]
                    else
                      callback null,
                        success: false
                        message:
                          dateTime: 'required'

                  'revisionUid': (val, objectKey, object, callback) ->

                    if _.isUndefined val
                      callback null,
                        success: false
                        message:
                          revisionUid: 'required'
                      return

                    testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                    revision.find(
                      where:
                        uid: val
                        clientUid: testClientUid
                    ).success (resultRevision) ->
                      if !resultRevision
                        callback null,
                          success: false
                          message:
                            revisionUid: 'unknown'
                      else
                        mapObj = {}
                        mapObj[resultRevision.uid]  = resultRevision
                        callback null,
                          success: true
                          uidMapping: mapObj
                          transform: [objectKey, 'revisionUid', val]

                  'clientUid': (val, objectKey, object, callback) ->

                    testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                    callback null,
                      success:   true
                      transform: [objectKey, 'clientUid', testClientUid]

                  'employeeUid': (val, objectKey, object, callback) ->

                    if _.isUndefined val
                      val = employeeUid

                    testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                    async.parallel [
                      (callback) ->
                        client.find(
                          where:
                            uid: testClientUid
                        ).success (resultClient) ->
                          callback null, resultClient

                      (callback) ->
                        employee.find(
                          where:
                            clientUid: testClientUid
                            uid:       val
                        ).success (resultEmployee) ->
                          callback null, resultEmployee

                    ], (error, results) ->

                      resultClient      = results[0]
                      resultEmployee  = results[1]

                      if !resultEmployee
                        callback null,
                          success: false
                          message:
                            employeeUid: 'unknown'
                        return

                      if !resultClient
                        callback null,
                          success: false
                          message:
                            clientUid: 'unknown'
                        return

                      #IF we do find the employee, but it doesn't belong to the same client...
                      if resultEmployee.clientUid != resultClient.uid
                        callback null,
                          success: false
                          message:
                            employeeUid: 'unknown'
                        return

                      mapObj = {}
                      mapObj[resultEmployee.uid]  = resultEmployee
                      mapObj[resultClient.uid]      = resultClient
                      callback null,
                        success: true
                        uidMapping: mapObj
                        transform: [objectKey, 'employeeUid', val]


                  'participantsUids': (val, objectKey, object, callback) ->
                    checkParticipantsUidsHelper(val, objectKey, object, callback)


              }, (objects) ->

                #insertHelper.call(this, objects, res)
                insertHelper 'events', clientUid, event, objects, req, res, app, (uid) ->

                  redisClient.publish 'eventCronChannel', uid

                  insertEventParticipantsHelper uid, objects, (uid) ->

                    if _.isFunction(insertMethodCallback)
                      insertMethodCallback.call(this, uid)
                    else
                      config.apiSuccessPostResponse res, uid


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
              apiVerifyObjectProperties this, submission, item, req, res, insertMethodCallback, {
                requiredProperties:
                  'name': (val, objectKey, object, callback) ->

                    if !_.isUndefined val
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message:
                          name: 'required'

                  'dateTime': (val, objectKey, object, callback) ->

                    if !_.isUndefined val
                      callback null,
                        success: true
                        transform: [objectKey, 'dateTime', (new Date(val))]
                    else
                      callback null,
                        success: false
                        message:
                          dateTime: 'required'

                  'revisionUid': (val, objectKey, object, callback) ->

                    if _.isUndefined val
                      callback null,
                        success: false
                        message:
                          revisionUid: 'required'
                      return

                    #testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                    testClientUid = clientUid

                    revision.find(
                      where:
                        uid: val
                        clientUid: testClientUid
                    ).success (resultRevision) ->
                      if !resultRevision
                        callback null,
                          success: false
                          message:
                            revisionUid: 'unknown'
                      else
                        mapObj = {}
                        mapObj[resultRevision.uid]  = resultRevision
                        callback null,
                          success: true
                          uidMapping: mapObj
                          transform: [objectKey, 'revisionUid', val]

                  'clientUid': (val, objectKey, object, callback) ->

                    if !_.isUndefined val
                      callback null,
                        success: false
                        message:
                          clientUid: 'unknown'
                      return

                    testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                    callback null,
                      success:   true
                      transform: [objectKey, 'clientUid', testClientUid]

                  'employeeUid': (val, objectKey, object, callback) ->

                    if _.isUndefined val
                      val = employeeUid

                    testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                    async.parallel [
                      (callback) ->
                        client.find(
                          where:
                            uid: testClientUid
                        ).success (resultClient) ->
                          callback null, resultClient

                      (callback) ->
                        employee.find(
                          where:
                            clientUid: testClientUid
                            uid:       val
                        ).success (resultEmployee) ->
                          callback null, resultEmployee

                    ], (error, results) ->

                      resultClient   = results[0]
                      resultEmployee = results[1]

                      if !resultEmployee
                        callback null,
                          success: false
                          message:
                            employeeUid: 'unknown'
                        return

                      if !resultClient
                        callback null,
                          success: false
                          message:
                            clientUid: 'unknown'
                        return

                      #IF we do find the employee, but it doesn't belong to the same client...
                      if resultEmployee.clientUid != resultClient.uid
                        callback null,
                          success: false
                          message:
                            employeeUid: 'unknown'
                        return

                      mapObj = {}
                      mapObj[resultEmployee.uid]  = resultEmployee
                      mapObj[resultClient.uid]      = resultClient
                      callback null,
                        success:    true
                        uidMapping: mapObj
                        transform:  [objectKey, 'employeeUid', val]



                  'participantsUids': (val, objectKey, object, callback) ->
                    checkParticipantsUidsHelper(val, objectKey, object, callback)



              }, (objects) ->

                #insertHelper.call(this, objects, res)
                insertHelper 'events', clientUid, event, objects, req, res, app, (uid) ->
                  #hardwire in here

                  redisClient.publish 'eventCronChannel', uid

                  insertEventParticipantsHelper uid, objects, (uid) ->

                    if _.isFunction(insertMethodCallback)
                      insertMethodCallback.call(this, uid)
                    else
                      config.apiSuccessPostResponse res, uid



            if _.isArray req.body
              async.mapSeries req.body, (item, callback) ->
                insertMethod item, (createdUid) ->
                  callback null, createdUid
              , (err, results) ->
                config.apiSuccessPostResponse res, results
            else
              insertMethod req.body, (uid) ->


                if _.isString(uid) && _.isUndefined(uid.code)
                  config.apiSuccessPostResponse res, uid

                  activityInsert {
                    type:        'createEvent'
                    eventUid:    uid
                    employeeUid: employeeUid
                    clientUid:   clientUid
                  }, app, req

                else
                  res.jsonAPIRespond uid

    ]
