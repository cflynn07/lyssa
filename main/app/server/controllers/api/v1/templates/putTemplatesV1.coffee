config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                     = require 'async'
uuid                      = require 'node-uuid'
ORM                       = require config.appRoot + 'server/components/oRM'
sequelize                 = ORM.setup()
_                         = require 'underscore'
updateHelper              = require config.appRoot + 'server/components/updateHelper'


module.exports = (app) ->

  template = ORM.model 'template'
  employee = ORM.model 'employee'


  app.put config.apiSubDir + '/v1/templates', (req, res) ->
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
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    template.find(
                      where:
                        uid: val
                    ).success (resultTemplate) ->

                      if resultTemplate
                        mapObj = {}
                        mapObj[val] = resultTemplate
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
                'employeeUid': (val, objectKey, object, callback) ->

                  #find this template by checking uid, check to see if uid is set
                  #find clientUid of this template, verify that it matches this employeeUid
                  uid = object['uid']
                  if _.isUndefined uid
                    callback null,
                      success: false
                    return

                  callbacks = []

                  ((val) ->

                    callbacks.push (callback) ->
                      employee.find(
                        where:
                          uid: val
                      ).success (resultEmployee) ->
                        callback null, resultEmployee

                    callbacks.push (callback) ->
                      template.find(
                        where:
                          uid: uid
                      ).success (resultTemplate) ->
                        callback null, resultTemplate

                  )(val)

                  async.parallel callbacks, (err, results) ->

                    resultEmployee = results[0]
                    resultTemplate = results[1]

                    if !resultEmployee
                      callback null,
                        success: false
                        message:
                          'employeeUid': 'unknown'
                      return

                    if !resultTemplate
                      callback null,
                        success: false
                      return

                    if resultEmployee.clientUid != resultTemplate.clientUid
                      callback null,
                        success: false
                        message:
                          'employeeUid': 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultEmployee.uid] = resultEmployee
                    callback null,
                      success: true
                      uidMapping: mapObj


            }, (objects) ->

              updateHelper template, objects, res, app


          when 'clientSuperAdmin', 'clientAdmin'

            apiVerifyObjectProperties this, template, req.body, req, res, {
              requiredProperties:
                'uid': (val, objectKey, object, callback) ->

                  if _.isUndefined val
                    callback null,
                      success: false
                      message:
                        uid: 'required'
                  else

                    template.find(
                      where:
                        uid: val
                        clientUid: clientUid #<-- restrict to session
                    ).success (resultTemplate) ->

                      if resultTemplate
                        mapObj = {}
                        mapObj[val] = resultTemplate
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
                'employeeUid': (val, objectKey, object, callback) ->

                  #find this template by checking uid, check to see if uid is set
                  #find clientUid of this template, verify that it matches this employeeUid
                  uid = object['uid']
                  if _.isUndefined uid
                    callback null,
                      success: false
                    return

                  callbacks = []

                  ((val) ->

                    callbacks.push (callback) ->
                      employee.find(
                        where:
                          uid: val
                          clientUid: clientUid
                      ).success (resultEmployee) ->
                        callback null, resultEmployee

                    callbacks.push (callback) ->
                      template.find(
                        where:
                          uid: uid
                          clientUid: clientUid
                      ).success (resultTemplate) ->
                        callback null, resultTemplate

                  )(val)

                  async.parallel callbacks, (err, results) ->

                    resultEmployee = results[0]
                    resultTemplate = results[1]

                    if !resultEmployee
                      callback null,
                        success: false
                        message:
                          employeeUid: 'unknown'
                      return

                    if !resultTemplate
                      callback null,
                        success: false
                      return

                    if resultEmployee.clientUid != resultTemplate.clientUid
                      callback null,
                        success: false
                        message:
                          employeeUid: 'unknown'
                      return

                    mapObj = {}
                    mapObj[resultEmployee.uid] = resultEmployee
                    callback null,
                      success: true
                      uidMapping: mapObj

            }, (objects) ->

              updateHelper template, objects, res, app


          when 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


