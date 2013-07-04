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

  client   = ORM.model 'client'
  activity = ORM.model 'activity'

  app.post config.apiSubDir + '/v1/activityreadstate', (req, res) ->
    async.series [
      (callback) ->
        apiAuth req, res, callback
      (callback) ->

        userType    = req.session.user.type
        clientUid   = req.session.user.clientUid
        employeeUid = req.session.user.uid

        customInsertMethod = (body, req, res, app) ->
          if !_.isArray(body)
            body = [body]

          for activityUid in body
            if !_.isString(activityUid)
              res.jsonAPIRespond config.apiErrorResponse('unknownRootResourceId')
              return

          for activityUid in body
            try

              ((activityUid) ->
                sequelize.query("INSERT INTO activitiesReadState VALUES (NULL, \'" + employeeUid + "\', \'" + activityUid + "\', \'" + clientUid + "\')", null, {raw:true}).done (err, queryResults) ->
                  activity.find(
                    where:
                      uid: activityUid
                  ).success (activityResult) ->
                    if !activityResult
                      return
                    if _.isArray activityResult
                      activityResult = activityResult[0]
                    if !_.isUndefined(app.io) and _.isFunction(app.io.room)

                      activityResult = JSON.parse(JSON.stringify(activityResult))
                      activityResult.readState = true

                      app.io.room(employeeUid + '-' + activityResult.uid).broadcast 'resourcePut', {uid: activityResult.uid, readState: true}

                      #Wont quite work yet for ^
                      #config.apiBroadcastPut(resource, resultResource, app, req, res)

                )(activityUid)

            catch e
              console.log e

          res.jsonAPIRespond config.response(201)


        switch userType
          when 'superAdmin'

            customInsertMethod(req.body, req, res, app)

          when 'clientSuperAdmin', 'clientAdmin', 'clientDelegate', 'clientAuditor'

            customInsertMethod(req.body, req, res, app)

    ]


