config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                     = require 'async'
uuid                      = require 'node-uuid'
ORM                       = require config.appRoot + 'server/components/oRM'
sequelize                 = ORM.setup()
_                         = require 'underscore'

module.exports = (app) ->

  employee       = ORM.model 'employee'
  client         = ORM.model 'client'
  dictionary     = ORM.model 'dictionary'
  dictionaryItem = ORM.model 'dictionaryItem'


  insertHelper = (objects, res) ->
    #Give everyone their own brand new uid
    for object, key in objects
      objects[key]['uid'] = uuid.v4()

    async.map objects, (item, callback) ->
      dictionaryItem.create(item).success () ->
        callback()
    , (err, results) ->
      res.jsonAPIRespond(code: 201, message: config.apiResponseCodes[201])


  app.post config.apiSubDir + '/v1/dictionaryItems', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType    = req.session.user.type
        clientUid   = req.session.user.clientUid
        employeeUid = req.session.user.uid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, dictionaryItem, req.body, req, res, {
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

                'clientUid': (val, objectKey, object, callback) ->

                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  callback null,
                    success:   true
                    transform: [objectKey, 'clientUid', testClientUid]

                'dictionaryUid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        dictionaryUid: 'required'
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
                      dictionary.find(
                        where:
                          clientUid: testClientUid
                          uid:       val
                      ).success (resultDictionary) ->
                        callback null, resultDictionary


                  ], (error, results) ->

                    resultClient      = results[0]
                    resultDictionary  = results[1]

                    if !resultDictionary
                      callback null,
                        success: false
                        message:
                          'resultDictionary': 'unknown'
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
                          'resultDictionary': 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultDictionary.uid]  = resultDictionary
                    mapObj[resultClient.uid]      = resultClient
                    callback null,
                      success: true

                      uidMapping: mapObj


            }, (objects) ->

              insertHelper.call(this, objects, res)

          when 'clientSuperAdmin', 'clientAdmin'

            apiVerifyObjectProperties this, dictionaryItem, req.body, req, res, {
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

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        dictionaryUid: 'required'
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
                      dictionary.find(
                        where:
                          clientUid: testClientUid
                          uid:       val
                      ).success (resultDictionary) ->
                        callback null, resultDictionary

                  ], (error, results) ->

                    resultClient      = results[0]
                    resultDictionary  = results[1]

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
                          'dictionaryUid': 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultDictionary.uid]  = resultDictionary
                    mapObj[resultClient.uid]      = resultClient
                    callback null,
                      success: true
                      uidMapping: mapObj


            }, (objects) ->

              insertHelper.call(this, objects, res)

          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]
