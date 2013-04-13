###
#  Verify access credentials
###

config       = require '../config/config'

module.exports = (req, res, callback) ->


  if req.requestType is 'http'

    #TEMP FOR debugging
    if (req.query and req.session)
      req.session.user =
        req.query


    ## Token or session based authentication?
    if !req.session.user?
      res.jsonAPIRespond config.errorResponse(401)
    else if config.authCategories.indexOf(req.session.user.type) is -1
      res.jsonAPIRespond config.errorResponse(401)
    else
      #applyAuthBadge(req)
      callback()


  else if req.requestType is 'socketio'
    ## Session based authentication
    if !req.session.user?
      res.jsonAPIRespond config.errorResponse(401)
    else if config.authCategories.indexOf(req.session.user.type) is -1
      res.jsonAPIRespond config.errorResponse(401)
    else
      #applyAuthBadge(req)
      callback()

  else
    throw new Error()# 'requestType not set'
