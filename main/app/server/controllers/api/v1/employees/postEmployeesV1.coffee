config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                     = require 'async'
uuid                      = require 'node-uuid'
ORM                       = require config.appRoot + 'server/components/oRM'
sequelize                 = ORM.setup()
_                         = require 'underscore'

module.exports = (app) ->

  employee = ORM.model 'employee'
  client   = ORM.model 'client'

  insertHelper = (objects, res) ->
    #Give everyone their own brand new uid
    for object, key in objects
      objects[key]['uid'] = uuid.v4()

    async.map objects, (item, callback) ->
      employee.create(item).success () ->
        callback()
    , (err, results) ->
      res.jsonAPIRespond(code: 201, message: config.apiResponseCodes[201])


  app.post config.apiSubDir + '/v1/employees', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, employee, req.body, req, res, {
              requiredProperties:

                'identifier': (val, objectKey, object, callback) ->

                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  employee.find(
                    where:
                      clientUid:  testClientUid
                      identifier: val
                  ).success (resultEmployee) ->

                    #Cant be duplicates
                    if resultEmployee
                      callback null,
                        success: false
                        message:
                          identifier: 'duplicate'
                    else
                      callback null,
                        success: true

                'firstName': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'lastName': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'email': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'phone': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'username': (val, objectKey, object, callback) ->

                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  employee.find(
                    where:
                      clientUid: testClientUid
                      username:  val
                  ).success (resultEmployee) ->

                    #Cant be duplicates
                    if resultEmployee
                      callback null,
                        success: false
                        message:
                          username: 'duplicate'
                    else
                      callback null,
                        success: true

                'password': (val, objectKey, object, callback) ->

                  if _.isUndefined(val) || val.length > 100
                    callback null,
                      success: false
                    return

                  #Convert string to hash
                  bcrypt.genSalt 10, (err, salt) ->
                    bcrypt.hash val, salt, (err, hash) ->
                      callback null,
                        success:   false
                        transform: [object, 'password', hash]

                'type': (val, objectKey, object, callback) ->

                  callback null,
                    success: false

                'clientUid': (val, objectKey, object, callback) ->

                  if _.isUndefined val

                    client.find(
                      where:
                        uid: clientUid
                    ).success (resultClient) ->

                      if resultClient
                        mapObj = {}
                        mapObj[resultClient.uid]   = resultClient
                        callback null,
                          success: true
                          uidMapping: mapObj
                          transform: [objectKey, 'clientUid', resultClient.uid]
                      else
                        callback null,
                          success: false
                          message:
                            clientUid: 'unknown'

                  else

                    client.find(
                      where:
                        uid: val
                    ).success (resultClient) ->

                      if resultClient
                        mapObj = {}
                        mapObj[resultClient.uid]   = resultClient
                        callback null,
                          success: true
                          uidMapping: mapObj
                          transform: [objectKey, 'clientUid', resultClient.uid]
                      else
                        callback null,
                          success: false
                          message:
                            clientUid: 'unknown'


            }, (objects) ->
              insertHelper objects, res



          when 'clientSuperAdmin'

            #CSA Can make other CSA
            apiVerifyObjectProperties this, employee, req.body, req, res, {
              requiredProperties:

                'identifier': (val, objectKey, object, callback) ->

                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  if _.isUndefined object['uid']
                    callback null,
                      success: false
                    return

                  employee.find(
                    where:
                      clientUid:  testClientUid
                      identifier: val
                  ).success (resultEmployee) ->

                    #Cant be duplicates
                    if resultEmployee && resultEmployee.uid != object['uid']
                      callback null,
                        success: false
                        message:
                          identifier: 'duplicate'
                    else
                      callback null,
                        success: true

                'firstName': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'lastName': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'email': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'phone': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'username': (val, objectKey, object, callback) ->

                  testClientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

                  async.parallel [
                    (callback) ->
                      client.find(
                        where:
                          uid: clientUid
                      ).success (resultClient) ->
                        callback null, resultClient

                    (callback) ->
                      employee.find(
                        where:
                          uid: val
                      ).success (resultEmployee) ->
                        callback null, resultEmployee


                  ], (error, results) ->

                    resultClient   = results[0]
                    resultEmployee = results[1]

                    if !resultEmployee
                      callback null,
                        success: false
                        message:
                          'employeeUid': 'unknown'
                      return

                    if !resultClient
                      callback null,
                        success: false
                        'clientUid': 'unknown'
                      return

                    #IF we do find the employee, but it doesn't belong to the same client...
                    if resultEmployee.clientUid != resultClient.uid
                      callback null,
                        success: false
                        message:
                          'employeeUid': 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultEmployee.uid] = resultEmployee
                    mapObj[resultClient.uid]   = resultClient
                    callback null,
                      success: true
                      uidMapping: mapObj
                      transform: [objectKey, 'clientUid', resultClient.uid]








                  if _.isUndefined object['uid']
                    callback null,
                      success: false
                    return

                  employee.find(
                    where:
                      clientUid: testClientUid
                      username:  val
                  ).success (resultEmployee) ->

                    #Cant be duplicates
                    if resultEmployee && resultEmployee.uid != object['uid']
                      callback null,
                        success: false
                        message:
                          username: 'duplicate'
                    else
                      callback null,
                        success: true

                'password': (val, objectKey, object, callback) ->

                  if _.isUndefined(val) || val.length > 100
                    callback null,
                      success: false
                    return

                  #Convert string to hash
                  bcrypt.genSalt 10, (err, salt) ->
                    bcrypt.hash val, salt, (err, hash) ->
                      callback null,
                        success:   false
                        transform: [object, 'password', hash]

                'type': (val, objectKey, object, callback) ->

                  if val == 'superAdmin'
                    callback null,
                      success: false
                      message:
                        type: 'invalid'
                    return

                  callback null,
                    success: false

            }, (objects) ->
              insertHelper objects, res




          when 'clientAdmin'




            #CSA Can make other CSA
            apiVerifyObjectProperties this, employee, req.body, req, res, {
              requiredProperties:

                'identifier': (val, objectKey, object, callback) ->

                  if _.isUndefined object['uid']
                    callback null,
                      success: false
                    return

                  employee.find(
                    where:
                      clientUid:  clientUid
                      identifier: val
                  ).success (resultEmployee) ->

                    #Cant be duplicates
                    if resultEmployee && resultEmployee.uid != object['uid']
                      callback null,
                        success: false
                        message:
                          identifier: 'duplicate'
                    else
                      callback null,
                        success: true

                'firstName': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'lastName': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'email': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'phone': (val, objectKey, object, callback) ->

                  callback null,
                    success: true

                'username': (val, objectKey, object, callback) ->

                  if _.isUndefined object['uid']
                    callback null,
                      success: false
                    return

                  employee.find(
                    where:
                      clientUid: clientUid
                      username:  val
                  ).success (resultEmployee) ->

                    #Cant be duplicates
                    if resultEmployee && resultEmployee.uid != object['uid']
                      callback null,
                        success: false
                        message:
                          username: 'duplicate'
                    else
                      callback null,
                        success: true

                'password': (val, objectKey, object, callback) ->

                  if _.isUndefined(val) || val.length > 100
                    callback null,
                      success: false
                    return

                  #Convert string to hash
                  bcrypt.genSalt 10, (err, salt) ->
                    bcrypt.hash val, salt, (err, hash) ->
                      callback null,
                        success:   false
                        transform: [object, 'password', hash]

                'type': (val, objectKey, object, callback) ->

                  if val == 'superAdmin' or val == 'clientSuperAdmin'
                    callback null,
                      success: false
                      message:
                        type: 'invalid'
                    return

                  callback null,
                    success: false

            }, (objects) ->
              insertHelper objects, res

          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]
