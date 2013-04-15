config              = require '../../../../config/config'
apiAuth             = require config.appRoot + '/server/components/apiAuth'
ORM                 = require config.appRoot + '/server/components/orm'
apiPostVerifyFields = require config.appRoot + '/server/components/apiPostVerifyFields'
sequelize           = ORM.setup()
async               = require 'async'
_                   = require 'underscore'
uuid                = require 'node-uuid'

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
            apiPostVerifyFields _this, template, req.body, req, res, {
              requiredProperties:
                'name':        (val, objectKey, callback) ->

                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        name: 'required'

                'type':        (val, objectKey, callback) ->

                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        type: 'required'

                'employeeUid': (val, objectKey, callback) ->

                  #check exists
                  employee.find(
                    where:
                      uid: val
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

                'clientUid': (val, objectKey, callback) ->

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

            }


          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'


            _this = this
            apiPostVerifyFields _this, template, req.body, req, res, {
              requiredProperties:
                'name':        (val, objectKey, callback) ->

                  #no special checks
                  callback null,
                    success: true

                'type':        (val, objectKey, callback) ->

                  #no special checks
                  callback null,
                    success: true

                'employeeUid': (val, objectKey, callback) ->

                  #check exists
                  employee.find(
                    where:
                      uid:       val
                      clientUid: clientUid  #<-- make sure to limit to session clientUid
                  ).success (employee) ->

                    if employee
                      callback null,
                        success: true
                    else
                      callback null,
                        success: false
                        message: {'employeeUid': 'unknown employeeUid'}

              'clientUid': (val, objectKey, callback) ->

                #For everyone besides superAdmins, they shouldn't be specifying clientUids
                if !_.isUndefined val
                  callback null,
                    success: false
                    message: {'clientUid': 'unknown property'}
                  return
                else
                  foo() #<-- use transform

            }


    ]


