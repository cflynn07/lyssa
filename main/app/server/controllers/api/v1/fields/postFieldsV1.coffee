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

  group    = ORM.model 'group'
  template = ORM.model 'template'
  employee = ORM.model 'employee'
  client   = ORM.model 'client'
  revision = ORM.model 'revision'
  field    = ORM.model 'field'
  dictionary    = ORM.model 'dictionary'


  app.post config.apiSubDir + '/v1/fields', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid
        employeeUid = req.session.user.uid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, group, req.body, req, res, {
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

                'type': (val, objectKey, object, callback) ->

                  if !_.isUndefined val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        type: 'required'

                'ordinal': (val, objectKey, object, callback) ->
                  if !_.isUndefined val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        ordinal: 'required'

                'clientUid': (val, objectKey, object, callback) ->

                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  callback null,
                    success:   true
                    transform: [objectKey, 'clientUid', testClientUid]

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
                      success: false
                      message:
                        groupUid: 'required'
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
                      group.find(
                        where:
                          clientUid: testClientUid
                          uid: val
                      ).success (resultGroup) ->
                        callback null, resultGroup


                  ], (error, results) ->

                    resultClient   = results[0]
                    resultGroup    = results[1]

                    if !resultGroup
                      callback null,
                        success: false
                        message:
                          'groupUid': 'unknown'
                      return

                    if !resultClient
                      callback null,
                        success: false
                        'clientUid': 'unknown'
                      return

                    #IF we do find the employee, but it doesn't belong to the same client...
                    if resultGroup.clientUid != resultClient.uid
                      callback null,
                        success: false
                        message:
                          'groupUid': 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultGroup.uid]  = resultGroup
                    mapObj[resultClient.uid] = resultClient
                    callback null,
                      success: true
                      uidMapping: mapObj

            }, (objects) ->

              #insertHelper.call(this, objects, res)
              insertHelper 'fields', clientUid, field, objects, req, res, app

          when 'clientSuperAdmin', 'clientAdmin'

            apiVerifyObjectProperties this, group, req.body, req, res, {
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

                'type': (val, objectKey, object, callback) ->

                  if !_.isUndefined val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        type: 'required'

                'ordinal': (val, objectKey, object, callback) ->
                  if !_.isUndefined val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        ordinal: 'required'

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

                'dictionaryUid': (val, objectKey, object, callback) ->

                  if _.isUndefined(object['type'])
                    callback null,
                      success: false
                    return

                  testClientUid = clientUid

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
                      success: false
                      message:
                        groupUid: 'required'
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
                      group.find(
                        where:
                          clientUid: testClientUid
                          uid:       val
                      ).success (resultGroup) ->
                        callback null, resultGroup


                  ], (error, results) ->

                    resultClient   = results[0]
                    resultGroup    = results[1]

                    if !resultGroup
                      callback null,
                        success: false
                        message:
                          'groupUid': 'unknown'
                      return

                    if !resultClient
                      callback null,
                        success: false
                        'clientUid': 'unknown'
                      return

                    #IF we do find the employee, but it doesn't belong to the same client...
                    if resultGroup.clientUid != resultClient.uid
                      callback null,
                        success: false
                        message:
                          'groupUid': 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultGroup.uid]  = resultGroup
                    mapObj[resultClient.uid] = resultClient
                    callback null,
                      success: true
                      uidMapping: mapObj

            }, (objects) ->

              #insertHelper.call(this, objects, res)
              insertHelper 'fields', clientUid, field, objects, req, res, app




          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


