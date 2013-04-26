config                    = require '../../../../config/config'
apiVerifyObjectProperties = require config.appRoot + 'server/components/apiVerifyObjectProperties'
apiAuth                   = require config.appRoot + 'server/components/apiAuth'
async                     = require 'async'
uuid                      = require 'node-uuid'
ORM                       = require config.appRoot + 'server/components/oRM'
sequelize                 = ORM.setup()
_                         = require 'underscore'

module.exports = (app) ->

  client = ORM.model 'client'

  insertHelper = (objects, res) ->
    #Give everyone their own brand new uid
    for object, key in objects
      objects[key]['uid'] = uuid.v4()

    async.map objects, (item, callback) ->
      client.create(item).success () ->
        callback()
    , (err, results) ->
      res.jsonAPIRespond(code: 201, message: config.apiResponseCodes[201])


  app.post config.apiSubDir + '/v1/clients', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType  = req.session.user.type
        clientUid = req.session.user.clientUid


        #Make sure no duplicate identifiers
        identifiers = []
        if _.isArray req.body
          for value in req.body
            if identifiers.indexOf(value.identifer) != -1
              res.jsonAPIRespond(code: 201, message: config.apiResponseCodes[201])
              return



        switch userType
          when 'superAdmin'

            apiVerifyObjectProperties this, client, req.body, req, res, {
              requiredProperties:
                'name': (val, objectKey, object, callback) ->
                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        name: 'required'

                'identifier': (val, objectKey, object, callback) ->
                  if val

                    #Make sure no duplicates
                    clients.find(
                      where:
                        identifier: val
                    ).success

                    callback null,
                      success: true

                  else
                    callback null,
                      success: false
                      message:
                        identifier: 'required'

                'address1':      (val, objectKey, object, callback) ->
                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        address1: 'required'

                'address2':      (val, objectKey, object, callback) ->
                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        address2: 'required'

                'address3':      (val, objectKey, object, callback) ->
                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        address3: 'required'

                'city':          (val, objectKey, object, callback) ->
                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        city: 'required'

                'stateProvince': (val, objectKey, object, callback) ->
                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        stateProvince: 'required'

                'country':       (val, objectKey, object, callback) ->
                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        country: 'required'

                'telephone':     (val, objectKey, object, callback) ->
                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        telephone: 'required'

                'fax':           (val, objectKey, object, callback) ->
                  if val
                    callback null,
                      success: true
                  else
                    callback null,
                      success: false
                      message:
                        fax: 'required'

            }, (objects) ->

              insertHelper.call(this, objects, res)


          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'
            res.jsonAPIRespond config.errorResponse(401)

    ]


