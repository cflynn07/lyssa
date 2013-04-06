###
#  Verify access credentials
###

config       = require '../config/config'

module.exports = (req, res, callback) ->

  if req.requestType is 'http'

    #TEMP FOR debugging
    if (req.param and req.session)
      req.session.user =
        type: req.param('type')


    ## Token or session based authentication?
    if !req.session.user?
      res.jsonAPIRespond config.unauthorizedResponse

    else if config.authCategories.indexOf(req.session.user.type) is -1
      res.jsonAPIRespond config.unauthorizedResponse

    else
      #applyAuthBadge(req)
      callback()


  else if req.requestType is 'socketio'

    ## Session based authentication
    if !req.session.user?
      res.jsonAPIRespond config.unauthorizedResponse
    else if config.authCategories.indexOf(req.session.user.type) is -1
      res.jsonAPIRespond config.unauthorizedResponse
    else
      #applyAuthBadge(req)
      callback()
