config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                     = require 'async'
uuid                      = require 'node-uuid'
ORM                       = require config.appRoot + 'server/components/oRM'
sequelize                 = ORM.setup()
_                         = require 'underscore'
bcrypt                    = require 'bcrypt'
updateHelper              = require config.appRoot + 'server/components/updateHelper'


module.exports = (app) ->

  client = ORM.model 'client'
  field  = ORM.model 'field'
  group  = ORM.model 'group'

  app.put config.apiSubDir + '/v1/fields', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid
        employeeUid = req.session.user.uid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, field, req.body, req, res, {
              requiredProperties:

                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'

                  else
                    field.find(
                      where:
                        uid: val
                    ).success (resultField) ->

                      if resultField
                        mapObj = {}
                        mapObj[val] = resultField
                        callback null,
                          success: true
                          uidMapping: mapObj
                      else
                        callback null,
                          success: false
                          message:
                            uid: 'unknown'

                'name': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'type': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'ordinal': (val, objectKey, object, callback) ->

                  callback null,
                    success: true





                'dictionaryUid': (val, objectKey, object, callback) ->





                  if _.isUndefined(object['type'])
                    callback null,
                      success: false
                    return

                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  fieldType = object['type']
                  switch fieldType
                    when 'selectIndividual'
                      #DictionaryUid required

                      if _.isUndefined val
                        callback null,
                          success: false
                          message:
                            dictionaryUid: 'required'
                        return

                      async.parallel [
                        (callback) ->
                          client.find(
                            where:
                              uid: testClientUid
                          ).success (resultClient) ->
                            callback null, resultClient

                        (callback) ->
                          dictionary.find(
                            where:
                              clientUid: testClientUid
                              uid: val
                          ).success (resultDictionary) ->
                            callback null, resultDictionary

                      ], (error, results) ->

                        resultClient     = results[0]
                        resultDictionary = results[1]

                        if !resultDictionary
                          callback null,
                            success: false
                            message:
                              'dictionaryUid': 'unknown'
                          return

                        if !resultClient
                          callback null,
                            success: false
                            'clientUid': 'unknown'
                          return

                        #IF we do find the employee, but it doesn't belong to the same client...
                        if resultDictionary.clientUid != resultClient.uid
                          callback null,
                            success: false
                            message:
                              'groupUid': 'unknown'
                          return

                        mapObj = {}
                        mapObj[resultDictionary.uid]  = resultDictionary
                        mapObj[resultClient.uid]      = resultClient
                        callback null,
                          success: true
                          uidMapping: mapObj

                    else
                      #No dictionaryUid for fields that don't make sense
                      callback null,
                        success: false
                        transform: [objectKey, 'dictionaryUid', null]







                'groupUid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: true
                    return

                  if _.isUndefined object['uid']
                    callback null,
                      success: true
                    return

                  async.parallel [

                    (callback) ->
                      field.find(
                        where:
                          uid: object['uid']
                      ).success (resultField) ->
                        callback null, resultField

                    (callback) ->
                      group.find(
                        where:
                          uid: val
                      ).success (resultGroup) ->
                        callback null, resultGroup


                  ], (error, results) ->

                    resultField = results[0]
                    resultGroup = results[1]

                    if !resultGroup
                      callback null,
                        success: false
                        message:
                          'groupUid': 'unknown'
                      return

                    if !resultField
                      callback null,
                        success: true
                      return

                    #IF we do find the employee, but it doesn't belong to the same client...
                    if resultGroup.clientUid != resultField.clientUid
                      callback null,
                        success: false
                        message:
                          'groupUid': 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultGroup.uid] = resultGroup
                    mapObj[resultField.uid] = resultField
                    callback null,
                      success: true
                      uidMapping: mapObj

            }, (objects) ->

              updateHelper field, objects, req, res, app


          when 'clientSuperAdmin', 'clientAdmin'

            apiVerifyObjectProperties this, field, req.body, req, res, {
              requiredProperties:

                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'

                  else
                    field.find(
                      where:
                        clientUid: clientUid
                        uid:       val
                    ).success (resultField) ->

                      if resultField
                        mapObj = {}
                        mapObj[val] = resultField
                        callback null,
                          success: true
                          uidMapping: mapObj
                      else
                        callback null,
                          success: false
                          message:
                            uid: 'unknown'

                'name': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'type': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'ordinal': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'groupUid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: true
                    return

                  if _.isUndefined object['uid']
                    callback null,
                      success: true
                    return

                  async.parallel [

                    (callback) ->
                      field.find(
                        where:
                          uid: object['uid']
                      ).success (resultField) ->
                        callback null, resultField

                    (callback) ->
                      group.find(
                        where:
                          clientUid: clientUid
                          uid:       val
                      ).success (resultGroup) ->
                        callback null, resultGroup


                  ], (error, results) ->

                    resultField = results[0]
                    resultGroup = results[1]

                    if !resultGroup
                      callback null,
                        success: false
                        message:
                          'groupUid': 'unknown'
                      return

                    if !resultField
                      callback null,
                        success: true
                      return

                    #IF we do find the employee, but it doesn't belong to the same client...
                    if resultGroup.clientUid != resultField.clientUid
                      callback null,
                        success: false
                        message:
                          'groupUid': 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultGroup.uid] = resultGroup
                    mapObj[resultField.uid] = resultField
                    callback null,
                      success: true
                      uidMapping: mapObj

            }, (objects) ->

              updateHelper field, objects, req, res, app

          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]
