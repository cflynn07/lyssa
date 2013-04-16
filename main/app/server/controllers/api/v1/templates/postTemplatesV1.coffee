config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                 = require 'async'
uuid                  = require 'node-uuid'
ORM                   = require config.appRoot + 'server/components/oRM'
sequelize             = ORM.setup()
_                     = require 'underscore'

module.exports = (app) ->

  template = ORM.model 'template'
  employee = ORM.model 'employee'
  client   = ORM.model 'client'

  app.post config.apiSubDir + '/v1/templates', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->


        userType  = req.session.user.type
        clientUid = req.session.user.clientUid



        switch userType
          when 'superAdmin'


            _this = this
            apiVerifyObjectProperties _this, template, req.body, req, res, {
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

                  where =
                    uid: val

                  console.log 'employeeUid'
                  console.log where

                  #Prevent mismatch between employee clientUid and clientUid of template
                  if !_.isUndefined object['clientUid']
                    where['clientUid'] = object['clientUid']
                  else
                    where['clientUid'] = clientUid #<-- use from session

                  #check exists
                  employee.find(
                    where: where
                  ).success (employee) ->

                    if employee

                      uidMap      = {}
                      uidMap[val] = employee.id

                      callback null,
                        success: true
                        mapping: uidMap

                    else

                      callback null,
                        success: false
                        message: {'employeeUid': 'unknown employeeUid'}

                'clientUid': (val, objectKey, object, callback) ->

                  if !val

                    #For superAdmins, not required to specify clientUid. It will assume to use session clientUid
                    client.find(
                      where:
                        uid: clientUid    #<-- take from session
                    ).success (client) ->

                      uidMap            = {}
                      uidMap[clientUid] = client.id

                      callback null,
                        success:   true
                        mapping:   uidMap
                        transform: [objectKey, 'clientUid', clientUid]

                  else

                    #check exists
                    client.find(
                      where:
                        uid: val
                    ).success (client) ->

                      if client

                        uidMap      = {}
                        uidMap[val] = client.id

                        callback null,
                          success: true
                          mapping: uidMap

                      else

                        callback null,
                          success: false
                          message: {'clientUid': 'unknown clientUid'}

            }, (objects) ->

              #Give everyone their own brand new uid
              for object, key in objects
                objects[key]['uid'] = uuid.v4()

              async.map objects, (item, callback) ->
                template.create(item).success () ->
                  callback()
              , (err, results) ->
                res.jsonAPIRespond(code: 201, message: config.apiResponseCodes[201])












          when 'clientSuperAdmin', 'clientAdmin'


            _this = this
            apiPostValidateFields _this, template, req.body, req, res, {
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
                  ).success (employee) ->

                    if employee
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message: {'employeeUid': 'unknown employeeUid'}

                'clientUid': (val, objectKey, object, callback) ->

                  #For everyone besides superAdmins, they shouldn't be specifying clientUids
                  if !_.isUndefined val
                    callback null,
                      success: false
                      message: {'clientUid': 'unknown property'}
                    return
                  else
                    foo() #<-- use transform

            }


          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


