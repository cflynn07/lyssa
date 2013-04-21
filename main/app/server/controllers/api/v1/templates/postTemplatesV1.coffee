config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                     = require 'async'
uuid                      = require 'node-uuid'
ORM                       = require config.appRoot + 'server/components/oRM'
sequelize                 = ORM.setup()
_                         = require 'underscore'

module.exports = (app) ->

  template = ORM.model 'template'
  employee = ORM.model 'employee'
  client   = ORM.model 'client'


  insertHelper = (objects, res) ->
    #Give everyone their own brand new uid
    for object, key in objects
      objects[key]['uid'] = uuid.v4()

    async.map objects, (item, callback) ->
      template.create(item).success () ->
        callback()
    , (err, results) ->
      res.jsonAPIRespond(code: 201, message: config.apiResponseCodes[201])



  app.post config.apiSubDir + '/v1/templates', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid

        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, template, req.body, req, res, {
              requiredProperties:
                'name':        (val, objectKey, object, callback) ->

                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        name: 'required'

                'type':        (val, objectKey, object, callback) ->

                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        type: 'required'

                'employeeUid': (val, objectKey, object, callback) ->

                  if !val
                    callback null,
                      success: false
                      message:
                        employeeUid: 'required'
                    return

                  clientUid = if (!_.isUndefined object['clientUid']) then object['clientUid'] else clientUid

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


                'clientUid': (val, objectKey, object, callback) ->

                  #TODO: Verify legit client
                  callback null,
                    success: true
                  return


            }, (objects) ->

              insertHelper.call(this, objects, res)

          when 'clientSuperAdmin', 'clientAdmin'

            apiVerifyObjectProperties this, template, req.body, req, res, {
              requiredProperties:
                'name':        (val, objectKey, object, callback) ->

                  #no special checks
                  callback null,
                    success: true

                'type':        (val, objectKey, object, callback) ->

                  #no special checks
                  callback null,
                    success: true

                'employeeUid': (val, objectKey, object, callback) ->

                  where =
                    uid:       val
                    clientUid: clientUid

                  #check exists
                  employee.find(
                    where: where  #<-- make sure to limit to session clientUid
                  ).success (resultEmployee) ->

                    if resultEmployee
                      mapObj = {}
                      mapObj[resultEmployee.uid] = resultEmployee
                      callback null,
                        uidMapping: mapObj
                        success: true

                    else
                      callback null,
                        success: false
                        message:
                          employeeUid: 'unknown'

                'clientUid': (val, objectKey, object, callback) ->

                  #For everyone besides superAdmins, they shouldn't be specifying clientUids
                  if !_.isUndefined val
                    callback null,
                      success: false
                      message:
                        clientUid: 'unknown'
                    return
                  else
                    client.find(
                      where:
                        uid: clientUid
                    ).success (resultClient) ->
                      #This should never fail, apiAuth should block
                      mapObj = {}
                      mapObj[resultClient.uid] = resultClient
                      callback null,
                        success: true
                        uidMapping: mapObj
                        transform: [objectKey, 'clientUid', clientUid] #<-- take from session

            }, (objects) ->
              insertHelper.call(this, objects, res)


          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


