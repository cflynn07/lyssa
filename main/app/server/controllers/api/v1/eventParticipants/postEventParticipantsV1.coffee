config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                     = require 'async'
uuid                      = require 'node-uuid'
ORM                       = require config.appRoot + 'server/components/oRM'
sequelize                 = ORM.setup()
_                         = require 'underscore'
insertHelper              = require config.appRoot + 'server/components/insertHelper'

module.exports = (app) ->

  employee         = ORM.model 'employee'
  client           = ORM.model 'client'
  event            = ORM.model 'event'
  eventParticipant = ORM.model 'eventParticipant'

  app.post config.apiSubDir + '/v1/eventparticipants', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType    = req.session.user.type
        clientUid   = req.session.user.clientUid
        employeeUid = req.session.user.uid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, eventParticipant, req.body, req, res, {
              requiredProperties:

                'clientUid': (val, objectKey, object, callback) ->

                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  callback null,
                    success:   true
                    transform: [objectKey, 'clientUid', testClientUid]

                'employeeUid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        employeeUid: 'required'
                    return

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

                'eventUid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        eventUid: 'required'
                    return

                  if _.isUndefined object['employeeUid']
                    callback null,
                      success: true
                    return


                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  async.parallel [
                    (callback) ->
                      client.find(
                        where:
                          uid: testClientUid
                      ).success (resultClient) ->
                        callback null, resultClient

                    (callback) ->
                      event.find(
                        where:
                          clientUid: testClientUid
                          uid:       val
                      ).success (resultEvent) ->
                        callback null, resultEvent

                    (callback) ->
                      eventParticipant.find(
                        where:
                          clientUid:   testClientUid
                          eventUid:    val
                          employeeUid: object['employeeUid']
                      ).success (resultEventParticipant) ->
                        callback null, resultEventParticipant

                  ], (error, results) ->

                    resultClient = results[0]
                    resultEvent  = results[1]
                    resultEventParticipant = results[2]

                    if resultEventParticipant
                      callback null,
                        success: false
                        message:
                          employeeUid: 'duplicate'
                      return

                    if !resultEvent
                      callback null,
                        success: false
                        message:
                          eventUid: 'unknown'
                      return

                    if !resultClient
                      callback null,
                        success: false
                        message:
                          clientUid: 'unknown'
                      return

                    #IF we do find the employee, but it doesn't belong to the same client...
                    if resultEvent.clientUid != resultClient.uid
                      callback null,
                        success: false
                        message:
                          eventUid: 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultEvent.uid]  = resultEvent
                    mapObj[resultClient.uid] = resultClient
                    callback null,
                      success: true
                      uidMapping: mapObj
                      transform: [objectKey, 'eventUid', val]

            }, (objects) ->

              #insertHelper.call(this, objects, res)
              insertHelper 'eventparticipants', clientUid, eventParticipant, objects, req, res, app

          when 'clientSuperAdmin', 'clientAdmin'

            apiVerifyObjectProperties this, eventParticipant, req.body, req, res, {
              requiredProperties:

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
                    callback null,
                      success: false
                      message:
                        employeeUid: 'required'
                    return


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

                'eventUid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        eventUid: 'required'
                    return

                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  async.parallel [
                    (callback) ->
                      client.find(
                        where:
                          uid: testClientUid
                      ).success (resultClient) ->
                        callback null, resultClient

                    (callback) ->
                      event.find(
                        where:
                          clientUid: testClientUid
                          uid:       val
                      ).success (resultEvent) ->
                        callback null, resultEvent

                    (callback) ->
                      eventParticipant.find(
                        where:
                          clientUid:   testClientUid
                          eventUid:    val
                          employeeUid: object['employeeUid']
                      ).success (resultEventParticipant) ->
                        callback null, resultEventParticipant

                  ], (error, results) ->

                    resultClient           = results[0]
                    resultEvent            = results[1]
                    resultEventParticipant = results[2]

                    if resultEventParticipant
                      callback null,
                        success: false
                        message:
                          employeeUid: 'duplicate'
                      return

                    if !resultEvent
                      callback null,
                        success: false
                        message:
                          eventUid: 'unknown'
                      return

                    if !resultClient
                      callback null,
                        success: false
                        message:
                          clientUid: 'unknown'
                      return

                    #IF we do find the employee, but it doesn't belong to the same client...
                    if resultEvent.clientUid != resultClient.uid
                      callback null,
                        success: false
                        message:
                          eventUid: 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultEvent.uid]  = resultEvent
                    mapObj[resultClient.uid] = resultClient
                    callback null,
                      success: true
                      uidMapping: mapObj
                      transform: [objectKey, 'eventUid', val]

            }, (objects) ->

              #insertHelper.call(this, objects, res)
              insertHelper 'eventparticipants', clientUid, eventParticipant, objects, req, res, app

          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]
