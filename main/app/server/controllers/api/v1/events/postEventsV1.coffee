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

  employee  = ORM.model 'employee'
  client    = ORM.model 'client'
  event     = ORM.model 'event'
  revision  = ORM.model 'revision'


  app.post config.apiSubDir + '/v1/events', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType    = req.session.user.type
        clientUid   = req.session.user.clientUid
        employeeUid = req.session.user.uid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, event, req.body, req, res, {
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


            }, (objects) ->

              #insertHelper.call(this, objects, res)
              insertHelper 'events', clientUid, event, objects, req, res, app

          when 'clientSuperAdmin', 'clientAdmin'

            apiVerifyObjectProperties this, event, req.body, req, res, {
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


            }, (objects) ->

              #insertHelper.call(this, objects, res)
              insertHelper 'events', clientUid, event, objects, req, res, app

          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]
